//
//  DetailListViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DetailListViewController.h"
#import "CZPicker.h"
#import "StatisticsModelViewController.h"
#import "DetailOneViewController.h"

@interface DetailListViewController ()<CZPickerViewDelegate,CZPickerViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) NSArray *statusArr;

@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UIView *statusView;
@property(nonatomic,strong) UIView *viewView;

@property(nonatomic,strong) UIView *statusDetailView;
@property(nonatomic,strong) UILabel *statusLab;
@property(nonatomic,strong) UIImageView *statusImgView;

@property(nonatomic,strong) UIView *viewDetailView;
@property(nonatomic,strong) UILabel *viewLab;
@property(nonatomic,strong) UIImageView *viewImgView;

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"考勤明细";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    
    _statusArr = [[NSArray alloc]initWithObjects:@"正常",@"请假",@"缺勤", nil];
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    _searchView = [[UIView alloc]init];
    _searchView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.06);
    [_contentView addSubview:_searchView];
    
    _viewView = [[UIView alloc]init];
    _viewView.frame = CGRectMake(0, 0, _searchView.frame.size.width / 2, _searchView.frame.size.height);
    _viewView.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:_viewView];
    
    _statusView = [[UIView alloc]init];
    _statusView.frame = CGRectMake(_searchView.frame.size.width / 2, 0, _searchView.frame.size.width / 2, _searchView.frame.size.height);
    _statusView.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:_statusView];
    
    
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
    _statusLab.text = @"状态";
    _statusLab.textAlignment = UITextAlignmentCenter;
    _statusLab.font = [UIFont systemFontOfSize:16.0];
    [_statusDetailView addSubview:_statusLab];
    
    _statusImgView = [[UIImageView alloc]init];
    _statusImgView.frame = CGRectMake(_statusLab.frame.size.width,_statusDetailView.frame.size.height * 0.3,_statusDetailView.frame.size.height * 0.4,_statusDetailView.frame.size.height * 0.4);
    _statusImgView.contentMode = UIViewContentModeScaleAspectFit;
    _statusImgView.image = [UIImage imageNamed:@"expandableImage"];
    [_statusDetailView addSubview:_statusImgView];
    
    
    _viewLab = [[UILabel alloc]init];
    _viewLab.frame = CGRectMake(0, 0, _viewDetailView.frame.size.width - _viewDetailView.frame.size.height, _viewDetailView.frame.size.height);
    _viewLab.text = @"视图";
    _viewLab.textAlignment = UITextAlignmentCenter;
    _viewLab.font = [UIFont systemFontOfSize:16.0];
    [_viewDetailView addSubview:_viewLab];
    
    _viewImgView = [[UIImageView alloc]init];
    _viewImgView.frame = CGRectMake(_viewLab.frame.size.width,_viewDetailView.frame.size.height * 0.3,_viewDetailView.frame.size.height * 0.4,_viewDetailView.frame.size.height * 0.4);
    _viewImgView.contentMode = UIViewContentModeScaleAspectFit;
    _viewImgView.image = [UIImage imageNamed:@"expandableImage"];
    [_viewDetailView addSubview:_viewImgView];
    
    
    UITapGestureRecognizer *statusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusAction:)];
    statusTap.accessibilityLabel = @"status";
    [_statusView addGestureRecognizer:statusTap];
    _statusView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction:)];
    viewTap.accessibilityLabel = @"view";
    [_viewView addGestureRecognizer:viewTap];
    _viewView.userInteractionEnabled = YES;
    
    [self detailLayout];
}



-(void) detailLayout{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, _searchView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height - _searchView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 2);
    [_contentView addSubview:_scrollView];
    
    CGFloat width = _contentView.frame.size.width;
    CGFloat height = _contentView.frame.size.height / 4;
    
    NSArray *type = [[NSArray alloc]initWithObjects:@"leave",@"duty",@"normal", nil];
    
    for(int i = 0;i<10;i++){
        int x = arc4random() % 3;
        
        StatisticsModelViewController *model = [[StatisticsModelViewController alloc]init_Value:i width:&width height:&height dataDic:[[NSMutableDictionary alloc]init] statusType:[type objectAtIndex:x]];
        model.view.frame = CGRectMake(0, i * height, width, height);
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneAction:)];
        [model.view addGestureRecognizer:oneTap];
        [_scrollView addSubview:model.view];
    }
}


-(void) oneAction:(UITapGestureRecognizer *)sender{
    DetailOneViewController *oneView = [[DetailOneViewController alloc]init];
    oneView.applyID = @"1";
    [self.navigationController pushViewController:oneView animated:YES];
}




-(void) viewAction:(UITapGestureRecognizer *)sender{
    
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



#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    int x = 0;
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        x = [_statusArr count];
    }
    return x;
    
}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    NSString *valStr = @"";
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        valStr = [_statusArr objectAtIndex:row];
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
    }
    
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
    }
}


-(void) czpickerViewDidDismiss:(CZPickerView *)pickerView{
    if([pickerView.accessibilityLabel isEqualToString:@"status"]){
        _statusImgView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
