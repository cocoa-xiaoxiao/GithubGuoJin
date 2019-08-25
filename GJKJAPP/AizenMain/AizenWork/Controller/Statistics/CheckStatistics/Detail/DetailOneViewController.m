//
//  DetailOneViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/5/14.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "DetailOneViewController.h"
#import "AizenMD5.h"
#import "AizenHttp.h"
#import "AizenStorage.h"
#import "DGActivityIndicatorView.h"


@interface DetailOneViewController ()

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *imgView;

@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *dateLab;
@property(nonatomic,strong) UILabel *stationLab;
@property(nonatomic,strong) UILabel *addressLab;

@property(nonatomic,strong) UIView *allImgView;
@property(nonatomic,strong) UIImageView *ImgView1;
@property(nonatomic,strong) UIImageView *ImgView2;
@property(nonatomic,strong) UIImageView *ImgView3;
@property(nonatomic,strong) UIImageView *ImgView4;




@end

@implementation DetailOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"考勤详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    [self startLayout];
}

-(void) startLayout{
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR,self.view.frame.size.width,  self.view.frame.size.height - HEIGHT_NAVBAR - HEIGHT_STATUSBAR);
    _contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    [self detailLayout];
}


-(void) detailLayout{
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height * 0.3);
    _topView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_topView];
    
    
    _imgView = [[UIImageView alloc]init];
    _imgView.frame = CGRectMake(_topView.frame.size.width * 0.05, _topView.frame.size.width * 0.02, _topView.frame.size.height * 0.3, _topView.frame.size.height * 0.3);
    _imgView.layer.cornerRadius = _topView.frame.size.height * 0.3/2;
    _imgView.layer.masksToBounds = YES;
    _imgView.image = [UIImage imageNamed:@"gj_msglogo3"];
    [_topView addSubview:_imgView];
    
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.frame = CGRectMake(_imgView.frame.size.width + _imgView.frame.origin.x + _topView.frame.size.width * 0.02, _imgView.frame.origin.y, _topView.frame.size.width * 0.2, _imgView.frame.size.height / 2);
    _nameLab.text = @"张小伞";
    _nameLab.textColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1];
    _nameLab.font = [UIFont systemFontOfSize:16.0];
    [_topView addSubview:_nameLab];
    
    
    _dateLab = [[UILabel alloc]init];
    _dateLab.frame = CGRectMake(_topView.frame.size.width * 0.55, _imgView.frame.origin.y, _topView.frame.size.width * 0.4, _imgView.frame.size.height / 2);
    _dateLab.textColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1];
    _dateLab.font = [UIFont systemFontOfSize:16.0];
    _dateLab.text = @"2018-05-12 17:12";
    _dateLab.textAlignment = UITextAlignmentRight;
    [_topView addSubview:_dateLab];
    
    
    _stationLab = [[UILabel alloc]init];
    _stationLab.frame = CGRectMake(_nameLab.frame.origin.x, _nameLab.frame.size.height + _nameLab.frame.origin.y, _topView.frame.size.width * 0.6, _imgView.frame.size.height / 2);
    _stationLab.text = @"实习岗位：盛杰科技有限公司";
    _stationLab.textColor = [UIColor colorWithRed:224/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    _stationLab.font = [UIFont systemFontOfSize:16.0];
    [_topView addSubview:_stationLab];
    
    
    
    
    _addressLab = [[UILabel alloc]init];
    _addressLab.frame = CGRectMake(_imgView.frame.origin.x, _imgView.frame.size.height + _imgView.frame.origin.y + _topView.frame.size.height * 0.05, _topView.frame.size.width * 0.9, _topView.frame.size.height * 0.1);
    _addressLab.text = @"GPS地址：广东省佛山市。。。。。。。。。。。。。。。。。。。。。";
    _addressLab.textColor = [UIColor colorWithRed:224/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    _addressLab.font = [UIFont systemFontOfSize:16.0];
    [_topView addSubview:_addressLab];
    
    
    _allImgView = [[UIView alloc]init];
    _allImgView.frame = CGRectMake(_topView.frame.size.width * 0.05, _addressLab.frame.origin.y + _addressLab.frame.size.height + _topView.frame.size.height * 0.05, _topView.frame.size.width * 0.9, _topView.frame.size.height - (_topView.frame.size.width * 0.02 + _imgView.frame.size.height + _topView.frame.size.height * 0.05 + _addressLab.frame.size.height + _topView.frame.size.height * 0.05 + _topView.frame.size.height * 0.05));
    [_topView addSubview:_allImgView];
    
    
    
    _ImgView1 = [[UIImageView alloc]init];
    _ImgView1.frame = CGRectMake(0, 0, _allImgView.frame.size.height, _allImgView.frame.size.height);
    _ImgView1.image = [UIImage imageNamed:@"gj_unicon"];
    [_allImgView addSubview:_ImgView1];
    
    _ImgView2 = [[UIImageView alloc]init];
    _ImgView2.frame = CGRectMake(_ImgView1.frame.size.width + (_allImgView.frame.size.width - (_allImgView.frame.size.height * 4))/3, 0, _allImgView.frame.size.height, _allImgView.frame.size.height);
    _ImgView2.image = [UIImage imageNamed:@"gj_unicon"];
    [_allImgView addSubview:_ImgView2];
    
    
    _ImgView3 = [[UIImageView alloc]init];
    _ImgView3.frame = CGRectMake(_ImgView2.frame.size.width + _ImgView2.frame.origin.x + (_allImgView.frame.size.width - (_allImgView.frame.size.height * 4))/3, 0, _allImgView.frame.size.height, _allImgView.frame.size.height);
    _ImgView3.image = [UIImage imageNamed:@"gj_unicon"];
    [_allImgView addSubview:_ImgView3];
    
    
    _ImgView4 = [[UIImageView alloc]init];
    _ImgView4.frame = CGRectMake(_ImgView3.frame.size.width + _ImgView3.frame.origin.x + (_allImgView.frame.size.width - (_allImgView.frame.size.height * 4))/3, 0, _allImgView.frame.size.height, _allImgView.frame.size.height);
    _ImgView4.image = [UIImage imageNamed:@"gj_unicon"];
    [_allImgView addSubview:_ImgView4];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
