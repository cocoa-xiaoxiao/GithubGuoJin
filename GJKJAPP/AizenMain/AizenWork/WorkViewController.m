//
//  WorkViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/12.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "WorkViewController.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "WorkCollectionViewCell.h"
#import "WorkHeaderCollectionReusableView.h"
#import "DDCollectionViewFlowLayout.h"
#import "DGActivityIndicatorView.h"
#import "MainViewController.h"
#import "SpinnerViewController.h"
#import "TestViewController.h"
#import "LeaveAuditViewController.h"
#import "BatchViewController.h"
#import "BatchViewController.h"
#import "AizenStorage.h"

@interface WorkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DDCollectionViewDelegateFlowLayout>{
    int flagSpinner;
    UIBarButtonItem *leftBtn;
}

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UICollectionView *ftnView;
@property(nonatomic,strong) DGActivityIndicatorView *animationView;
@property(nonatomic,strong) NSMutableArray *TopModuleArr;
@property(nonatomic,strong) NSMutableArray *SubModuleArr;

@property(nonatomic,strong) UIScrollView *spinnerView;

;
@end

@implementation WorkViewController{
    NSMutableDictionary *dataDict;
    NSArray *sortedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flagSpinner = 0;
    _TopModuleArr = [[NSMutableArray alloc]init];
    _SubModuleArr = [[NSMutableArray alloc]init];
    
    _TopModuleArr = [AizenStorage readUserDataWithKey:@"TopModule"];
    _TopModuleArr = [[_TopModuleArr reverseObjectEnumerator]allObjects];
    _SubModuleArr = [AizenStorage readUserDataWithKey:@"SubModule"];
    
    
    _animationView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[MainViewController colorWithHexString:@"#0092ff"]];
    _animationView.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100);
    [self.view addSubview:_animationView];
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];

    
    if([_TopModuleArr count] > 0){
        NSString *title = [NSString stringWithFormat:@"%@⇂",[[_TopModuleArr objectAtIndex:0]objectForKey:@"Name"]];
        
        leftBtn = [[UIBarButtonItem alloc]
                                    initWithTitle:title
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(leftAction:)];
        self.navigationItem.leftBarButtonItem = leftBtn;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
        [self.navigationItem.leftBarButtonItem setWidth:20];
        self.navigationItem.title = @"";
    }else{
        leftBtn = [[UIBarButtonItem alloc]
                                    initWithTitle:@"工作台⇂"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(leftAction:)];
        self.navigationItem.leftBarButtonItem = leftBtn;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
        [self.navigationItem.leftBarButtonItem setWidth:20];
        self.navigationItem.title = @"";
    }

    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self initData:[[[_TopModuleArr objectAtIndex:0]objectForKey:@"ID"] stringValue]];
}


-(void) initDataTest{
    if(!dataDict)
        dataDict = [[NSMutableDictionary alloc]init];
    for (int i=0; i<3; i++) {
        NSMutableArray *picArray = [[NSMutableArray alloc]init];
        for (int j=0; j<10; j++) {
//            [picArray addObject:[NSString stringWithFormat:@"gj_msglogo1.jpeg"]];
            [picArray addObject:[NSArray arrayWithObjects:@"gj_msglogo1.jpeg",@"打卡", nil]];
        }
        [dataDict setObject:picArray forKey:[NSString stringWithFormat:@"标题%d",i+10]];
    }
    [self startLayout];
}


-(void) initData:(NSString *)topID{
    [_contentView removeFromSuperview];
    if([topID isEqualToString:@"0"]){
        if(!dataDict){
            dataDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"gj_workrb.png",@"日报", nil], [NSArray arrayWithObjects:@"gj_workzb.png",@"周报", nil],[NSArray arrayWithObjects:@"gj_workyb.png",@"月报", nil],[NSArray arrayWithObjects:@"gj_workjxzp.png",@"绩效自评", nil],nil],@"业务汇报",[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"gj_workkqdk.png",@"考勤打卡", nil], [NSArray arrayWithObjects:@"gj_workqd.png",@"签到", nil],[NSArray arrayWithObjects:@"gj_workqj.png",@"请假", nil],[NSArray arrayWithObjects:@"gj_workwc.png",@"外出", nil],[NSArray arrayWithObjects:@"gj_workcc.png",@"出差", nil],[NSArray arrayWithObjects:@"gj_workjb.png",@"加班", nil],nil],@"内外勤管理", nil];
        }
        
        if([_TopModuleArr count] > 0){
            [self startLayout];
        }
    }else{
        dataDict = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *getData = [[NSMutableArray alloc]init];
        for(int i = 0;i<[_SubModuleArr count];i++){
            NSString *flagID = [_SubModuleArr[i][0][@"ParentID"] stringValue];
            if([flagID isEqualToString:topID]){
                getData = _SubModuleArr[i];
            }
        }
        
        for(NSDictionary *secondDic in getData){

            NSMutableArray *newSecondArr = [[NSMutableArray alloc]init];
            NSString *secondName = [secondDic objectForKey:@"Name"];
            NSArray *subModule = [secondDic objectForKey:@"SysModuleVMs"];
            for(NSDictionary *thirdDic in subModule){
                NSString *subName = [thirdDic objectForKey:@"Name"];
                NSString *subIcon = [thirdDic objectForKey:@"Icon"];
                NSString *subLink = [thirdDic objectForKey:@"LinkUrl"];

                if([subIcon isEqualToString:@""]){
                    subIcon = @"gj_workqd.png";
                }

                NSArray *newThirdArr = [[NSArray alloc]initWithObjects:subIcon,subName,subLink,nil];
                
                [newSecondArr addObject:newThirdArr];
            }
            [dataDict setObject:newSecondArr forKey:secondName];
        }

        NSLog(@"%@",dataDict);
        
        if([_TopModuleArr count] > 0){
            [self startLayout];
        }
    }
}


-(void) startLayout{
    _contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    DDCollectionViewFlowLayout *ftnLayout = [[DDCollectionViewFlowLayout alloc] init];
    ftnLayout.delegate = self;
    ftnLayout.enableStickyHeaders = YES;
    
    _ftnView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,HEIGHT_STATUSBAR + HEIGHT_NAVBAR, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - HEIGHT_TABBAR - HEIGHT_STATUSBAR - HEIGHT_NAVBAR) collectionViewLayout:ftnLayout];
    _ftnView.backgroundColor = [UIColor clearColor];
    _ftnView.delegate = self;
    _ftnView.dataSource = self;
    [self.view addSubview:_ftnView];
    
    [_ftnView registerClass:[WorkCollectionViewCell class] forCellWithReuseIdentifier:@"WorkMainCell"];
    [_ftnView registerClass:[WorkHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WorkMainHeader"];
    
    _spinnerView = [[UIScrollView alloc]init];
    _spinnerView.frame = CGRectMake(0, -_ftnView.frame.size.height * 0.25, self.view.frame.size.width, _ftnView.frame.size.height * 0.25);
    _spinnerView.backgroundColor = [UIColor whiteColor];
    [_ftnView addSubview:_spinnerView];

    [self SpinnerLayout:_spinnerView];
    
}


-(void) SpinnerLayout:(UIScrollView *)view{
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height / 3;
    view.contentSize = CGSizeMake(view.frame.size.width, (view.frame.size.height / 3)*[_TopModuleArr count]);
    for(int i = 0;i<[_TopModuleArr count];i++){
        NSMutableDictionary *data = [_TopModuleArr objectAtIndex:i];
        SpinnerViewController *spinner = [[SpinnerViewController alloc]initData:data viewWidth:&width viewHeight:&height];
        spinner.view.frame = CGRectMake(0, height * i, width, height);
        UITapGestureRecognizer *spinnerClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(spinnerAction:)];
        spinnerClick.accessibilityValue = [[data objectForKey:@"ID"] stringValue];
        [spinner.view addGestureRecognizer:spinnerClick];
        [view addSubview:spinner.view];
    }
}



#pragma mark - UICollectionView dataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[dataDict allKeys] count];
}

//指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    sortedArray = [[dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    sortedArray = [[dataDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [dataDict[sortedArray[section]] count];
}

//每一行显示的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout numberOfColumnsInSection:(NSInteger)section{
    return 4;
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkMainCell" forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"%@",dataDict[sortedArray[indexPath.section]][indexPath.row][0]];
    cell.imageName = imageName;
    cell.titleName = dataDict[sortedArray[indexPath.section]][indexPath.row][1];
    return cell;
}


// 配置每一个section的header的显示
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(kind == UICollectionElementKindSectionHeader){
        WorkHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WorkMainHeader" forIndexPath:indexPath];
        header.title = [NSString stringWithFormat:@"%@",sortedArray[indexPath.section]];
        return header;
    }
    return nil;
}

#pragma mark - UICollectionView Delegate Methods
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ClassName = [NSString stringWithFormat:@"%@ViewController",dataDict[sortedArray[indexPath.section]][indexPath.row][2]];
    
    NSLog(@"%@",ClassName);
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    NSLog(@"%@",batchID);
    if([batchID isEqualToString:@""] || batchID == nil){
        BatchViewController *batchView = [[BatchViewController alloc]init];
        [self.navigationController pushViewController:batchView animated:YES];
    }else{
        if([ClassName isEqualToString:@"ViewController"]){
            //        TestViewController *test = [[TestViewController alloc]init];
            //        [self.navigationController pushViewController:test animated:YES];
            //        LeaveAuditViewController *check = [[LeaveAuditViewController alloc]init];
            //        [self.navigationController pushViewController:check animated:YES];
        }else{
            id obj = [[NSClassFromString(ClassName) alloc]init];
            if ([obj isKindOfClass:[UIViewController class]]) {
                UIViewController *temp = obj;
                temp.hidesBottomBarWhenPushed = YES;
            }
            [self.navigationController pushViewController:obj animated:YES];
        }

    }
}



#pragma mark - leftBtn
- (void) leftAction:(UIBarButtonItem *)sender{
    /*显示下拉菜单动画，显示view*/
    if(flagSpinner == 0){
        /*打开*/
        [UIView beginAnimations:@"show" context:nil];
        CGRect getFrame = _spinnerView.frame;
        getFrame.origin.y = 0;
        _spinnerView.frame = getFrame;
        [UIView setAnimationDuration:1.0f];
        [UIView commitAnimations];
        flagSpinner = 1;
    }else{
        /*关闭*/
        [UIView beginAnimations:@"show" context:nil];
        CGRect getFrame = _spinnerView.frame;
        getFrame.origin.y = -_ftnView.frame.size.height * 0.25;
        _spinnerView.frame = getFrame;
        [UIView setAnimationDuration:1.0f];
        [UIView commitAnimations];
        flagSpinner = 0;
    }
}


#pragma mark - clickBtn
-(void) spinnerAction:(UITapGestureRecognizer *)sender{
    NSString *topModuleID = sender.accessibilityValue;
    
    NSString *Title = @"";
    for(NSDictionary *TopModuleDic in _TopModuleArr){
        if([topModuleID isEqualToString:[[TopModuleDic objectForKey:@"ID"]stringValue]]){
            Title = [TopModuleDic objectForKey:@"Name"];
        }
    }
    NSString *Changetitle = [NSString stringWithFormat:@"%@⇂",Title];
    [leftBtn setTitle:Changetitle];
    
    /*关闭*/
    [UIView beginAnimations:@"show" context:nil];
    CGRect getFrame = _spinnerView.frame;
    getFrame.origin.y = -_ftnView.frame.size.height * 0.25;
    _spinnerView.frame = getFrame;
    [UIView setAnimationDuration:1.0f];
    [UIView commitAnimations];
    flagSpinner = 0;
    
    [self initData:topModuleID];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
