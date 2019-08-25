//
//  TestViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/19.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "TestViewController.h"
#import "RDVTabBarController.h"
#import "MLPAutoCompleteTextField.h"
#import "RadioBoxFun.h"
#import "RAlertView.h"
#import "TestSecondViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface TestViewController ()

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UILabel *tipLab;
@property(nonatomic,strong) UIView *detailView;

@property(nonatomic,strong) UIButton *nextBtn;

@property(nonatomic,strong) UILabel *companyLab;
@property(nonatomic,strong) MLPAutoCompleteTextField *companyField;
@property(nonatomic,strong) UIView *companyLine;


@property(nonatomic,strong) UILabel *cooperationModeLab;
@property(nonatomic,strong) UILabel *cooperationModeTip;
@property(nonatomic,strong) UIView *radioBoxView;
@property(nonatomic,strong) NSString *radioVal;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业信息";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    _radioVal = @"是";
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.frame = CGRectMake(_contentView.frame.size.width * 0.05, 0, _contentView.frame.size.width * 0.95, _contentView.frame.size.height * 0.08);
    _tipLab.text = @"基本信息";
    _tipLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_contentView addSubview:_tipLab];
    
    _detailView = [[UIView alloc]init];
    _detailView.frame = CGRectMake(0, _tipLab.frame.origin.y + _tipLab.frame.size.height, _contentView.frame.size.width,_contentView.frame.size.height * 0.08 * 3);
    _detailView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_detailView];
    
    _companyLab = [[UILabel alloc]init];
    _companyLab.frame = CGRectMake(_detailView.frame.size.width * 0.05, 0, _detailView.frame.size.width * 0.25, _detailView.frame.size.height / 3);
    _companyLab.text = @"企业名称：";
    _companyLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_detailView addSubview:_companyLab];
    
    
    
    _companyField = [[MLPAutoCompleteTextField alloc]init];
    _companyField.frame = CGRectMake(_companyLab.frame.origin.x + _companyLab.frame.size.width, 0, _detailView.frame.size.width * 0.6, _detailView.frame.size.height / 3);
    _companyField.placeholder = @"请输入企业名称";
    [_detailView addSubview:_companyField];
    
    
    _companyLine = [[UIView alloc]init];
    _companyLine.frame = CGRectMake(_detailView.frame.size.width * 0.05, _detailView.frame.size.height / 3 - 1, _detailView.frame.size.width * 0.9, 1);
    _companyLine.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [_detailView addSubview:_companyLine];
    
    
    
    _cooperationModeLab = [[UILabel alloc]init];
    _cooperationModeLab.frame = CGRectMake(_detailView.frame.size.width * 0.05, _companyLab.frame.size.height + _companyLab.frame.origin.y, _detailView.frame.size.width * 0.25, _detailView.frame.size.height / 3);
    _cooperationModeLab.text = @"合作模式：";
    _cooperationModeLab.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_detailView addSubview:_cooperationModeLab];
    
    
    _cooperationModeTip = [[UILabel alloc]init];
    _cooperationModeTip.frame = CGRectMake(_cooperationModeLab.frame.size.width + _cooperationModeLab.frame.origin.x, _cooperationModeLab.frame.origin.y, _detailView.frame.size.width * 0.65, _detailView.frame.size.height / 3);
    _cooperationModeTip.text = @"是否为实训基地？";
    _cooperationModeTip.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [_detailView addSubview:_cooperationModeTip];
    
    
    _radioBoxView = [[UIView alloc]init];
    _radioBoxView.frame = CGRectMake(_detailView.frame.size.width * 0.05, _cooperationModeLab.frame.size.height + _cooperationModeLab.frame.origin.y, _detailView.frame.size.width * 0.9, _detailView.frame.size.height / 3);
    [_detailView addSubview:_radioBoxView];
    
    
    RadioBoxFun *radioBox = [RadioBoxFun new];
    UIButton *btn0 =  [radioBox creatButton:CGRectMake(16, 0, (WIDTH-50-32)/3-5, 22) title:@"是"];
    UIButton *btn1 =  [radioBox creatButton:CGRectMake((WIDTH-50-32)/3+16, 0, (WIDTH-50-32)/3-5, 22) title:@"否"];
    UIButton *btn2 =  [radioBox creatButton:CGRectMake((WIDTH-50-32)/3*2+16, 0, (WIDTH-50-32)/3-5, 22) title:@"其他"];
    [radioBox radioBoxButtons:@[btn0,btn1,btn2]  superView:_radioBoxView defultSelectedInde:0 callBack:^(NSInteger selectIndex, NSString *title) {
        NSLog(@"%ld-----%@",(long)selectIndex,title);
        _radioVal = title;
    }];
    
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.size.height - _contentView.frame.size.height * 0.08, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextBtn];
}

-(void) nextAction:(UIButton *)sender{
    NSString *companyVal = _companyField.text;
    if([companyVal isEqualToString:@""] || [_radioVal isEqualToString:@""]){
        /*请填写信息再进行下一步*/
        RAlertView *alert = [[RAlertView alloc] initWithStyle:ConfirmAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:@"请完整填写信息" lineSpacing:5];
        [alert.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [alert.confirmButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:209/255.0 blue:97/255.0 alpha:1]];
        alert.confirm = ^(){
            NSLog(@"Click on the Ok");
        };
    }else{
        /*下一步*/
        TestSecondViewController *second = [[TestSecondViewController alloc]init];
        second.companyVal = companyVal;
        second.radioVal = _radioVal;
        [self.navigationController pushViewController:second animated:YES];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
