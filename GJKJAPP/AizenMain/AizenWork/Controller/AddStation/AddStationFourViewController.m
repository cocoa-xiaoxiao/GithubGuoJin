//
//  AddStationFiveViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/3.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationFourViewController.h"
#import "PGDatePickManager.h"h
#import "CZPickerView.h"
#import "RAlertView.h"
#import <IQKeyboardManager/IQPreviousNextView.h>
#import "UnitFiveVC.h"
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height - HEIGHT_STATUSBAR - HEIGHT_NAVBAR

@interface AddStationFourViewController ()<PGDatePickerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *scrollView;

@property(nonatomic,strong) UIButton *nextBtn;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLab;

@property(nonatomic,strong) UIView *salaryView;
@property(nonatomic,strong) UILabel *salaryLab;
@property(nonatomic,strong) BaseTextFeild *salaryField;

@property(nonatomic,strong) UIView *postDateView;
@property(nonatomic,strong) UILabel *postDateLab;
@property(nonatomic,strong) UILabel *postDateField;

@property(nonatomic,strong) UIView *stayView;
@property(nonatomic,strong) UILabel *stayLab;
@property(nonatomic,strong) BaseTextFeild *stayField;

@property(nonatomic,strong) UIView *foodView;
@property(nonatomic,strong) UILabel *foodLab;
@property(nonatomic,strong) BaseTextFeild *foodField;

@property(nonatomic,strong) UIView *agreementView;
@property(nonatomic,strong) UILabel *agreementLab;
@property(nonatomic,strong) BaseTextFeild *agreementField;

@property(nonatomic,strong) UIView *descrView;
@property(nonatomic,strong) UILabel *descrLab;
@property(nonatomic,strong) UITextView *descrField;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLab;

@property(nonatomic,strong) NSMutableArray *stayArr;
@property(nonatomic,strong) NSMutableArray *foodArr;


@property(nonatomic,strong) NSString *uploadSaraly;
@property(nonatomic,strong) NSString *uploadDate;
@property(nonatomic,strong) NSString *uploadStay;
@property(nonatomic,strong) NSString *uploadFood;
@property(nonatomic,strong) NSString *uploadAgreement;
@property(nonatomic,strong) NSString *uploadDescr;

@end

@implementation AddStationFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"企业提交";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    _stayArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费住宿",@"其他", nil];
    _foodArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费提供",@"其他", nil];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_TABBAR + HEIGHT_NAVBAR + HEIGHT_STATUSBAR));
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
//    _scrollView.contentSize = CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height * 1.5);
    [_contentView addSubview:_scrollView];
    
    
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(0, _contentView.frame.origin.y + _contentView.frame.size.height, _contentView.frame.size.width, HEIGHT_TABBAR);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    [self detailLayout];
}

- (NSString *)br_jduagehadNilData{
    
    NSString *msg= @"";
    if (_salaryField.text.length == 0) {
        msg = @"请输入月薪收入";
        return msg;
    }
    if (_postDateField.text.length == 0) {
        msg = @"请选择上岗日期";
        return msg;
    }
    if (_descrField.text.length == 0 || [_descrField.text isEqualToString:@"请输入说明"]) {
        msg = @"请输入说明";
        return msg;
    }
    
    return msg;
    
}

-(void) nextAction:(UIButton *)sender{
    NSString *msg = [self br_jduagehadNilData];
    if(msg.length > 0){
        RAlertView *alert = [[RAlertView alloc]initWithStyle:SimpleAlert];
        alert.headerTitleLabel.text = @"提示";
        alert.contentTextLabel.text = @"请输入相关信息";
        alert.isClickBackgroundCloseWindow = YES;
    }else{
        UnitFiveVC *five = getControllerFromStoryBoard(@"AddStationStoryboard", @"UnitFiveVCID");
        five.uploadID = _uploadID;
        five.uploadQYName = _uploadQYName;
        five.uploadQYCode = _uploadQYCode;
        five.uploadQYAddress = _uploadQYAddress;
        five.uploadQYTotal = _uploadQYTotal;
        five.uploadQYFlag = _uploadQYFlag;

        five.uploadStationID = _uploadStationID;
        five.uploadStationName = _uploadStationName;
        five.uploadStationTotal = _uploadStationTotal;
        five.uploadStationIntro = _uploadStationIntro;

        five.uploadJSID = _uploadJSID;
        five.uploadJSName = _uploadJSName;
        five.uploadJSPhone = _uploadJSPhone;
        five.uploadJSTel = _uploadJSTel;
        five.uploadJSEmail = _uploadJSEmail;

        five.uploadSaraly = _salaryField.text;
        five.uploadDate = _postDateField.text;
        _uploadStay = @"0";
        if([_stayField.text isEqualToString:@"不提供"]){
            _uploadStay = @"0";
        }else if([_stayField.text isEqualToString:@"提供但自费"]){
            _uploadStay = @"1";
        }else if([_stayField.text isEqualToString:@"免费住宿"]){
            _uploadStay = @"2";
        }else if([_stayField.text isEqualToString:@"其他"]){
            _uploadStay = @"3";
        }
        five.uploadStay = _uploadStay;

        _uploadFood = @"0";
        if([_foodField.text isEqualToString:@"不提供"]){
            _uploadFood = @"0";
        }else if([_foodField.text isEqualToString:@"提供但自费"]){
            _uploadFood = @"1";
        }else if([_foodField.text isEqualToString:@"免费提供"]){
            _uploadFood = @"2";
        }else if([_foodField.text isEqualToString:@"其他"]){
            _uploadFood = @"3";
        }
        five.uploadFood = _uploadFood;

        five.uploadAgreement = _uploadAgreement;
        five.uploadDescr = _descrField.text;

        [self.navigationController pushViewController:five animated:YES];
    }
}



-(void) detailLayout{
    CGFloat height = MAINHEIGHT;
    
    _titleView = [[UIView alloc]init];
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.08);
    [_contentView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"入职资料";
    _titleLab.font = [UIFont systemFontOfSize:18.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    
    _salaryView = [self normalViewIsnecessary:YES];
    _salaryView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _titleView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _salaryView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_salaryView];

    _salaryField = [[BaseTextFeild alloc]init];
    _salaryField.frame = CGRectMake(_salaryView.size.height * 0.85 , 0, _salaryView.frame.size.width * 0.45, _salaryView.frame.size.height);
    _salaryField.placeholder = @"请输入月薪收入";
    _salaryField.textAlignment = NSTextAlignmentLeft;
    _salaryField.font = [UIFont systemFontOfSize:16.0];
    [_salaryView addSubview:_salaryField];
    _salaryField.delegate = self;
    
    _postDateView = [self normalViewIsnecessary:NO];
    _postDateView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _salaryView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _postDateView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_postDateView];
    
    _postDateLab = [[UILabel alloc]init];
    _postDateLab.frame = CGRectMake(_postDateView.frame.size.width * 0.05, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateLab.text = @"上岗日期";
    _postDateLab.textColor = [UIColor blackColor];
    _postDateLab.font = [UIFont systemFontOfSize:16.0];
    [_postDateView addSubview:_postDateLab];
    
    _postDateField = [[UILabel alloc]init];
    _postDateField.frame = CGRectMake(_postDateLab.frame.origin.x + _postDateLab.frame.size.width, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateField.text = @"请输入";
    _postDateField.textAlignment = UITextAlignmentRight;
    _postDateField.font = [UIFont systemFontOfSize:16.0];
    _postDateField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_postDateField addGestureRecognizer:dateTap];
    _postDateField.userInteractionEnabled = YES;
    [_postDateView addSubview:_postDateField];
    
    _stayView = [self normalViewIsnecessary:NO];
    _stayView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _postDateView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _stayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stayView];
    
    _stayLab = [[UILabel alloc]init];
    _stayLab.frame = CGRectMake(_stayView.frame.size.width * 0.05, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayLab.text = @"是否提供住宿";
    _stayLab.textColor = [UIColor blackColor];
    _stayLab.font = [UIFont systemFontOfSize:16.0];
    [_stayView addSubview:_stayLab];
    
    
    _stayField = [[BaseTextFeild alloc]init];
    _stayField.frame = CGRectMake(_stayLab.frame.origin.x + _stayLab.frame.size.width, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayField.placeholder = @"请输入";
    _stayField.textAlignment = UITextAlignmentRight;
    _stayField.font = [UIFont systemFontOfSize:16.0];
    _stayField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *stayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stayAction:)];
    [_stayView addGestureRecognizer:stayTap];
    [_stayView addSubview:_stayField];
    _stayField.enabled = false;
    
    _foodView = [self normalViewIsnecessary:NO];
    _foodView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _stayView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _foodView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_foodView];
    
    _foodLab = [[UILabel alloc]init];
    _foodLab.frame = CGRectMake(_foodView.frame.size.width * 0.05, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodLab.text = @"是否提供伙食";
    _foodLab.textColor = [UIColor blackColor];
    _foodLab.font = [UIFont systemFontOfSize:16.0];
    [_foodView addSubview:_foodLab];
    
    _foodField = [[BaseTextFeild alloc]init];
    _foodField.frame = CGRectMake(_foodLab.frame.origin.x + _foodLab.frame.size.width, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodField.placeholder = @"请输入";
    _foodField.textAlignment = UITextAlignmentRight;
    _foodField.font = [UIFont systemFontOfSize:16.0];
    _foodField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *foodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(foodAction:)];
    [_foodView addGestureRecognizer:foodTap];
    [_foodView addSubview:_foodField];
    _foodField.enabled = false;
    
    
    _agreementView = [[UIView alloc]init];
    _agreementView.frame = CGRectMake(_contentView.frame.size.width * 0.02 , _foodView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08);
    _agreementView.hidden = YES;
    _agreementView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_agreementView];
    
    _agreementLab = [[UILabel alloc]init];
    _agreementLab.frame = CGRectMake(_agreementView.frame.size.width * 0.05, 0, _agreementView.frame.size.width * 0.45, _agreementView.frame.size.height);
    _agreementLab.text = @"实习协议";
    _agreementLab.textColor = [UIColor blackColor];
    _agreementLab.font = [UIFont systemFontOfSize:18.0];
    [_agreementView addSubview:_agreementLab];
    
    _agreementField = [[BaseTextFeild alloc]init];
    _agreementField.frame = CGRectMake(_agreementLab.frame.origin.x + _agreementLab.frame.size.width, 0, _agreementView.frame.size.width * 0.45, _agreementView.frame.size.height);
    _agreementField.placeholder = @"请输入";
    _agreementField.textAlignment = UITextAlignmentRight;
    _agreementField.font = [UIFont systemFontOfSize:18.0];
    _agreementField.keyboardType = UIKeyboardTypeDecimalPad;
//    UITapGestureRecognizer *agreementTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreementAction:)];
//       [_foodView addGestureRecognizer:agreementTap];
    [_agreementView addSubview:_agreementField];
    _agreementField.delegate = self;
    
    
    _descrView = [self normalViewIsnecessary:YES];
    _descrView.frame = CGRectMake(_contentView.frame.size.width * 0.02, _foodView.xo_bottomY + _contentView.xo_width * 0.03, _contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.24);
    _descrView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_descrView];
    
    _descrLab = [[UILabel alloc]init];
    _descrLab.frame = CGRectMake(_salaryView.size.height * 0.85 , 0, _descrView.frame.size.width * 0.45, _salaryView.size.height);
    _descrLab.text = @"说明";
    _descrLab.textColor = [UIColor blackColor];
    _descrLab.font = [UIFont systemFontOfSize:16.0];
    [_descrView addSubview:_descrLab];
    
    _descrField = [[UITextView alloc]init];
    _descrField.frame = CGRectMake(_descrLab.frame.origin.x , _descrLab.xo_bottomY, _descrView.frame.size.width -_descrLab.frame.origin.x, _contentView.frame.size.height * 0.16);
    _descrField.textAlignment = NSTextAlignmentLeft;
    _descrField.font = [UIFont systemFontOfSize:16.0];
    _descrField.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _descrField.text = @"请输入说明";
    _descrField.textColor = [UIColor grayColor];
    [_descrView addSubview:_descrField];
    _descrField.delegate  = self;
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _descrView.frame.size.height + _descrView.frame.origin.y, _contentView.frame.size.width, height * 0.05);
    [_scrollView addSubview:_bottomView];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.08, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第四步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
    
    
}


-(UIView *)normalViewIsnecessary:(BOOL)necessary
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_contentView.frame.size.width * 0.96, _contentView.frame.size.height * 0.08)];
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 2.f;
    view.layer.borderColor = RGB_HEX(0xEBEBEB, 1).CGColor;
    
    if (necessary) {
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.size.height * 0.10, view.size.height * 0.8, view.size.height * 0.8)];
        imagev.image = [UIImage imageNamed:@"ic_findpws_warnlog"];
        [view addSubview:imagev];
    }
    return view;
}


-(void) dateAction:(UITapGestureRecognizer *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType3;//PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}



-(void) stayAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选额"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"stay";
    [picker show];
}




-(void) foodAction:(UITapGestureRecognizer *)sender{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选择"
                                                   cancelButtonTitle:@"取消"
                                                  confirmButtonTitle:@"提交"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.headerBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:50/255.0 green:150/255.0 blue:250/255.0 alpha:1];
    picker.accessibilityValue = @"food";
    [picker show];
}




#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second];
    _postDateField.text = dateStr;
    _postDateField.textColor = [UIColor blackColor];
}


#pragma mark - CZPickerViewDataSource
/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr count];
    }
    return [_foodArr count];
}

/*
 Implement at least one of the following method,
 czpickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row has higer priority
 */

/* attributed picker item title for each row */
//- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
//               attributedTitleForRow:(NSInteger)row{
//    NSAttributedString *att = [[NSAttributedString alloc]
//                               initWithString:@"哈哈"
//                               attributes:@{
//                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
//                                            }];
//    return att;
//}

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        return [_stayArr objectAtIndex:row];
    }
    return [_foodArr objectAtIndex:row];
}



#pragma mark - CZPickerViewDelegate
/** delegate method for picking one item */
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    if([pickerView.accessibilityValue isEqualToString:@"stay"]){
        NSString *stayStr = [_stayArr objectAtIndex:row];
        
        _stayField.text = stayStr;
        _stayField.textColor = [UIColor blackColor];
    }else if([pickerView.accessibilityValue isEqualToString:@"food"]){
        NSString *foodStr = [_foodArr objectAtIndex:row];
        
        _foodField.text = foodStr;
        _foodField.textColor = [UIColor blackColor];
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
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_scrollView endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入说明";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入说明"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

@end
