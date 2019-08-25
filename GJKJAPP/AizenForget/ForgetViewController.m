//
//  ForgetViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/1/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "ForgetViewController.h"
#import "PhoneInfo.h"
#import "ZFDropDown.h"

@interface ForgetViewController ()<ZFDropDownDelegate>

@property UIView *topView;
@property UIView *titleView;
@property UIView *contentView;
@property UIImageView *goBackView;
@property UILabel *titleLab;
@property NSString *phoneType;

@property(nonatomic,strong) UIView *space1;
@property(nonatomic,strong) UIView *space2;
@property(nonatomic,strong) UIView *space3;
@property(nonatomic,strong) UIImageView *problemImg1;
@property(nonatomic,strong) UIImageView *problemImg2;
@property(nonatomic,strong) UIImageView *problemImg3;
@property(nonatomic,strong) UIImageView *answerImg1;
@property(nonatomic,strong) UIImageView *answerImg2;
@property(nonatomic,strong) UIImageView *answerImg3;
@property (nonatomic, strong) ZFDropDown * problem1;
@property (nonatomic, strong) ZFDropDown * problem2;
@property (nonatomic, strong) ZFDropDown * problem3;
@property (nonatomic,strong) UITextField * answer1;
@property (nonatomic,strong) UITextField * answer2;
@property (nonatomic,strong) UITextField * answer3;
@property (nonatomic, strong) ZFTapGestureRecognizer * tap;
@property (nonatomic,strong) UIButton * confrimBtn;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property(nonatomic,strong) NSArray *problemArr;

@end

@implementation ForgetViewController

-(void) FirstLayout{
    _phoneType = [PhoneInfo iphoneType];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([_phoneType isEqualToString:@"iPhone X"]){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+44)];
        _topView.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
        [self.view addSubview:_topView];
        
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
        _titleView.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
        [_topView addSubview:_titleView];
        
        _goBackView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleView.frame.size.width * 0.05, _titleView.frame.size.height * 0.25, _titleView.frame.size.height * 0.5, _titleView.frame.size.height * 0.5)];
        _goBackView.image = [UIImage imageNamed:@"gj_gobacklogo"];
        [_titleView addSubview:_goBackView];
        UITapGestureRecognizer *gobackAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
        _goBackView.userInteractionEnabled = YES;
        [_goBackView addGestureRecognizer:gobackAction];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_goBackView.frame.size.width + _goBackView.frame.origin.x, _titleView.frame.size.height * 0.25, _titleView.frame.size.width - (_titleView.frame.size.height * 0.5 * 2) -_titleView.frame.size.width * 0.05 * 2, _titleView.frame.size.height * 0.5)];
        _titleLab.text = @"忘记密码";
        _titleLab.textAlignment = UITextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:20.0];
        [_titleView addSubview:_titleLab];
    }else{
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20+44)];
        _topView.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
        [self.view addSubview:_topView];
        
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        _titleView.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
        [_topView addSubview:_titleView];
        
        _goBackView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleView.frame.size.width * 0.05, _titleView.frame.size.height * 0.25, _titleView.frame.size.height * 0.5, _titleView.frame.size.height * 0.5)];
        _goBackView.image = [UIImage imageNamed:@"gj_gobacklogo"];
        [_titleView addSubview:_goBackView];
        UITapGestureRecognizer *gobackAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
        _goBackView.userInteractionEnabled = YES;
        [_goBackView addGestureRecognizer:gobackAction];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_goBackView.frame.size.width + _goBackView.frame.origin.x, _titleView.frame.size.height * 0.25, _titleView.frame.size.width - (_titleView.frame.size.height * 0.5 * 2) -_titleView.frame.size.width * 0.05 * 2, _titleView.frame.size.height * 0.5)];
        _titleLab.text = @"忘记密码";
        _titleLab.textAlignment = UITextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:20.0];
        [_titleView addSubview:_titleLab];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self FirstLayout];
    [self startLayout];
}


-(void) startLayout{
    _problemArr = @[@"您出生年月日是？", @"您出生地是？", @"您的家乡是？", @"您父亲姓氏是？", @"您母亲姓名是？", @"您有多少存款？"];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height + _topView.frame.origin.x, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height)];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _space1 = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _contentView.frame.size.height * 0.05,_contentView.frame.size.height * 0.15 /2, _contentView.frame.size.height * 0.15)];
    [_contentView addSubview:_space1];
    _problemImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _space1.frame.size.width, _space1.frame.size.width)];
    _problemImg1.image = [UIImage imageNamed:@"gj_problem"];
    [_space1 addSubview:_problemImg1];
    _answerImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _space1.frame.size.height * 0.5, _space1.frame.size.width, _space1.frame.size.width)];
    _answerImg1.image = [UIImage imageNamed:@"gj_answer"];
    [_space1 addSubview:_answerImg1];
    _problem1 = [[ZFDropDown alloc] initWithFrame:CGRectMake(_space1.frame.size.width + _space1.frame.origin.x, _space1.frame.origin.y, (_contentView.frame.size.width * 0.9) - _space1.frame.size.width, _problemImg1.frame.size.height) pattern:kDropDownPatternDefault];
    _problem1.delegate = self;
    [_problem1.topicButton setTitle:@"请选择第1个问题。" forState:UIControlStateNormal];
    _problem1.topicButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    _problem1.cornerRadius = 10.f;
    [_contentView addSubview:_problem1];
    _answer1 = [[UITextField alloc]initWithFrame:CGRectMake(_problem1.frame.origin.x + 10, _problem1.frame.origin.y + _problem1.frame.size.height, _problem1.frame.size.width, _problem1.frame.size.height)];
    _answer1.placeholder = @"请回答第1个问题";
    [_contentView addSubview:_answer1];
    _line1 = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _space1.frame.origin.y + _space1.frame.size.height + _contentView.frame.size.height * 0.025, _contentView.frame.size.width * 0.95, 1)];
    _line1.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_contentView addSubview:_line1];
    
    
    
    _space2 = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _space1.frame.size.height + _space1.frame.origin.y + _contentView.frame.size.height * 0.05, _contentView.frame.size.height * 0.15/2, _contentView.frame.size.height * 0.15)];
    [_contentView addSubview:_space2];
    _problemImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _space2.frame.size.width, _space2.frame.size.width)];
    _problemImg2.image = [UIImage imageNamed:@"gj_problem"];
    [_space2 addSubview:_problemImg2];
    _answerImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _space2.frame.size.height * 0.5, _space2.frame.size.width, _space2.frame.size.width)];
    _answerImg2.image = [UIImage imageNamed:@"gj_answer"];
    [_space2 addSubview:_answerImg2];
    _problem2 = [[ZFDropDown alloc] initWithFrame:CGRectMake(_space2.frame.size.width + _space2.frame.origin.x, _space2.frame.origin.y, (_contentView.frame.size.width * 0.9) - _space2.frame.size.width, _problemImg2.frame.size.height) pattern:kDropDownPatternDefault];
    _problem2.delegate = self;
    [_problem2.topicButton setTitle:@"请选择第2个问题。" forState:UIControlStateNormal];
    _problem2.topicButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    _problem2.cornerRadius = 10.f;
    [_contentView addSubview:_problem2];
    _answer2 = [[UITextField alloc]initWithFrame:CGRectMake(_problem2.frame.origin.x + 10, _problem2.frame.origin.y + _problem2.frame.size.height, _problem2.frame.size.width, _problem2.frame.size.height)];
    _answer2.placeholder = @"请回答第2个问题";
    [_contentView addSubview:_answer2];
    _line2 = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _space2.frame.origin.y + _space2.frame.size.height + _contentView.frame.size.height * 0.025, _contentView.frame.size.width * 0.95, 1)];
    _line2.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_contentView addSubview:_line2];
    
    
    
    
    _space3 = [[UIView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _space2.frame.size.height + _space2.frame.origin.y + _contentView.frame.size.height * 0.05, _contentView.frame.size.height * 0.15/2, _contentView.frame.size.height * 0.15)];
    [_contentView addSubview:_space3];
    _problemImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _space3.frame.size.width, _space3.frame.size.width)];
    _problemImg3.image = [UIImage imageNamed:@"gj_problem"];
    [_space3 addSubview:_problemImg3];
    _answerImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _space3.frame.size.height * 0.5, _space3.frame.size.width, _space3.frame.size.width)];
    _answerImg3.image = [UIImage imageNamed:@"gj_answer"];
    [_space3 addSubview:_answerImg3];
    _problem3 = [[ZFDropDown alloc] initWithFrame:CGRectMake(_space3.frame.size.width + _space3.frame.origin.x, _space3.frame.origin.y, (_contentView.frame.size.width * 0.9) - _space3.frame.size.width, _problemImg3.frame.size.height) pattern:kDropDownPatternDefault];
    _problem3.delegate = self;
    [_problem3.topicButton setTitle:@"请选择第3个问题。" forState:UIControlStateNormal];
    _problem3.topicButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    _problem3.cornerRadius = 10.f;
    [_contentView addSubview:_problem3];
    _answer3 = [[UITextField alloc]initWithFrame:CGRectMake(_problem3.frame.origin.x + 10, _problem3.frame.origin.y + _problem3.frame.size.height, _problem3.frame.size.width, _problem3.frame.size.height)];
    _answer3.placeholder = @"请回答第3个问题";
    [_contentView addSubview:_answer3];
    
    
    _confrimBtn = [[UIButton alloc]initWithFrame:CGRectMake(_contentView.frame.size.width * 0.05, _space3.frame.origin.y + _space3.frame.size.height + _contentView.frame.size.height * 0.05, _contentView.frame.size.width * 0.9, _contentView.frame.size.height * 0.07)];
    _confrimBtn.backgroundColor = [UIColor colorWithRed:20/255.0 green:184/255.0 blue:247/255.0 alpha:1];
    [_confrimBtn setTitle:@"提交" forState:UIControlStateNormal];
    _confrimBtn.layer.cornerRadius = 5;
    [_confrimBtn addTarget:self action:@selector(forgetAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_confrimBtn];
    

    _tap = [[ZFTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_contentView addGestureRecognizer:_tap];
}



-(void) forgetAction{
    NSString *problemStr1 = _problem1.topicButton.currentTitle;
    NSString *problemStr2 = _problem2.topicButton.currentTitle;
    NSString *problemStr3 = _problem3.topicButton.currentTitle;
    NSString *answerStr1 = _answer1.text;
    NSString *answerStr2 = _answer2.text;
    NSString *answerStr3 = _answer3.text;
    
    if([problemStr1 isEqualToString:problemStr2] || [problemStr1 isEqualToString:problemStr3] || [problemStr2 isEqualToString:problemStr3]){
        //报错，请选择三个不同的问题。
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择3个不同的问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if([_problemArr containsObject:problemStr1] && [_problemArr containsObject:problemStr2] && [_problemArr containsObject:problemStr3]){
            if(answerStr1 == @"" || answerStr2 == @"" || answerStr3 == @""){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请回答全部问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                //下一步提交
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


-(void)goBack:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tapAction{
    [_problem1 resignDropDownResponder];
    [_problem2 resignDropDownResponder];
    [_problem3 resignDropDownResponder];
}

#pragma mark - ZFDropDownDelegate
- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    return _problemArr;
}

- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
