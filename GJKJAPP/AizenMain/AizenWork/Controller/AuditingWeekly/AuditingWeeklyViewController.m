//
//  AuditingWeeklyViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/11.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AuditingWeeklyViewController.h"
#import "RDVTabBarController.h"
#import "RAlertView.h"
#import "DGActivityIndicatorView.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "People.h"
#import "CZPickerView.h"
#import "MyWeeklyListViewController.h"
#import "PersonViewController.h"
#import "DetailWeeklyViewController.h"
#import "MainViewController.h"
#import "AuditingStudentWeeklyViewController.h"

@interface AuditingWeeklyViewController ()<CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *searchView;

@property(nonatomic,strong) UIView *statusView;
@property(nonatomic,strong) UIView *viewView;

@property(nonatomic,strong) UIView *statusDetailView;
@property(nonatomic,strong) UILabel *statusLab;
@property(nonatomic,strong) UIImageView *statusImgView;

@property(nonatomic,strong) UIView *viewDetailView;
@property(nonatomic,strong) UILabel *viewLab;
@property(nonatomic,strong) UIImageView *viewImgView;

@property(nonatomic,strong) NSArray *statusArr;
@property(nonatomic,strong) NSArray *viewArr;


@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) DGActivityIndicatorView *activityIndicatorView;






@end

@implementation AuditingWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"审核周记";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _statusArr = [[NSArray alloc]initWithObjects:@"未审核",@"已审核", nil];
    _viewArr = [[NSArray alloc]initWithObjects:@"按时间",@"按学生", nil];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self startLayout];
}


-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_NAVBAR + HEIGHT_STATUSBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    [self.view addSubview:_contentView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _activityIndicatorView.frame = CGRectMake((_contentView.frame.size.width - 100)/2, (_contentView.frame.size.height - 200)/2, 100, 100);
    [_contentView addSubview:_activityIndicatorView];
    
    
    _searchView = [[UIView alloc]init];
    _searchView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.06);
    [_contentView addSubview:_searchView];
    
    _statusView = [[UIView alloc]init];
    _statusView.frame = CGRectMake(0, 0, _searchView.frame.size.width / 2, _searchView.frame.size.height);
    _statusView.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:_statusView];
    
    _viewView = [[UIView alloc]init];
    _viewView.frame = CGRectMake(_searchView.frame.size.width / 2, 0, _searchView.frame.size.width / 2, _searchView.frame.size.height);
    _viewView.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:_viewView];
    
    
    CALayer *statusLayer = [CALayer layer];
    statusLayer.frame = CGRectMake(0, _statusView.frame.size.height - 1, _statusView.frame.size.width, 1);
    statusLayer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [_statusView.layer addSublayer:statusLayer];

    
    CALayer *viewLayer = [CALayer layer];
    viewLayer.frame = CGRectMake(0, _viewView.frame.size.height - 1, _viewView.frame.size.width, 1);
    viewLayer.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [_viewView.layer addSublayer:viewLayer];
    
    
    
    _statusDetailView = [[UIView alloc]init];
    _statusDetailView.frame = CGRectMake(_statusView.frame.size.width * 0.25, _statusView.frame.size.height * 0.15, _statusView.frame.size.width * 0.5, _statusView.frame.size.height * 0.7);
    [_statusView addSubview:_statusDetailView];
    
    
    _viewDetailView = [[UIView alloc]init];
    _viewDetailView.frame = CGRectMake(_viewView.frame.size.width * 0.25, _viewView.frame.size.height * 0.15, _viewView.frame.size.width * 0.5, _viewView.frame.size.height * 0.7);
    [_viewView addSubview:_viewDetailView];
    
    
    _statusLab = [[UILabel alloc]init];
    _statusLab.frame = CGRectMake(0, 0, _statusDetailView.frame.size.width - _statusDetailView.frame.size.height, _statusDetailView.frame.size.height);
    _statusLab.text = @"未审核";
    _statusLab.textAlignment = UITextAlignmentCenter;
    _statusLab.font = [UIFont systemFontOfSize:16.0];
    [_statusDetailView addSubview:_statusLab];

    _statusImgView = [[UIImageView alloc]init];
    _statusImgView.frame = CGRectMake(_statusLab.frame.size.width,_statusDetailView.frame.size.height * 0.3,_statusDetailView.frame.size.height * 0.4,_statusDetailView.frame.size.height * 0.4);
    _statusImgView.contentMode = UIViewContentModeScaleAspectFit;
  
    _statusImgView.image = [UIImage imageNamed:@"shaixuan_logo"];
    
    [_statusDetailView addSubview:_statusImgView];
    [_statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLab.mas_right).offset(0);
        make.centerY.equalTo(self.statusLab);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _viewLab = [[UILabel alloc]init];
    _viewLab.frame = CGRectMake(0, 0, _viewDetailView.frame.size.width - _viewDetailView.frame.size.height, _viewDetailView.frame.size.height);
    _viewLab.text = @"按时间";
    _viewLab.textAlignment = UITextAlignmentCenter;
    _viewLab.font = [UIFont systemFontOfSize:16.0];
    [_viewDetailView addSubview:_viewLab];
    
    _viewImgView = [[UIImageView alloc]init];
    _viewImgView.frame = CGRectMake(_viewLab.frame.size.width,_viewDetailView.frame.size.height * 0.3,_viewDetailView.frame.size.height * 0.4,_viewDetailView.frame.size.height * 0.4);
    _viewImgView.contentMode = UIViewContentModeScaleAspectFit;
  
    _viewImgView.image = [UIImage imageNamed:@"shaixuan_logo"];
    [_viewDetailView addSubview:_viewImgView];
    [_viewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewLab.mas_right).offset(0);
        make.centerY.equalTo(self.viewLab);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    
    UITapGestureRecognizer *statusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusAction:)];
    statusTap.accessibilityLabel = @"status";
    [_statusView addGestureRecognizer:statusTap];
    _statusView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction:)];
    viewTap.accessibilityLabel = @"view";
    [_viewView addGestureRecognizer:viewTap];
    _viewView.userInteractionEnabled = YES;
    
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, _searchView.frame.size.height + _searchView.frame.origin.y, _searchView.frame.size.width, _contentView.frame.size.height - _searchView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 1.5);
    [_contentView addSubview:_scrollView];
    
    
    [self handleHttp];
}




-(void) handleHttp{
    while(_scrollView.subviews.count){
        UIView *childView = _scrollView.subviews.lastObject;
        [childView removeFromSuperview];
    }
    
    NSString *statusStr = _statusLab.text;
    NSString *viewStr = _viewLab.text;
    
    
    if([viewStr isEqualToString:@"按学生"]){
        /*学生视图，无分状态*/
        [self handleStudentHttp];
//        [self handleStudentView];
    }else{
        /*默认试图，要区分状态*/
        if([statusStr isEqualToString:@"状态"]){
            [self handleOtherHttp:@"0"];
        }else if([statusStr isEqualToString:@"未审核"]){
            [self handleOtherHttp:@"1"];
        }else if([statusStr isEqualToString:@"已审核"]){
            [self handleOtherHttp:@"2"];
        }else if ([statusStr isEqualToString:@"未通过"]){
            [self handleOtherHttp:@"3"];

        }
    }
}


-(void) handleStudentHttp{
    [_activityIndicatorView startAnimating];
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivity/GetMyStudent?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleStudentView:[jsonDic objectForKey:@"AppendData"]];
        }
    } failue:^(NSError *error) {
        NSLog(@"请求失败---获取学生");
    }];
}




-(void) handleOtherHttp:(NSString *)state{
    [_activityIndicatorView startAnimating];
    // 0 未审核 2 已审核
    NSString *Account = [AizenStorage readUserDataWithKey:@"Account"];
    NSArray *existArr = [People bg_findWhere:[NSString stringWithFormat:@"where account='%@'",Account]];
    People *getObj = existArr[0];
    NSString *CurrAdminID = [getObj.USERID stringValue];
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    if (state.integerValue == 2) {//已审核
        NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/MyCheckWeeklyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
        NSLog(@"%@",url);
        
        [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
            [_activityIndicatorView stopAnimating];
            NSDictionary *jsonDic = result;
            if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
                [self handleOtherView:[jsonDic objectForKey:@"AppendData"] State:state];
            }
        } failue:^(NSError *error) {
            [_activityIndicatorView stopAnimating];
            NSLog(@"请求失败--教师查学生周记列表");
        }];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/ApiActivityWeekly/MyStudentWeeklyList?AdminID=%@&ActivityID=%@",kCacheHttpRoot,CurrAdminID,batchID];
    NSLog(@"%@",url);
    
    [AizenHttp asynRequest:url httpMethod:@"GET" params:nil success:^(id result) {
        [_activityIndicatorView stopAnimating];
        NSDictionary *jsonDic = result;
        if([[jsonDic objectForKey:@"ResultType"] integerValue] == 0){
            [self handleOtherView:[jsonDic objectForKey:@"AppendData"] State:state];
        }
    } failue:^(NSError *error) {
        [_activityIndicatorView stopAnimating];
        NSLog(@"请求失败--教师查学生周记列表");
    }];
}



-(void) handleStudentView:(NSArray *)dataArr{
    
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 10;
    
    
    for(int i = 0;i < [dataArr count];i++){
        PersonViewController *person = [[PersonViewController alloc]init_Value:i width:&width height:&height dataDic:[dataArr objectAtIndex:i]];
        person.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *personTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personAction:)];
        personTap.accessibilityElements = [dataArr objectAtIndex:i];
        [person.view addGestureRecognizer:personTap];
        [_scrollView addSubview:person.view];
    }
    
    CGFloat scrollHeight = height * [dataArr count];
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
}




-(void) handleOtherView:(NSArray *)dataArr State:(NSString *)state{
    NSMutableArray *newDataArr = [[NSMutableArray alloc]init];
    
    for(int x = 0;x<[dataArr count];x++){
        NSDictionary *getDic = [dataArr objectAtIndex:x];
        if([state isEqualToString:@"0"]){
            [newDataArr addObject:[dataArr objectAtIndex:x]];
        }else if([state isEqualToString:@"1"]){
            if([[[getDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"0"]){
                [newDataArr addObject:[dataArr objectAtIndex:x]];
            }
        }else if([state isEqualToString:@"2"]){
            if(![[[getDic objectForKey:@"CheckState"] stringValue] isEqualToString:@"0"]){
                [newDataArr addObject:[dataArr objectAtIndex:x]];
            }
        }
    }
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height / 5;
    
    for(int i = 0;i<[newDataArr count];i++){
        MyWeeklyListViewController *weekly = [[MyWeeklyListViewController alloc]init_Value:i width:&width height:&height dataDic:[newDataArr objectAtIndex:i]];
        weekly.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *weeklyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weeklyAction:)];
        weeklyTap.accessibilityLabel = [[[dataArr objectAtIndex:i] objectForKey:@"ID"] stringValue];
        [weekly.view addGestureRecognizer:weeklyTap];
        [_scrollView addSubview:weekly.view];
    }
    
    CGFloat scrollHeight = height * [dataArr count];
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, scrollHeight);
}




-(void) statusAction:(UITapGestureRecognizer *)sender{
    _statusImgView.transform = CGAffineTransformMakeScale(1.0,-1.0);
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"选择状态"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"确定"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityLabel = @"status";
    [picker show];
}


-(void) viewAction:(UITapGestureRecognizer *)sender{
    _viewImgView.transform = CGAffineTransformMakeScale(1.0,-1.0);
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"选择视图"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"确定"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityLabel = @"view";
    [picker show];
}


-(void) weeklyAction:(UITapGestureRecognizer *)sender{
    DetailWeeklyViewController *detail = [[DetailWeeklyViewController alloc]init];
    detail.ID = sender.accessibilityLabel;
    detail.flagRole = @"teacher";
    detail.updateBlock = ^(id info) {
        [self handleHttp];
    };
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    int x = 0;
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        x = [_statusArr count];
    }else if([pickerView.accessibilityLabel isEqualToString:@"view"]){
        x = [_viewArr count];
    }
    return x;
    
}


/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    NSString *valStr = @"";
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        valStr = [_statusArr objectAtIndex:row];
    }else if([pickerView.accessibilityLabel isEqualToString:@"view"]){
        valStr = [_viewArr objectAtIndex:row];
    }
    return valStr;
}



#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    NSString *getStr = @"";
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        getStr = [_statusArr objectAtIndex:row];
        _statusLab.text = getStr;
        _statusImgView.transform = CGAffineTransformMakeScale(-1.0,1.0);
    }else if([pickerView.accessibilityLabel isEqualToString:@"view"]){
        getStr = [_viewArr objectAtIndex:row];
        _viewLab.text = getStr;
        _viewImgView.transform = CGAffineTransformMakeScale(-1.0,1.0);
    }
    [self handleHttp];
}

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemsAtRows:(NSArray *)rows{
    
}
/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        _statusImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }else if([pickerView.accessibilityLabel isEqualToString:@"view"]){
        _viewImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
}


-(void) czpickerViewDidDismiss:(CZPickerView *)pickerView{
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        _statusImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }else if([pickerView.accessibilityLabel isEqualToString:@"view"]){
        _viewImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
}




-(void) personAction:(UITapGestureRecognizer *)sender{
    NSDictionary *dataDic = sender.accessibilityElements;
    NSLog(@"%@",dataDic);
    AuditingStudentWeeklyViewController *studentWeeklyList = [[AuditingStudentWeeklyViewController alloc]init];
    studentWeeklyList.dataDic = dataDic;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [backBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController pushViewController:studentWeeklyList animated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
