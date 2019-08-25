//
//  NewMyProjectViewController.m
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "NewMyProjectViewController.h"
#import "WorkBaseModel.h"
#import "NewQuestionBankTableViewCell.h"
#import "UITextView+Placeholder.h"
#import "People.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "AizenMD5.h"
#import "Toast+UIView.h"
#import "PhoneInfo.h"
@interface NewMyProjectViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *pnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *psubtitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *NewTextView1; //申报m提示
@property (weak, nonatomic) IBOutlet UITextView *NewTextView2; //参考资料
@property (weak, nonatomic) IBOutlet UITextView *NewTextView3; //其他说明
@property (weak, nonatomic) IBOutlet UIView *FubiaotiView;
@property (weak, nonatomic) IBOutlet UIView *BiaotiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *duliTop;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray; //数据源
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) NSInteger chooseNum;
@property (nonatomic, assign) BOOL isteam;
@end

@implementation NewMyProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _chooseNum = -1;
    _isteam = YES;
    [_NewTextView1 setPlaceholder:@"请输入申报提示" placeholdColor:[UIColor lightGrayColor]];
    [_NewTextView2 setPlaceholder:@"请输入参考资料" placeholdColor:[UIColor lightGrayColor]];
    [_NewTextView3 setPlaceholder:@"请输入其他说明" placeholdColor:[UIColor lightGrayColor]];
    [self getDataSourceFromHttp];
}

- (void)getDataSourceFromHttp
{
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 200)/2, 100, 100);
    [_MainScrollView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    int college = [getObj.COLLEGEID intValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    [HttpService GetChoiceProjectListWithColleges:college andActivityID:batchID andProjectName:@"" and:10 and:1 success:^(NSDictionary *responseObject) {
        [self detailLayout:responseObject[@"AppendData"][@"rows"]];
        [_activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}
-(void) detailLayout:(NSArray *)dataArr{
    for (int i = 0 ; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        qBankModel *model = [[qBankModel alloc]init];
        model.bname = [dict objectForKey:@"ProjectName"];
        model.btishi = [dict objectForKey:@"Tips"];
        model.bziliao = [dict objectForKey:@"ReferenceMaterial"];
        model.bshuoming = [dict objectForKey:@"Description"];
        model.bID = [[dict objectForKey:@"ID"] stringValue];
        [_dataSourceArray addObject:model];
    }
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewQuestionBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qbankCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"NewQuestionBankTableViewCell" owner:self options:nil].firstObject;
    }
    qBankModel *model = self.dataSourceArray[indexPath.row];
    cell.bnameLabel.text = model.bname;
    return cell;
}
#pragma mark 返回组头的高度 : 第一组的头部一定要通过代理设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chooseNum == indexPath.row) {
        return;
    }else{
        NewQuestionBankTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_chooseNum inSection:0]];
        cell.selectImageView.image = [UIImage imageNamed:@"unselect-yuankuang"];
        _chooseNum = indexPath.row;
    }
    NewQuestionBankTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.image = [UIImage imageNamed:@"select-yuankuang"];
    
    [self.tikuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    _MainScrollView.contentOffset = CGPointMake(0, 0);
    qBankModel *model = self.dataSourceArray[indexPath.row];
    _NewTextView1.text = model.btishi;
    _NewTextView2.text = model.bziliao;
    _NewTextView3.text = model.bshuoming;
    _pnameTextField.text = model.bname;
}

-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
- (IBAction)duli:(id)sender {
    _isteam = NO;
    self.duliTop.constant = -40;
    [self.duli setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.duli.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [self.team setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.team.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.FubiaotiView.hidden = YES;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)team:(id)sender {
    _isteam = YES;
    self.duliTop.constant = 10;
    [self.team setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.team.backgroundColor = [UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
    [self.duli setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.duli.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.FubiaotiView.hidden = NO;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)newProject:(id)sender {
    [self.tikuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    _MainScrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)selectFromTiku:(id)sender {
     [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
     [self.tikuBtn setTitleColor:[UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    _MainScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (IBAction)submit:(id)sender {
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    UInt64 currTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *currTimeStr = [NSString stringWithFormat:@"%ld",currTime];
    NSString *md5Str = [AizenMD5 MD5ForUpper16Bate:[NSString stringWithFormat:@"%@GJProjectApply%@",CurrAdminID,currTimeStr]];
    if (_pnameTextField.text.length < 1) {
        [self.view makeToast:@"请填写标题！" duration:1.0 position:@"bottom"];
        return;
    }
    NSString *projectName = _pnameTextField.text;
    if (_isteam == YES && _psubtitleTextField.text.length < 1) {
        [self.view makeToast:@"请填写副标题！" duration:1.0 position:@"bottom"];
        return;
    }
    NSString *projectSubName = _psubtitleTextField.text;
    if (_NewTextView1.text.length< 1) {
        [self.view makeToast:@"请填写申报提示！" duration:1.0 position:@"bottom"];
        return;
    }
    NSString *tishi = _NewTextView1.text;
    if (_NewTextView2.text.length< 1) {
        [self.view makeToast:@"请填写参考资料！" duration:1.0 position:@"bottom"];
        return;
    }
    NSString *ziliao = _NewTextView2.text;
    if (_NewTextView3.text.length< 1) {
        [self.view makeToast:@"请填写其他说明！" duration:1.0 position:@"bottom"];
        return;
    }
    NSString *shuoming = _NewTextView3.text;
     [_activityIndicatorView startAnimating];
    [HttpService createWithStudentID:CurrAdminID andActivityID:batchID andProjectName:projectName andProjectSubName:projectSubName andIsTeam:_isteam andTips:tishi andReferenceMaterial:ziliao andDescription:shuoming andTimeStamp:currTimeStr andToken:md5Str success:^(NSDictionary *resp) {
        [_activityIndicatorView stopAnimating];
        NSString *msg = [resp objectForKey:@"Message"];
        if ([[resp objectForKey:@"ResultType"] intValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication].keyWindow makeToast:msg duration:2.0 position:@"bottom"];
        }else{
            [self.view makeToast:msg duration:1.0 position:@"center"];
        }
    } failure:^(NSError * _Nonnull error) {
        [_activityIndicatorView stopAnimating];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _MainScrollView) {
        if (scrollView.contentOffset.x == self.view.frame.size.width) {
            [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.tikuBtn setTitleColor:[UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [self.tikuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor colorWithRed:75/255.0 green:145/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
}
@end
