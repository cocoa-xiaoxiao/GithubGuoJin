//
//  APPAlertView.m
//  GJKJAPP
//
//  Created by 肖啸 on 2020/3/23.
//  Copyright © 2020 谭耀焯. All rights reserved.
//

#import "APPAlertView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "PhoneInfo.h"
#import "People.h"
#import "Toast+UIView.h"
#import "IQKeyboardManager.h"

@interface APPAlertView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *alertview;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *attachmentLb;
@property (nonatomic, strong) UIImageView *findImageV;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, copy) NSString *uploadFileStr;
@property (nonatomic, copy) NSString *takid;
@property (nonatomic, copy) SuccessResponseBlock successBlock;
@end


@implementation APPAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)AlertFactoryInitPracticeTaskSubmitViewfromController:(UIViewController *)viewcontroller taskID:(NSString *)taskid successblock:(SuccessResponseBlock)block
{
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]){
        self.controller = viewcontroller;
        self.takid = taskid;
        self.successBlock = block;
        [self practiceTaskSubmitUIView];
    }
    return self;
}


-(void)practiceTaskSubmitUIView
{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text= @"提交信息";
    self.titleLab.textColor=[UIColor darkGrayColor];
    self.titleLab.font= [UIFont systemFontOfSize:17];
    [self.alertview addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(10);
    }];
    //输入框
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.shadowColor = RGB_HEX(0xBEBEBE, 1).CGColor;
    self.textView.layer.shadowOpacity = 1;
    self.textView.clipsToBounds = NO;
    self.textView.layer.shadowOffset = CGSizeMake(0, 3);
    [self.alertview addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(20);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(100);
    }];
    
    UIView *selectPicView = [[UIView alloc]init];
    selectPicView.backgroundColor = [UIColor whiteColor];
    selectPicView.layer.shadowColor = RGB_HEX(0xBEBEBE, 1).CGColor;
    selectPicView.layer.shadowOpacity = 1;
    selectPicView.layer.shadowOffset = CGSizeMake(0, 3);
    
    [self.alertview addSubview:selectPicView];
    [selectPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(40);
    }];
    
    UILabel *fujianLb = [[UILabel alloc] init];
    fujianLb.text= @"附件";
    fujianLb.textColor=[UIColor darkGrayColor];
    fujianLb.font= [UIFont systemFontOfSize:17];
    [selectPicView addSubview:fujianLb];
    [fujianLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.equalTo(selectPicView);
    }];
    self.findImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [selectPicView addSubview:self.findImageV];
    [self.findImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectPicView);
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(18, 18));
    }];
    self.attachmentLb = [[UILabel alloc] init];
    self.attachmentLb.text= @"请选择";
    self.attachmentLb.textColor=[UIColor darkGrayColor];
    self.attachmentLb.font= [UIFont systemFontOfSize:17];
    [selectPicView addSubview:self.attachmentLb];
    
    [self.attachmentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.findImageV.mas_left).offset(5);
        make.centerY.equalTo(selectPicView);
    }];
    
    UIButton *choosefujian = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosefujian addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [selectPicView addSubview:choosefujian];
    [choosefujian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selectPicView);
    }];

    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = DEFAULT_APPTHEME_COLOR.CGColor;
    [cancelBtn setTitleColor:DEFAULT_APPTHEME_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:cancelBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectPicView.mas_bottom).offset(20);
        make.left.mas_offset(10);
        make.bottom.equalTo(self.alertview.mas_bottom).offset(-10);
        make.right.equalTo(cancelBtn.mas_left).offset(-20);
        make.width.height.equalTo(cancelBtn);
        make.height.mas_offset(40);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectPicView.mas_bottom).offset(20);
        make.right.mas_offset(-10);
    }] ;
    

    [self addSubview:self.alertview];
    [self.alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.centerY.equalTo(self);
        
    }];
}

-(UIView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIView alloc] init];
        _alertview.backgroundColor = [UIColor whiteColor];
        _alertview.layer.cornerRadius=5.0;
        _alertview.layer.masksToBounds=YES;
        _alertview.userInteractionEnabled=YES;
    }
    return _alertview;
}
-(void)close:(UIButton *)sender
{
    [self dismissAlertView];
}
-(void)submit:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/Submit",kCacheHttpRoot];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJTask%@",_takid,CurrTimeStamp]];
    NSString *attatchment = self.uploadFileStr;
    NSString *MessageContent = [self.textView.text copy];
    NSDictionary *param = @{@"ID":_takid,
                            @"Token":CurrToken,
                            @"TimeStamp":CurrTimeStamp,
                            @"SubmitContent":MessageContent,
                            @"submitAttachment":attatchment
                            
    };
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:param WithReturnValeuBlock:^(HTTPData *data) {
        self.successBlock(data);
        [self dismissAlertView];
    } WithFailureBlock:^(id error) {
        [BaseViewController br_showAlterMsg:@"发送失败"];
    }];
}
-(void)choose:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self.controller presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertview.transform = transform;
        self.alertview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
           UIImage *image = info[UIImagePickerControllerOriginalImage];
        WS(ws);
        [self br_uploadImage:image block:^(BOOL success, NSString *msg) {
            ws.attachmentLb.text = @"上传成功!";
            ws.uploadFileStr = [msg copy];
        }];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //保存图片至相册
        //        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
        //        [self uploadImageWithData:fileData];
        
    }else{
       
    }
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)br_uploadImage:(UIImage *)img block:(void(^)(BOOL success,NSString *msg))block {
    if (!img) {
        if (block) {
            block(YES,@"");
        }
        return;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@UpFile%@",CurrAdminID,CurrTimeStamp,@"Task"]];
    
    
    NSString *url = [NSString stringWithFormat:@"ApiActivityTaskInfo/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"Task",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        [MBProgressHUD hideHUDForView:self animated:YES];

        if (data.code == 0) {
            /*
             {"ResultType":0,"Message":"上传成功！","LogMessage":null,"AppendData":"/Upload/Internship/2018/09/13003042387171.png"}
             
             */
            if ([data.returnData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temp = data.returnData;
                NSString *AppendData = temp[@"AppendData"];
                if (block) {
                    block(YES,AppendData);
                }
            }
            else{
                [BaseViewController br_showAlterMsg:@"数据异常"];
                
            }
        }
        else{
            [BaseViewController br_showAlterMsg:data.msg];
        }
        
    } WithFailureBlock:^(id error) {
        [MBProgressHUD hideHUDForView:self animated:YES];

        [BaseViewController br_showAlterMsg:@"提交失败请重试!"];
    }];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [params setObject:CurrAdminID forKey:@"AdminID"];
    //    [params setObject:@"Internship" forKey:@"ModuleName"];
    //    [params setObject:CurrTimeStamp forKey:@"TimeStamp "];
    //    [params setObject:CurrToken forKey:@"Token"];
}

@end

@interface APPShenheView()
@property (nonatomic, strong) UIView *alertview;
@property (nonatomic, copy) NSString *studentID;
@property (nonatomic, copy) SuccessResponseBlock block;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UISwitch *switchBtn;

@end

@implementation APPShenheView


-(instancetype)AlertFactoryshenheStudentID:(NSString *)ID successblock:(SuccessResponseBlock)block
{
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]){
        self.studentID = ID;
        self.block = block;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text= @"学生申请";
    self.titleLab.textColor=[UIColor darkGrayColor];
    self.titleLab.font= [UIFont systemFontOfSize:17];
    [self.alertview addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(10);
    }];
    
    UIView *checkView = [[UIView alloc]init];
    checkView.backgroundColor = [UIColor whiteColor];
    checkView.layer.shadowColor = RGB_HEX(0xBEBEBE, 1).CGColor;
    checkView.layer.shadowOpacity = 1;
    checkView.layer.shadowOffset = CGSizeMake(0, 3);
    
    [self.alertview addSubview:checkView];
    [checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(20);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(40);
    }];
    
    UILabel *shifouLb = [[UILabel alloc] init];
    shifouLb.text= @"是否通过";
    shifouLb.textColor=[UIColor darkGrayColor];
    shifouLb.font= [UIFont systemFontOfSize:17];
    [checkView addSubview:shifouLb];
    [shifouLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.equalTo(checkView);
    }];
    
    
    self.switchBtn = [[UISwitch alloc]init];
    [checkView addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkView);
        make.right.mas_offset(-10);
    }];

    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = DEFAULT_APPTHEME_COLOR.CGColor;
    [cancelBtn setTitleColor:DEFAULT_APPTHEME_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:cancelBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkView.mas_bottom).offset(20);
        make.left.mas_offset(10);
        make.bottom.equalTo(self.alertview.mas_bottom).offset(-10);
        make.right.equalTo(cancelBtn.mas_left).offset(-20);
        make.width.height.equalTo(cancelBtn);
        make.height.mas_offset(40);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkView.mas_bottom).offset(20);
        make.right.mas_offset(-10);
    }] ;
    

    [self addSubview:self.alertview];
    [self.alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.centerY.equalTo(self);
        
    }];
}
#pragma mark action
-(void)close:(UIButton *)sender
{
    [self dismissAlertView];
}
-(void)submit:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/CheckStudent",kCacheHttpRoot];
    NSDictionary *param = @{@"ID":self.studentID,
                            @"State":self.switchBtn.isOn?@"true":@"false"};
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:param WithReturnValeuBlock:^(HTTPData *data) {
        self.block(data);
        [self dismissAlertView];
    } WithFailureBlock:^(id error) {
        [BaseViewController br_showAlterMsg:@"发送失败"];
    }];
}

-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertview.transform = transform;
        self.alertview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


-(UIView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIView alloc] init];
        _alertview.backgroundColor = [UIColor whiteColor];
        _alertview.layer.cornerRadius=5.0;
        _alertview.layer.masksToBounds=YES;
        _alertview.userInteractionEnabled=YES;
    }
    return _alertview;
}
@end



@interface APPStationChenckAlertView() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *stringArray;
@property (nonatomic, strong) UIView *alertview;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *applyID;
@property (nonatomic, assign) BOOL oppose;
@property (nonatomic, assign) BOOL is_weeklyCheck;
@property (nonatomic, copy) SuccessResponseBlock successBlock;
@end

@implementation APPStationChenckAlertView


-(instancetype)initWithStringArray:(NSArray *)strings applyID:(NSString *)applyID andIsOppose:(BOOL)oppose isWeeklyCheck:(BOOL)isweekly successblock:(SuccessResponseBlock)block
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.stringArray = strings;
        self.applyID = applyID;
        self.oppose = oppose;
        self.successBlock =block;
        self.is_weeklyCheck = isweekly;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.textView = [[UITextView alloc]init];
    [self.alertview addSubview:self.textView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text= @"常用话语";
    titleLab.textColor=[UIColor darkGrayColor];
    titleLab.font= [UIFont systemFontOfSize:17];
    [self.alertview addSubview:titleLab];
    
    [self.alertview addSubview:self.tableView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = DEFAULT_APPTHEME_COLOR.CGColor;
    [cancelBtn setTitleColor:DEFAULT_APPTHEME_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:cancelBtn];
    [self addSubview:self.alertview];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(100);
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.left.mas_offset(10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.height.mas_offset(200);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(submitBtn.mas_left).offset(-20);
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.top.equalTo(submitBtn);
        make.width.equalTo(submitBtn);
        make.width.mas_offset(70);
    }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.height.equalTo(cancelBtn);
        make.height.mas_offset(40);
        make.bottom.equalTo(self.alertview).offset(-20);
    }];
    
    [self.alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.centerY.equalTo(self);
        
    }];
}

#pragma mark action
-(void)close:(UIButton *)sender
{
    [self dismissAlertView];
}
-(void)submit:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/ApiInternshipApplyEnterpriseInfo/Check",kCacheHttpRoot];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJApply%@",self.applyID,CurrTimeStamp]];
    NSDictionary *param = @{@"ApplyID":self.applyID,
    @"State":self.oppose?@"false":@"true",
                            @"AdminID":CurrAdminID,
                            @"Content":self.textView.text,
                            @"TimeStamp":CurrTimeStamp,
                            @"Token":CurrToken
    };
    if (_is_weeklyCheck) {
        url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/Check",kCacheHttpRoot];
        param = @{@"WeeklyID":self.applyID,
                  @"AdminID":CurrAdminID,
                  @"Content":self.textView.text,
                  @"TimeStamp":CurrTimeStamp,
                  @"Token":CurrToken,
                  @"State":self.oppose?@"false":@"true",
        };
    }
    
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:param WithReturnValeuBlock:^(HTTPData *data) {
        [self dismissAlertView];
        [[UIApplication sharedApplication].keyWindow makeToast:data.msg duration:2.0 position:@"bottom"];
        self.successBlock(data);
    } WithFailureBlock:^(id error) {
        [BaseViewController br_showAlterMsg:@"发送失败"];
    }];
    
}


-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertview.transform = transform;
        self.alertview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}

-(UIView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIView alloc] init];
        _alertview.backgroundColor = [UIColor whiteColor];
        _alertview.layer.cornerRadius=5.0;
        _alertview.layer.masksToBounds=YES;
        _alertview.userInteractionEnabled=YES;
    }
    return _alertview;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stringArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.stringArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stationCellID"];
    if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stationCellID"];
    }
    cell.textLabel.text = str;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.stringArray[indexPath.row];
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:self.textView.text];
    
    [mutableStr appendString:str];
    
    self.textView.text = mutableStr;
    
}
@end


@interface APPTaskCheckAlertView() <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *stringArray;
@property (nonatomic, strong) UIView *alertview;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UILabel *fileNameLb;
@property (nonatomic, strong) UIView *pinfenView;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UILabel *leavesLb;
@property (nonatomic, strong) UILabel *totalLb;
@property (nonatomic, copy) NSString *applyID;
@property (nonatomic, assign) BOOL oppose;
@property (nonatomic, copy) SuccessResponseBlock successBlock;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, copy) NSString *uploadFileStr;
@property (nonatomic, copy) NSString *jianfen;
@property (nonatomic, copy) NSString *finalscore;
@end

@implementation APPTaskCheckAlertView


-(instancetype)initWithTaskCheckAlertStringArray:(NSArray *)strings applyID:(NSString *)applyID  successblock:(SuccessResponseBlock)block Controller:(UIViewController *)viewcontroller koufen:(NSString *)jian
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.stringArray = strings;
        self.applyID = applyID;
        self.successBlock =block;
        self.controller = viewcontroller;
        self.jianfen = jian;
        [self initUI];
        [IQKeyboardManager sharedManager].enable = YES;
    }
    return self;
}

-(void)initUI
{
    UILabel *tonguoLb = [[UILabel alloc]init];
    tonguoLb.font = [UIFont systemFontOfSize:19];
    tonguoLb.text = @"是否通过";
    [self.alertview addSubview:tonguoLb];
    [tonguoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(10);
    }];
    self.switchBtn = [[UISwitch alloc]init];
    [self.switchBtn addTarget:self action:@selector(tongguoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tonguoLb);
        make.right.mas_offset(-10);
    }];
    
    UIView *layer1 = [[UIView alloc]init];
    layer1.backgroundColor = RGB_HEX(0xbebebe, 1);
    [self.alertview addSubview:layer1];
    [layer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(tonguoLb.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    UILabel *fujian = [[UILabel alloc]init];
    fujian.font = [UIFont systemFontOfSize:19];
    fujian.text = @"附件";
    [self.alertview addSubview:fujian];
    [fujian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(layer1.mas_bottom).offset(10);
        make.left.mas_offset(10);
    }];
    
    self.fileNameLb = [[UILabel alloc]init];
    self.fileNameLb.font = [UIFont systemFontOfSize:19];
    self.fileNameLb.text = @"请选择";
    [self.alertview addSubview:self.fileNameLb];
    [self.fileNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(fujian);
    }];
    
    UIButton *choosefujian = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosefujian addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:choosefujian];
    [choosefujian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertview);
        make.top.bottom.equalTo(fujian);
    }];

    
    UIView *layer2 = [[UIView alloc]init];
    layer2.backgroundColor = RGB_HEX(0xbebebe, 1);
    [self.alertview addSubview:layer2];
    [layer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(fujian.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    self.textView = [[UITextView alloc]init];
    [self.alertview addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(layer2.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(100);
    }];
    
    
    
    UIView *layer3 = [[UIView alloc]init];
    layer3.backgroundColor = RGB_HEX(0xbebebe, 1);
    [self.alertview addSubview:layer3];
    [layer3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text= @"常用话语";
    titleLab.textColor=[UIColor darkGrayColor];
    titleLab.font= [UIFont systemFontOfSize:17];
    [self.alertview addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(layer3.mas_bottom).offset(10);
        make.left.mas_offset(10);
    }];
    [self.alertview addSubview:self.tableView];
    [self.alertview addSubview:self.pinfenView];
    [self.pinfenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(5);
        make.left.right.equalTo(self.alertview);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:DEFAULT_APPTHEME_COLOR];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:submitBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.height.mas_offset(100);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = DEFAULT_APPTHEME_COLOR.CGColor;
    [cancelBtn setTitleColor:DEFAULT_APPTHEME_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:cancelBtn];
    [self addSubview:self.alertview];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(submitBtn.mas_left).offset(-20);
        make.top.equalTo(self.pinfenView.mas_bottom).offset(10);
        make.top.equalTo(submitBtn);
        make.width.equalTo(submitBtn);
        make.width.mas_offset(70);
    }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.height.equalTo(cancelBtn);
        make.height.mas_offset(40);
        make.bottom.equalTo(self.alertview).offset(-20);
    }];
    
    [self.alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.centerY.equalTo(self);
        
    }];
}

-(void)tongguoAction
{
    if (self.switchBtn.isOn) {
        [self.pinfenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(131);
        }];
        self.pinfenView.hidden = NO;
    }else{
        [self.pinfenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        self.pinfenView.hidden = YES;
    }
}

-(UIView *)pinfenView
{
    if (!_pinfenView) {
        _pinfenView = [[UIView alloc]init];
        _pinfenView.hidden = YES;
        UILabel *defenLb = [[UILabel alloc]init];
        defenLb.font = [UIFont systemFontOfSize:19];
        defenLb.text = @"任务得分";
        [_pinfenView addSubview:defenLb];
        [defenLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.left.mas_offset(10);
        }];
        
        self.field = [[UITextField alloc]init];
        self.field.placeholder = @"请输入";
        self.field.textAlignment = NSTextAlignmentRight;
        self.field.keyboardType =UIKeyboardTypeNumberPad;
        [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        [self.field setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
        [_pinfenView addSubview:self.field];
        [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(defenLb);
            make.right.mas_offset(-10);
            make.left.equalTo(defenLb).offset(10);
        }];
        UIView *layer = [[UIView alloc]init];
        layer.backgroundColor = RGB_HEX(0xbebebe, 1);
        [_pinfenView addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.equalTo(defenLb.mas_bottom).offset(10);
            make.height.mas_offset(1);
        }];
        
        UILabel *koufenLb = [[UILabel alloc]init];
        koufenLb.font = [UIFont systemFontOfSize:19];
        koufenLb.text = @"扣分值";
        [_pinfenView addSubview:koufenLb];
        [koufenLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(layer.mas_bottom).offset(10);
            make.left.mas_offset(10);
        }];
        
        self.leavesLb = [[UILabel alloc]init];
        self.leavesLb.font = [UIFont systemFontOfSize:19];
        self.leavesLb.text = @"0";
        [_pinfenView addSubview:self.leavesLb];
        [self.leavesLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(koufenLb);
            make.right.mas_offset(-10);
        }];
        UIView *layer1 = [[UIView alloc]init];
        layer1.backgroundColor = RGB_HEX(0xbebebe, 1);
        [_pinfenView addSubview:layer1];
        [layer1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.equalTo(koufenLb.mas_bottom).offset(10);
            make.height.mas_offset(1);
        }];
        UILabel *finalLb = [[UILabel alloc]init];
        finalLb.font = [UIFont systemFontOfSize:19];
        finalLb.text = @"最终得分";
        [_pinfenView addSubview:finalLb];
        [finalLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(layer1.mas_bottom).offset(10);
            make.left.mas_offset(10);
        }];
        self.totalLb = [[UILabel alloc]init];
        self.totalLb.font = [UIFont systemFontOfSize:19];
        self.totalLb.text = @"0";
        [_pinfenView addSubview:self.totalLb];
        [self.totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(finalLb);
            make.right.mas_offset(-10);
        }];
    }
    return _pinfenView;
}

#pragma mark action
-(void)close:(UIButton *)sender
{
    [self dismissAlertView];
}
-(void)submit:(UIButton *)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityTaskInfo/Check",kCacheHttpRoot];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJTask%@",self.applyID,CurrTimeStamp]];
    
    NSDictionary *param = @{@"ID":self.applyID,
    @"State":self.switchBtn.isOn?@"1":@"2",
                            @"Updater":CurrAdminID,
                            @"CheckContent":self.textView.text,
                            @"CheckAttachment":[NSString checkNull:self.uploadFileStr],
                            @"TimeStamp":CurrTimeStamp,
                            @"Token":CurrToken,
                            @"TeacherScore":[NSString checkNull:self.field.text],
                            @"OverdueScore":[NSString checkNull:self.jianfen],
                            @"FinalScore":[NSString checkNull:self.finalscore]
    };
    
    [[HTTPOpration sharedHTTPOpration] NetRequestGETWithRequestURL:url WithParameter:param WithReturnValeuBlock:^(HTTPData *data) {
        [self dismissAlertView];
        [[UIApplication sharedApplication].keyWindow makeToast:data.msg duration:2.0 position:@"bottom"];
        self.successBlock(data);
    } WithFailureBlock:^(id error) {
        [BaseViewController br_showAlterMsg:@"发送失败"];
    }];
    
}


-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertview.transform = transform;
        self.alertview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
        [IQKeyboardManager sharedManager].enable = NO;
    }];
}

-(UIView *)alertview
{
    if (_alertview == nil) {
        _alertview = [[UIView alloc] init];
        _alertview.backgroundColor = [UIColor whiteColor];
        _alertview.layer.cornerRadius=5.0;
        _alertview.layer.masksToBounds=YES;
        _alertview.userInteractionEnabled=YES;
    }
    return _alertview;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stringArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.stringArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stationCellID"];
    if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stationCellID"];
    }
    cell.textLabel.text = str;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.stringArray[indexPath.row];
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:self.textView.text];
    
    [mutableStr appendString:str];
    
    self.textView.text = mutableStr;
    
}

-(void)choose:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self.controller presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
           UIImage *image = info[UIImagePickerControllerOriginalImage];
        WS(ws);
        [self br_uploadImage:image block:^(BOOL success, NSString *msg) {
            ws.fileNameLb.text = @"上传成功!";
            ws.uploadFileStr = [msg copy];
        }];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //保存图片至相册
        //        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
        //        [self uploadImageWithData:fileData];
        
    }else{
       
    }
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)br_uploadImage:(UIImage *)img block:(void(^)(BOOL success,NSString *msg))block {
    if (!img) {
        if (block) {
            block(YES,@"");
        }
        return;
    }
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *CurrTimeStamp = [PhoneInfo getNowTimeTimestamp3];
    NSString *CurrToken = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@UpFile%@",CurrAdminID,CurrTimeStamp,@"Task"]];
    
    
    NSString *url = [NSString stringWithFormat:@"ApiActivityTaskInfo/UploadFile?AdminID=%@&ModuleName=%@&TimeStamp=%@&Token=%@",CurrAdminID,@"Task",CurrTimeStamp,CurrToken];
    NSString *urlencode = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [[HTTPOpration sharedHTTPOpration] NetRequestPOSTFileWithRequestURL:urlencode WithParameter:nil WithFiles:@{@"file":UIImageJPEGRepresentation(img, 0.5)} WithReturnValeuBlock:^(HTTPData *data) {
        [MBProgressHUD hideHUDForView:self animated:YES];

        if (data.code == 0) {
            /*
             {"ResultType":0,"Message":"上传成功！","LogMessage":null,"AppendData":"/Upload/Internship/2018/09/13003042387171.png"}
             
             */
            if ([data.returnData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temp = data.returnData;
                NSString *AppendData = temp[@"AppendData"];
                if (block) {
                    block(YES,AppendData);
                }
            }
            else{
                [BaseViewController br_showAlterMsg:@"数据异常"];
                
            }
        }
        else{
            [BaseViewController br_showAlterMsg:data.msg];
        }
        
    } WithFailureBlock:^(id error) {
        [MBProgressHUD hideHUDForView:self animated:YES];

        [BaseViewController br_showAlterMsg:@"提交失败请重试!"];
    }];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [params setObject:CurrAdminID forKey:@"AdminID"];
    //    [params setObject:@"Internship" forKey:@"ModuleName"];
    //    [params setObject:CurrTimeStamp forKey:@"TimeStamp "];
    //    [params setObject:CurrToken forKey:@"Token"];
}

-(void)changedTextField:(id)textField
{
    CGFloat teachscore = [self.field.text floatValue];
    CGFloat overscore = [self.jianfen floatValue];
    self.finalscore = [NSString stringWithFormat:@"%.2f",teachscore + overscore];
    self.leavesLb.text = [NSString stringWithFormat:@"%.2f",overscore];
    self.totalLb.text = self.finalscore;
}
@end
