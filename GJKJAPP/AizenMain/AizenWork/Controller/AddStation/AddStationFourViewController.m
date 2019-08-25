//
//  AddStationFiveViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/4/3.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "AddStationFourViewController.h"
#import "PGDatePickManager.h"
#import "CZPickerView.h"
#import "AddStationFiveViewController.h"
#import "RAlertView.h"
#import <IQKeyboardManager/IQPreviousNextView.h>
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
@property(nonatomic,strong) BaseTextFeild *descrField;

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
    self.navigationItem.title = @"添加入职信息";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    
    _stayArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费住宿",@"其他", nil];
    _foodArr = [[NSMutableArray alloc]initWithObjects:@"不提供",@"提供但自费",@"免费提供",@"其他", nil];
    
    [self startLayout];
}


-(void) startLayout{
    _contentView = [[IQPreviousNextView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, self.view.frame.size.width, self.view.frame.size.height - (HEIGHT_TABBAR + HEIGHT_NAVBAR + HEIGHT_STATUSBAR));
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
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
        AddStationFiveViewController *five = [[AddStationFiveViewController alloc]init];
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
    _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, height * 0.05);
    [_scrollView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.45, _titleView.frame.size.height);
    _titleLab.text = @"入职资料";
    _titleLab.font = [UIFont systemFontOfSize:13.0];
    _titleLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_scrollView addSubview:_titleLab];
    
    
    _salaryView = [[UIView alloc]init];
    _salaryView.frame = CGRectMake(0, _titleView.frame.origin.y + _titleView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _salaryView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_salaryView];
    
    _salaryLab = [[UILabel alloc]init];
    _salaryLab.frame = CGRectMake(_salaryView.frame.size.width * 0.05, 0, _salaryView.frame.size.width * 0.45, _salaryView.frame.size.height);
    _salaryLab.text = @"月薪收入";
    _salaryLab.textColor = [UIColor blackColor];
    _salaryLab.font = [UIFont systemFontOfSize:18.0];
    [_salaryView addSubview:_salaryLab];
    
    
    _salaryField = [[BaseTextFeild alloc]init];
    _salaryField.frame = CGRectMake(_salaryLab.frame.origin.x + _salaryLab.frame.size.width, 0, _salaryView.frame.size.width * 0.45, _salaryView.frame.size.height);
    _salaryField.placeholder = @"请输入";
    _salaryField.textAlignment = UITextAlignmentRight;
    _salaryField.font = [UIFont systemFontOfSize:18.0];
    _salaryField.keyboardType = UIKeyboardTypeDecimalPad;
    [_salaryView addSubview:_salaryField];
    _salaryField.delegate = self;
    UIView * line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(_salaryView.frame.size.width * 0.05, _salaryView.frame.size.height - 1, _salaryView.frame.size.width * 0.95, 1);
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_salaryView addSubview:line1];
    
    
    
    _postDateView = [[UIView alloc]init];
    _postDateView.frame = CGRectMake(0, _salaryView.frame.origin.y + _salaryView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _postDateView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_postDateView];
    
    _postDateLab = [[UILabel alloc]init];
    _postDateLab.frame = CGRectMake(_postDateView.frame.size.width * 0.05, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateLab.text = @"上岗日期";
    _postDateLab.textColor = [UIColor blackColor];
    _postDateLab.font = [UIFont systemFontOfSize:18.0];
    [_postDateView addSubview:_postDateLab];
    
    
    _postDateField = [[UILabel alloc]init];
    _postDateField.frame = CGRectMake(_postDateLab.frame.origin.x + _postDateLab.frame.size.width, 0, _postDateView.frame.size.width * 0.45, _postDateView.frame.size.height);
    _postDateField.text = @"请输入";
    _postDateField.textAlignment = UITextAlignmentRight;
    _postDateField.font = [UIFont systemFontOfSize:18.0];
    _postDateField.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction:)];
    [_postDateField addGestureRecognizer:dateTap];
    _postDateField.userInteractionEnabled = YES;
    [_postDateView addSubview:_postDateField];
    //_postDateField.isEnabled = false;
    
    UIView * line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(_postDateView.frame.size.width * 0.05, _postDateView.frame.size.height - 1, _postDateView.frame.size.width * 0.95, 1);
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_postDateView addSubview:line2];
    
    
    _stayView = [[UIView alloc]init];
    _stayView.frame = CGRectMake(0, _postDateView.frame.origin.y + _postDateView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _stayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_stayView];
    
    _stayLab = [[UILabel alloc]init];
    _stayLab.frame = CGRectMake(_stayView.frame.size.width * 0.05, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayLab.text = @"是否提供住宿";
    _stayLab.textColor = [UIColor blackColor];
    _stayLab.font = [UIFont systemFontOfSize:18.0];
    [_stayView addSubview:_stayLab];
    
    
    _stayField = [[BaseTextFeild alloc]init];
    _stayField.frame = CGRectMake(_stayLab.frame.origin.x + _stayLab.frame.size.width, 0, _stayView.frame.size.width * 0.45, _stayView.frame.size.height);
    _stayField.placeholder = @"请输入";
    _stayField.textAlignment = UITextAlignmentRight;
    _stayField.font = [UIFont systemFontOfSize:18.0];
    _stayField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *stayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stayAction:)];
    [_stayView addGestureRecognizer:stayTap];
    [_stayView addSubview:_stayField];
    _stayField.enabled = false;
    
    UIView * line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(_stayView.frame.size.width * 0.05, _stayView.frame.size.height - 1, _stayView.frame.size.width * 0.95, 1);
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_salaryView addSubview:line3];
    
    
    _foodView = [[UIView alloc]init];
    _foodView.frame = CGRectMake(0, _stayView.frame.origin.y + _stayView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _foodView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_foodView];
    
    _foodLab = [[UILabel alloc]init];
    _foodLab.frame = CGRectMake(_foodView.frame.size.width * 0.05, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodLab.text = @"是否提供伙食";
    _foodLab.textColor = [UIColor blackColor];
    _foodLab.font = [UIFont systemFontOfSize:18.0];
    [_foodView addSubview:_foodLab];
    
    
    _foodField = [[BaseTextFeild alloc]init];
    _foodField.frame = CGRectMake(_foodLab.frame.origin.x + _foodLab.frame.size.width, 0, _foodView.frame.size.width * 0.45, _foodView.frame.size.height);
    _foodField.placeholder = @"请输入";
    _foodField.textAlignment = UITextAlignmentRight;
    _foodField.font = [UIFont systemFontOfSize:18.0];
    _foodField.keyboardType = UIKeyboardTypeDecimalPad;
    UITapGestureRecognizer *foodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(foodAction:)];
    [_foodView addGestureRecognizer:foodTap];
    [_foodView addSubview:_foodField];
    _foodField.enabled = false;
    
    UIView * line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(_foodView.frame.size.width * 0.05, _foodView.frame.size.height - 1, _foodView.frame.size.width * 0.95, 1);
    line4.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_foodView addSubview:line4];
    
    
    
    _agreementView = [[UIView alloc]init];
//    _agreementView.frame = CGRectMake(0, _foodView.frame.origin.y + _foodView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _agreementView.frame = CGRectMake(0, _foodView.frame.origin.y + _foodView.frame.size.height, _contentView.frame.size.width, height * 0);
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
    [_agreementView addSubview:_agreementField];
    _agreementField.delegate = self;
    UIView * line5 = [[UIView alloc]init];
    line5.frame = CGRectMake(_agreementView.frame.size.width * 0.05, _agreementView.frame.size.height - 1, _agreementView.frame.size.width * 0.95, 1);
    line5.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_agreementView addSubview:line5];
    
    
    _descrView = [[UIView alloc]init];
    _descrView.frame = CGRectMake(0, _agreementView.frame.origin.y + _agreementView.frame.size.height, _contentView.frame.size.width, height * 0.08);
    _descrView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_descrView];
    
    _descrLab = [[UILabel alloc]init];
    _descrLab.frame = CGRectMake(_descrView.frame.size.width * 0.05, 0, _descrView.frame.size.width * 0.45, _descrView.frame.size.height);
    _descrLab.text = @"说明";
    _descrLab.textColor = [UIColor blackColor];
    _descrLab.font = [UIFont systemFontOfSize:18.0];
    [_descrView addSubview:_descrLab];
    
    
    _descrField = [[BaseTextFeild alloc]init];
    _descrField.frame = CGRectMake(_descrLab.frame.origin.x + _descrLab.frame.size.width, 0, _descrView.frame.size.width * 0.45, _descrView.frame.size.height);
    _descrField.placeholder = @"请输入";
    _descrField.textAlignment = UITextAlignmentRight;
    _descrField.font = [UIFont systemFontOfSize:18.0];
//    _descrField.keyboardType = UIKeyboardTypeDecimalPad;
    [_descrView addSubview:_descrField];
    _descrField.delegate = self;
    UIView * line6 = [[UIView alloc]init];
    line6.frame = CGRectMake(_descrView.frame.size.width * 0.05, _descrView.frame.size.height - 1, _descrView.frame.size.width * 0.95, 1);
    line6.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_descrView addSubview:line6];
    
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, _descrView.frame.size.height + _descrView.frame.origin.y, _contentView.frame.size.width, height * 0.05);
    [_scrollView addSubview:_bottomView];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.frame = CGRectMake(_bottomView.frame.size.width * 0.05, 0, _bottomView.frame.size.width * 0.45, _bottomView.frame.size.height);
    _bottomLab.text = @"第四步，共五步";
    _bottomLab.font = [UIFont systemFontOfSize:13.0];
    _bottomLab.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [_bottomView addSubview:_bottomLab];
    
    
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

@end
