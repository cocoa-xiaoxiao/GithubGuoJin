//
//  XYDJViewController.m
//  StoryboardTest
//
//  Created by mxsm on 16/4/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "XYDJViewController.h"
#import "ZXChatBoxController.h"
#import "ZXChatMessageController.h"
#import "ZXMessageModel.h"
#import "TLUserHelper.h"
#import "People.h"
#import "PhoneInfo.h"
#import "AizenMD5.h"
#import "HTTPOpration.h"
#import <IQKeyboardManager/IQKeyboardManager.h>


@interface XYDJViewController ()<ZXChatMessageControllerDelegate,ZXChatBoxViewControllerDelegate>
{
    CGFloat viewHeight;
}

@property(nonatomic,strong)ZXChatMessageController * chatMessageVC;
@property(nonatomic,strong)ZXChatBoxController * chatBoxVC;
@property(nonatomic,strong)UIButton * button;
@end

@implementation XYDJViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    UIBarButtonItem * barButton= [[UIBarButtonItem alloc]initWithCustomView:self.button];
//    self.navigationItem.leftBarButtonItem = barButton;
    
    
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self setHidesBottomBarWhenPushed:YES];
    
    // 主屏幕的高度减去导航的高度，减去状态栏的高度。在PCH头文件
    viewHeight = HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR;
    [self.view  addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
   
    [self.view  addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];
    self.chatBoxVC.chatBox.isNeedMore = NO;
    self.chatBoxVC.chatBox.isNeedFace = NO;
    self.chatBoxVC.chatBox.isNeedSound = NO;
    [self.chatBoxVC.chatBox br_configSubView];

   // [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];

//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //self.chatBoxVC
}


- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    /**
     *  如果状态栏背景为浅色，应选用黑色字样式(UIStatusBarStyleDefault，默认值),如果背景为深色，则选用白色字样式(UIStatusBarStyleLightContent)。
     UIApplication 一个APP只有一个，你在这里可以设置应用级别的设置，就像上面的实例一样，详细见http://www.cnblogs.com/wendingding/p/3766347.html
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].enable = NO;
       [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
//    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];

}

/**
 * TLChatMessageViewControllerDelegate 的代理方法
 */
#pragma mark - TLChatMessageViewControllerDelegate
- (void) didTapChatMessageView:(ZXChatMessageController *)chatMessageViewController
{
    
    [self.chatBoxVC resignFirstResponder];

}

/**
 * TLChatBoxViewControllerDelegate 的代理方法
 */

- (void)br_sendAMessage:(ZXMessageModel *)msgModel block:(void(^)(BOOL end,NSString *msg))block{
    /*
     测试路径:http://www.hzp1123.com/ApiSystem/SendMessage
     
     参数：[Display(Name = "发送人ID")]int Creater
     
     [Display(Name = "接收人ID")]int Updater
     
     [Display(Name = "消息内容")]string MessageContent
     
     [Display(Name = "时间戳")] string TimeStamp
     
     [Display(Name = "握手密钥")] string Token
     
     Token加密方式：Creater+"GJMessage"+Updater+TimeStamp
     */
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/SendMessage",kCacheHttpRoot];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *Updater = self.user.userID;
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJMessage%@%@",CurrAdminID,Updater,CurrTimeStamp]];
    
    NSString *MessageContent = [msgModel.text copy];
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:@{@"Creater":getObj.USERID,@"Updater":Updater,@"MessageContent":msgModel.text,@"TimeStamp":CurrTimeStamp,@"Token":CurrToken} WithReturnValeuBlock:^(HTTPData *data) {
        if (block) {
            block(YES,MessageContent);
        }
    } WithFailureBlock:^(id error) {
        msgModel.sendState = ZXMessageSendFail;
        if (block) {
            block(NO,@"");
        }
        [BaseViewController br_showAlterMsg:@"发送失败"];
    }];
    
    
}
#pragma mark - TLChatBoxViewControllerDelegate
- (void)chatBoxViewController:(ZXChatBoxController *)chatboxViewController sendMessage:(ZXMessageModel *)message
{
    // TLMessage 发送的消息数据模型
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    
    message.from = self.user;//[TLUserHelper sharedUserHelper].user;
    message.imageURL = [getObj.FactUrl fullImg];
    /**
     *  这个控制器添加了 chatMessageVC 这个控制器作为子控制器。在这个子控制器上面添加聊天消息的cell
     TLChatBox 的代理 TLChatBoxViewController 实现了它的代理方法
     TLChatBoxViewController 的代理 TLChatViewController 实现代理方法，去在其中的是子控制器更新消息
     */
    [self.chatMessageVC addNewMessage:message];
    WS(ws);
    [self br_sendAMessage:message block:^(BOOL end, NSString *msg) {
        if (end) {
            if (ws.updateBlock) {
                ws.updateBlock([msg copy]);
            }
        }
    }];
//    sadasd
    
    
    
//    /**
//     *   TLMessage 是一条消息的数据模型。纪录消息的各种属性
//     就因为又有下面的这个，所以就有了你发一条，又会多一条的显示效果！！
//     */
//    
//    ZXMessageModel *recMessage = [[ZXMessageModel alloc] init];
//    recMessage.messageType = message.messageType;
//    recMessage.ownerTyper = ZXMessageOwnerTypeOther;
//    recMessage.date = [NSDate date];// 当前时间
//    recMessage.text = message.text;
//    recMessage.imagePath = message.imagePath;
//    recMessage.from = message.from;
//    [self.chatMessageVC addNewMessage:recMessage];
    
    /**
     *  滚动插入的消息，使他始终处于一个可以看得见的位置
     */
    [self.chatMessageVC scrollToBottom];
    
}

-(void)chatBoxViewController:(ZXChatBoxController *)chatboxViewController didChangeChatBoxHeight:(CGFloat)height
{
    /**
     *   改变BoxController .view 的高度 ，这采取的是重新设置 Frame 值！！
     */
    self.chatMessageVC.view.frameHeight = viewHeight - height;
    self.chatBoxVC.view.originY = self.chatMessageVC.view.originY + self.chatMessageVC.view.frameHeight;
    [self.chatMessageVC scrollToBottom];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
   [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}


// 进set 方法设置导航名字
#pragma mark - Getter and Setter
-(void)setUser:(ZXUser *)user
{
    _user = user;
    [self.navigationItem setTitle:user.username];
    
}


/**
 *  两个聊天界面控制器
 */

-(ZXChatMessageController *)chatMessageVC
{
    
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[ZXChatMessageController  alloc] init];
        _chatMessageVC.user = self.user;

        [_chatMessageVC.view setFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, WIDTH_SCREEN, viewHeight - HEIGHT_TABBAR)];// 0  状态 + 导航 宽 viweH - tabbarH
        [_chatMessageVC setDelegate:self];// 代理
        
    }
    
    return _chatMessageVC;
    
}


-(ZXChatBoxController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ZXChatBoxController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN - HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN)];
        //(origin = (x = 0, y = 618), size = (width = 375, height = 667))  iPhone 6
        [_chatBoxVC setDelegate:self];
    }
    
    return _chatBoxVC;
}

-(UIButton * )button
{
    if (!_button)
    {
       
            _button=[UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitle:@"返回" forState:UIControlStateNormal];
            _button.titleLabel.font=[UIFont systemFontOfSize:15];
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _button.frame = CGRectMake(0, 0, 60, 30);
            [_button addTarget:self action:@selector(ReturnCick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
    return _button;
}

-(void)ReturnCick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
