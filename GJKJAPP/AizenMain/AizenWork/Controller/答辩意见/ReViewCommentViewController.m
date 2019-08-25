//
//  ReViewCommentViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/7.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import "ReViewCommentViewController.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "People.h"
#import "PhoneInfo.h"
#import "NSString+Extension.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
#import "UITextView+Placeholder.h"
@interface ReViewCommentViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalTF;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *ProjectSubName;
@property (weak, nonatomic) IBOutlet UILabel *field1d;
@property (weak, nonatomic) IBOutlet UILabel *field1Label;
@property (weak, nonatomic) IBOutlet UITextField *field1Score;
@property (weak, nonatomic) IBOutlet UITextView *field1;
@property (weak, nonatomic) IBOutlet UILabel *field2Label;
@property (weak, nonatomic) IBOutlet UILabel *field2d;
@property (weak, nonatomic) IBOutlet UITextField *field2Score;
@property (weak, nonatomic) IBOutlet UITextView *field2;
@property (weak, nonatomic) IBOutlet UILabel *field3Label;
@property (weak, nonatomic) IBOutlet UILabel *field3d;
@property (weak, nonatomic) IBOutlet UITextField *field3Score;
@property (weak, nonatomic) IBOutlet UITextView *field3;
@property (weak, nonatomic) IBOutlet UILabel *field4Label;
@property (weak, nonatomic) IBOutlet UILabel *field4d;
@property (weak, nonatomic) IBOutlet UITextField *field4Score;
@property (weak, nonatomic) IBOutlet UITextView *field4;
@property (weak, nonatomic) IBOutlet UILabel *field5Label;
@property (weak, nonatomic) IBOutlet UILabel *field5d;
@property (weak, nonatomic) IBOutlet UITextField *field5Score;
@property (weak, nonatomic) IBOutlet UITextView *field5;
@property (weak, nonatomic) IBOutlet UILabel *field6Label;
@property (weak, nonatomic) IBOutlet UILabel *field6d;
@property (weak, nonatomic) IBOutlet UITextField *field6Score;
@property (weak, nonatomic) IBOutlet UITextView *field6;
@property (weak, nonatomic) IBOutlet UILabel *field7Label;
@property (weak, nonatomic) IBOutlet UILabel *field7d;
@property (weak, nonatomic) IBOutlet UITextField *field7Score;
@property (weak, nonatomic) IBOutlet UITextView *field7;
@property (weak, nonatomic) IBOutlet UILabel *field8Label;
@property (weak, nonatomic) IBOutlet UILabel *field8d;
@property (weak, nonatomic) IBOutlet UITextField *field8Score;
@property (weak, nonatomic) IBOutlet UITextView *field8;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ReViewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataSourceFromHttp];
    if (self.editReview == 2) {
        _field1.editable = NO;
        _field1Score.enabled = NO;
        _field2.editable = NO;
        _field2Score.enabled = NO;
        _field3.editable = NO;
        _field3Score.enabled = NO;
        _field4.editable = NO;
        _field4Score.enabled = NO;
        _field5.editable = NO;
        _field5Score.enabled = NO;
        _field6.editable = NO;
        _field6Score.enabled = NO;
        _field7.editable = NO;
        _field7Score.enabled = NO;
        _field8.editable = NO;
        _field8Score.enabled = NO;
        _buttonHeight.constant = 0;
        _submitButton.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}
-(void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    [HttpService GetReviewInfo:self.reviewID success:^(id  _Nonnull responseObject) {
        NSArray *appendArray = responseObject[@"AppendData"];
        NSDictionary *firstDic = appendArray.firstObject;
        [HttpService GetReviewConfig:batchID success:^(id  _Nonnull responseObject) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *secondDic = responseObject[@"AppendData"];
            [self combineWithFirstDict:firstDic andSectionDict:secondDic];
        } failure:^(NSError * _Nonnull error) {
            [_activityIndicatorView stopAnimating];
        }];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void)combineWithFirstDict:(NSDictionary *)firstDic andSectionDict:(NSDictionary *)SecondDict
{
    int i = 8;
    self.studentLabel.text = [NSString stringWithFormat:@"学生: %@",firstDic[@"UserName"]];
    self.projectName.text = [NSString stringWithFormat:@"%@",firstDic[@"ProjectName"]];
    self.ProjectSubName.text = [NSString stringWithFormat:@"%@",firstDic[@"ProjectSubName"]];
    if (![[firstDic objectForKey:@"FinalScore"]isKindOfClass:[NSNull class]]) {
        self.totalTF.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"FinalScore"]floatValue]];
    }
    if (![[SecondDict objectForKey:@"Field1"] isKindOfClass:[NSNull class]]) {
        self.field1Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field1"]];
        self.field1Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field1Weight"]];
        [self.field1 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field1"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field1"]isKindOfClass:[NSNull class]]) {
            self.field1.text = [NSString stringWithFormat:@"%@",firstDic[@"Field1"]];
        }
        if (![[firstDic objectForKey:@"Score1"]isKindOfClass:[NSNull class]]) {
            self.field1Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score1"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field1Label.hidden = YES;
        self.field1Score.hidden = YES;
        self.field1.hidden = YES;
        self.field1d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field2"] isKindOfClass:[NSNull class]]) {
        self.field2Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field2"]];
        self.field2Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field2Weight"]];
        [self.field2 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field2"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field2"]isKindOfClass:[NSNull class]]) {
            self.field2.text = [NSString stringWithFormat:@"%@",firstDic[@"Field2"]];
        }
        if (![[firstDic objectForKey:@"Score2"]isKindOfClass:[NSNull class]]) {
            self.field2Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score2"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field2Label.hidden = YES;
        self.field2Score.hidden = YES;
        self.field2.hidden = YES;
        self.field2d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field3"] isKindOfClass:[NSNull class]]) {
        self.field3Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field3"]];
        self.field3Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field3Weight"]];
        [self.field3 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field3"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field3"]isKindOfClass:[NSNull class]]) {
            self.field3.text = [NSString stringWithFormat:@"%@",firstDic[@"Field3"]];
        }
        if (![[firstDic objectForKey:@"Score3"]isKindOfClass:[NSNull class]]) {
            self.field3Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score3"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field3Label.hidden = YES;
        self.field3Score.hidden = YES;
        self.field3.hidden = YES;
        self.field3d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field4"] isKindOfClass:[NSNull class]]) {
        self.field4Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field4"]];
        self.field4Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field4Weight"]];
        [self.field4 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field4"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field4"]isKindOfClass:[NSNull class]]) {
            self.field4.text = [NSString stringWithFormat:@"%@",firstDic[@"Field4"]];
        }
        if (![[firstDic objectForKey:@"Score4"]isKindOfClass:[NSNull class]]) {
            self.field4Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score4"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field4Label.hidden = YES;
        self.field4Score.hidden = YES;
        self.field4.hidden = YES;
        self.field4d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field5"] isKindOfClass:[NSNull class]]) {
        self.field5Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field5"]];
        self.field5Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field5Weight"]];
         [self.field5 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field5"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field5"]isKindOfClass:[NSNull class]]) {
            self.field5.text = [NSString stringWithFormat:@"%@",firstDic[@"Field5"]];
        }
        if (![[firstDic objectForKey:@"Score5"]isKindOfClass:[NSNull class]]) {
            self.field5Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score5"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field5Label.hidden = YES;
        self.field5Score.hidden = YES;
        self.field5.hidden = YES;
        self.field5d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field6"] isKindOfClass:[NSNull class]]) {
        self.field6Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field6"]];
        self.field6Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field6Weight"]];
        [self.field6 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field6"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field6"]isKindOfClass:[NSNull class]]) {
            self.field6.text = [NSString stringWithFormat:@"%@",firstDic[@"Field6"]];
        }
        if (![[firstDic objectForKey:@"Score6"]isKindOfClass:[NSNull class]]) {
            self.field6Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score6"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field6Label.hidden = YES;
        self.field6Score.hidden = YES;
        self.field6.hidden = YES;
        self.field6d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field7"] isKindOfClass:[NSNull class]]) {
        self.field7Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field7"]];
        self.field7Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field7Weight"]];
        [self.field7 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field7"]] placeholdColor:[UIColor lightGrayColor]];
        if (![[firstDic objectForKey:@"Field7"]isKindOfClass:[NSNull class]]) {
            self.field7.text = [NSString stringWithFormat:@"%@",firstDic[@"Field7"]];
        }
        if (![[firstDic objectForKey:@"Score7"]isKindOfClass:[NSNull class]]) {
            self.field7Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score7"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }
    else{
        self.field7Label.hidden = YES;
        self.field7Score.hidden = YES;
        self.field7.hidden = YES;
        self.field7d.hidden = YES;
        i --;
    }
    if (![[SecondDict objectForKey:@"Field8"] isKindOfClass:[NSNull class]]) {
        self.field8Label.text = [NSString stringWithFormat:@"%@",SecondDict[@"Field8"]];
        self.field8Score.placeholder = [NSString stringWithFormat:@"满分%@分",SecondDict[@"Field8Weight"]];
        if (![[firstDic objectForKey:@"Field8"]isKindOfClass:[NSNull class]]) {
            self.field8.text = [NSString stringWithFormat:@"%@",firstDic[@"Field8"]];
        }else{
            [self.field8 setPlaceholder:[NSString stringWithFormat:@"请输入%@...",SecondDict[@"Field8"]] placeholdColor:[UIColor lightGrayColor]];
        }
        if (![[firstDic objectForKey:@"Score8"]isKindOfClass:[NSNull class]]) {
            self.field8Score.text = [NSString stringWithFormat:@"%@",firstDic[@"Score8"]];
        }
        myReViewCommentModel *model = [[myReViewCommentModel alloc]init];
        [self.dataSource addObject:model];
    }else{
        self.field8Label.hidden = YES;
        self.field8Score.hidden = YES;
        self.field8.hidden = YES;
        self.field8d.hidden = YES;
        i --;
    }
    
    CGFloat max = 140 + 160 * i;
    self.scrollview.contentSize = CGSizeMake(self.scrollview.contentSize.width, max);
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (IBAction)submit:(id)sender {
    [self.view endEditing:YES];
    for (int i = 0; i < self.dataSource.count; i++) {
        myReViewCommentModel *model = self.dataSource[i];
            if (model.score == nil || model.comment == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
    }
    NSString *f1 = @"";
    NSString *f1s = @"";
    NSString *f2 = @"";
    NSString *f2s = @"";
    NSString *f3 = @"";
    NSString *f3s = @"";
    NSString *f4 = @"";
    NSString *f4s = @"";
    NSString *f5 = @"";
    NSString *f5s = @"";
    NSString *f6 = @"";
    NSString *f6s = @"";
    NSString *f7 = @"";
    NSString *f7s = @"";
    NSString *f8 = @"";
    NSString *f8s = @"";
    for (int i = 0; i< self.dataSource.count; i++) {
        myReViewCommentModel *model = self.dataSource[i];
        if (i == 0) {
            f1 = model.comment;
            f1s = model.score;
        }
        if (i == 1) {
            f2 = model.comment;
            f2s = model.score;
        }
        if (i == 2) {
            f3 = model.comment;
            f3s = model.score;
        }
        if (i == 3) {
            f4 = model.comment;
            f4s = model.score;
        }
        if (i == 4) {
            f5 = model.comment;
            f5s = model.score;
        }
        if (i == 5) {
            f6 = model.comment;
            f6s = model.score;
        }
        if (i == 6) {
            f7 = model.comment;
            f7s = model.score;
        }
        if (i == 7) {
            f1 = model.comment;
            f1s = model.score;
        }
    }
    
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService ReviewEvaluate:batchID with:CurrAdminID andID:self.reviewID Field1:f1 Score1:f1s Field2:f2 Score2:f2s Field3:f3 Score3:f3s Field4:f4 Score4:f4s Field5:f5 Score5:f5s Field6:f6 Score6:f6s Field7:f7 Score7:f7s Field8:f8 Score8:f8s FinalScore:self.totalTF.text success:^(id  _Nonnull responseObject) {
        NSString *msg = [responseObject objectForKey:@"Message"];
        if ([[responseObject objectForKey:@"ResultType"] intValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication].keyWindow makeToast:msg duration:2.0 position:@"bottom"];
        }else{
            [self.view makeToast:msg duration:1.0 position:@"center"];
        }
        [_activityIndicatorView stopAnimating];

    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _field1Score) {
        myReViewCommentModel *model = self.dataSource[0];
        model.score = textField.text;
    }
    if (textField == _field2Score) {
        myReViewCommentModel *model = self.dataSource[1];
        model.score = textField.text;
    }
    if (textField == _field3Score) {
        myReViewCommentModel *model = self.dataSource[2];
        model.score = textField.text;
    }
    if (textField == _field4Score) {
        myReViewCommentModel *model = self.dataSource[3];
        model.score = textField.text;
    }
    if (textField == _field5Score) {
        myReViewCommentModel *model = self.dataSource[4];
        model.score = textField.text;
    }
    if (textField == _field6Score) {
        myReViewCommentModel *model = self.dataSource[5];
        model.score = textField.text;
    }
    if (textField == _field7Score) {
        myReViewCommentModel *model = self.dataSource[6];
        model.score = textField.text;
    }
    if (textField == _field8Score) {
        myReViewCommentModel *model = self.dataSource[7];
        model.score = textField.text;
    }
    CGFloat a = 0;
    for (int i = 0 ; i < self.dataSource.count; i++) {
        myReViewCommentModel *model = [self.dataSource objectAtIndex:i];
        CGFloat v = [model.score floatValue];
        a += v;
    }
    self.totalTF.text = [NSString stringWithFormat:@"%.2f",a];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == _field1) {
        myReViewCommentModel *model = self.dataSource[0];
        model.comment = textView.text;
    }
    if (textView == _field2) {
        myReViewCommentModel *model = self.dataSource[1];
        model.comment = textView.text;
    }
    if (textView == _field3) {
        myReViewCommentModel *model = self.dataSource[2];
        model.comment = textView.text;
    }
    if (textView == _field4) {
        myReViewCommentModel *model = self.dataSource[3];
        model.comment = textView.text;
    }
    if (textView == _field5) {
        myReViewCommentModel *model = self.dataSource[4];
        model.comment = textView.text;
    }
    if (textView == _field6) {
        myReViewCommentModel *model = self.dataSource[5];
        model.comment = textView.text;
    }
    if (textView == _field7) {
        myReViewCommentModel *model = self.dataSource[6];
        model.comment = textView.text;
    }
    if (textView == _field8) {
        myReViewCommentModel *model = self.dataSource[7];
        model.comment = textView.text;
    }
}
@end

@implementation myReViewCommentModel

@end
