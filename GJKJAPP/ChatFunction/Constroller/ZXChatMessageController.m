//
//  ZXChatMessageController.m
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//  https://segmentfault.com/a/1190000002412930

#import "ZXChatMessageController.h"
#import "ZXTextMessageCell.h"
#import "ZXImageMessageCell.h"
#import "ZXVoiceMessageCell.h"
#import "ZXSystemMessageCell.h"
#import "ZXMessageModel.h"
#import "XYDJViewController.h"

#import "People.h"
#import "ZXUser.h"
@interface ZXChatMessageController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGR;


@end

@implementation ZXChatMessageController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAULT_CHAT_BACKGROUND_COLOR];
    /**
     *  给tableView添加一个手势，点击手势回收 ChatBoxController 的键盘。。
     */
    [self.view addGestureRecognizer:self.tapGR];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /**
     *  注册四个 cell
     */
    [self.tableView registerClass:[ZXTextMessageCell class] forCellReuseIdentifier:@"ZXTextMessageCell"];
    [self.tableView registerClass:[ZXImageMessageCell class] forCellReuseIdentifier:@"ZXImageMessageCell"];
    [self.tableView registerClass:[ZXVoiceMessageCell class] forCellReuseIdentifier:@"ZXVoiceMessageCell"];
    [self.tableView registerClass:[ZXSystemMessageCell class] forCellReuseIdentifier:@"ZXSystemMessageCell"];
    WS(ws);
    [self addFreshPull:self.tableView withBlock:^(id info) {
        [ws br_getUserMessageList];
    }];
    [self br_getUserMessageList];
}

- (void)br_getUserMessageList{
    
    //测试路径:GetMyMessage
    NSString *url = [NSString stringWithFormat:@"%@/ApiSystem/GetMyMessage",kCacheHttpRoot];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:@{@"AdminID":CurrAdminID,@"Creater":self.user.userID} WithReturnValeuBlock:^(HTTPData *data) {
        [self headerEndFreshPull];
        NSArray *temp = data.returnData[kRootDataKey];
        if ([temp isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                /*
                 {"ID":62,"MessageTitle":"测试","MessageContent":"测试","UpdateDate":"\/Date(1535950164387)\/","IsRead":false,"Creater":345,"Updater":1,"Sender":"杨爱国","Reader":"管理员","SenderFactUrl":"/Upload/AdminFact/2018/08/12124731668573.jpg","ReaderFactUrl":"20180125151304146.jpg","CreateDate":"\/Date(1535950164387)\/"}
                 */
                NSInteger Creater = [obj[@"Creater"] integerValue];
                NSString *ReaderFactUrl = obj[@"SenderFactUrl"];
                if ([ReaderFactUrl isKindOfClass:[NSNull class]]) {
                    ReaderFactUrl = @"";
                }
                ZXMessageModel *a_messaModel = [[ZXMessageModel alloc] init];
                a_messaModel.text = obj[@"MessageContent"];
                a_messaModel.messageType = ZXMessageTypeText;
                a_messaModel.imageURL = [ReaderFactUrl fullImg];
                if (Creater == CurrAdminID.integerValue) {
                    a_messaModel.imageURL = [getObj.FactUrl fullImg];
                    a_messaModel.ownerTyper = ZXMessageOwnerTypeSelf;
                }
                else{
                    a_messaModel.ownerTyper = ZXMessageOwnerTypeOther;

                }
                [array addObject:a_messaModel];
//                BRMessageModel *model = [[BRMessageModel alloc] initWithDictionary:obj error:nil];
//                [array addObject:model];
                
            }];
            self.data = array;
           // self.dataList = array;
            [self.tableView reloadData];
        }
        
    } WithFailureBlock:^(id error) {
        [self headerEndFreshPull];
    }];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods
- (void) addNewMessage:(ZXMessageModel *)message
{
    /**
     *  数据源添加一条消息，刷新数据
     */
    [self.data addObject:message];
    [self.tableView reloadData];
    
}

- (void) scrollToBottom
{
    if (_data.count > 0) {
        // tableView 定位到的cell 滚动到相应的位置，后面的 atScrollPosition 是一个枚举类型
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZXMessageModel  * messageModel = _data[indexPath.row];
    /**
     *  id类型的cell 通过取出来Model的类型，判断要显示哪一种类型的cell
     */
    id cell = [tableView dequeueReusableCellWithIdentifier:messageModel.cellIndentify forIndexPath:indexPath];
    // 给cell赋值
    [cell setMessageModel:messageModel];
    return cell;
    
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMessageModel *message = [_data objectAtIndex:indexPath.row];
    return message.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
//        
//        [_delegate didTapChatMessageView:self];
//        
//    }
    
}

#pragma mark - Event Response
- (void) didTapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
       
        [_delegate didTapChatMessageView:self];
        
    }
    
}

#pragma mark - Getter
- (UITapGestureRecognizer *) tapGR
{
    if (_tapGR == nil) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    }
    return _tapGR;
}

- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
