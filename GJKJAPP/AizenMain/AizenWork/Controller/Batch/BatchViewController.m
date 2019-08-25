//
//  BatchViewController.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BatchViewController.h"
#import "RDVTabBarController.h"
#import "AizenStorage.h"
#import "PhoneInfo.h"


@interface BatchViewController ()

@property UIView *titleView;
@property UILabel *titleLab;
@property UIScrollView *scrollView;
@property CGFloat this_height;


@end

@implementation BatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"批次";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    _this_height = HEIGHT_NC;
    
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    [backBtnItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBtnItem ;
    
    [self startLayout];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) startLayout{
    _scrollView = self.loadScrollView;
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.backgroundColor = GRAY_BACKGROUND;
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.5);
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _titleView = self.loadTitleView;
    _titleView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _this_height * 0.05);
    [_scrollView addSubview:_titleView];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame = CGRectMake(_titleView.frame.size.width * 0.05, 0, _titleView.frame.size.width * 0.9, _titleView.frame.size.height);
    _titleLab.text = @"选择批次";
    _titleLab.font = [UIFont systemFontOfSize:14.0];
    _titleLab.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1];
    [_titleView addSubview:_titleLab];
    
    [self detailLayout];
}

-(void) detailLayout{
    
    NSArray *dataArr = nil;
    NSString *key = nil;
    if (_link == 1) {
        key = @"xtz";
        dataArr = [[AizenStorage readUserDataWithKey:@"batch"] objectForKey:@"xtz"];
    }else if (_link == 2) {
        key = @"sxgl";
        dataArr = [[AizenStorage readUserDataWithKey:@"batch"] objectForKey:@"sxgl"];
    }else if (_link == 3){
        key = @"lwgl";
        dataArr = [[AizenStorage readUserDataWithKey:@"batch"] objectForKey:@"lwgl"];
    }else{
        key = @"hyhd";
        dataArr = [[AizenStorage readUserDataWithKey:@"batch"] objectForKey:@"hyhd"];
    }
    NSString *batchID = [AizenStorage readUserDataWithKey:@"batchID"];
    int i = 0;
    for(int x = 0;x<[dataArr count];x++){
        NSDictionary *getDic = [dataArr objectAtIndex:x];
        
        UIView *oneView = [[UIView alloc]init];
        oneView.frame = CGRectMake(0,_titleView.frame.size.height + _titleView.frame.origin.y + i * _this_height * 0.2, self.view.frame.size.width, _this_height * 0.2);
        oneView.backgroundColor = [UIColor whiteColor];
        oneView.accessibilityLabel = [NSString stringWithFormat:@"one%d",i];
        [_scrollView addSubview:oneView];
        
        UIView *detailView = [[UIView alloc]init];
        detailView.frame = CGRectMake(10, 10, (oneView.frame.size.width - 20), oneView.frame.size.height - 20);
        detailView.layer.cornerRadius = 5;
        detailView.layer.masksToBounds = YES;
        if([key isEqualToString:@"xtz"]){
            detailView.backgroundColor = [UIColor colorWithRed:19/255.0 green:166/255.0 blue:233/255.0 alpha:1];
        }else if([key isEqualToString:@"sxgl"]){
            detailView.backgroundColor = [UIColor colorWithRed:223/255.0 green:84/255.0 blue:103/255.0 alpha:1];
        }else if([key isEqualToString:@"lwgl"]){
            detailView.backgroundColor = [UIColor colorWithRed:240/255.0 green:115/255.0 blue:61/255.0 alpha:1];
        }else if([key isEqualToString:@"hyhd"]){
            detailView.backgroundColor = [UIColor colorWithRed:117/255.0 green:48/255.0 blue:253/255.0 alpha:1];
        }
        [oneView addSubview:detailView];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(detailView.frame.size.width * 0.03, detailView.frame.size.height * 0.2, detailView.frame.size.height * 0.6, detailView.frame.size.height * 0.6);
        if([key isEqualToString:@"xtz"]){
            imgView.image = [UIImage imageNamed:@"gj_xtzlogo"];
        }else if([key isEqualToString:@"sxgl"]){
            imgView.image = [UIImage imageNamed:@"gj_sxgllogo"];
        }else if([key isEqualToString:@"lwgl"]){
            imgView.image = [UIImage imageNamed:@"gj_lwgllogo"];
        }else if([key isEqualToString:@"hyhd"]){
            imgView.image = [UIImage imageNamed:@"gj_hyhdlogo"];
        }
        [detailView addSubview:imgView];
        
        UILabel *descrLab = [[UILabel alloc]init];
        descrLab.frame = CGRectMake(imgView.frame.size.width * 1.2 + imgView.frame.origin.x, imgView.frame.origin.y, detailView.frame.size.width * 0.6, imgView.frame.size.height * 0.5);
        descrLab.text = [getDic objectForKey:@"ActivityName"];
        descrLab.textColor = [UIColor whiteColor];
        descrLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        [detailView addSubview:descrLab];
        
        
        UILabel *startLab = [[UILabel alloc]init];
        startLab.frame = CGRectMake(imgView.frame.size.width * 1.2 + imgView.frame.origin.x, descrLab.frame.origin.y + descrLab.frame.size.height, detailView.frame.size.width * 0.6, imgView.frame.size.height * 0.25);
        NSRange rang = {0,10};
        NSString *timeStartStr = [[[[getDic objectForKey:@"BeginDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        startLab.text = [NSString stringWithFormat:@"开始时间：%@",[PhoneInfo timestampSwitchTime:[timeStartStr integerValue]  andFormatter:@"YYYY-MM-dd"]];
        startLab.textColor = [UIColor whiteColor];
        startLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        [detailView addSubview:startLab];
        
        UILabel *endLab = [[UILabel alloc]init];
        endLab.frame = CGRectMake(imgView.frame.size.width * 1.2 + imgView.frame.origin.x, startLab.frame.origin.y + startLab.frame.size.height, detailView.frame.size.width * 0.6, imgView.frame.size.height * 0.25);
        NSString *timeEndStr = [[[[getDic objectForKey:@"EndDate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""]substringWithRange:rang];
        endLab.text = [NSString stringWithFormat:@"结束时间：%@",[PhoneInfo timestampSwitchTime:[timeEndStr integerValue]  andFormatter:@"YYYY-MM-dd"]];
        endLab.textColor = [UIColor whiteColor];
        endLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        [detailView addSubview:endLab];
        
        UISwitch *setSwitch = [[UISwitch alloc]init];
        setSwitch.frame = CGRectMake(detailView.frame.size.width - 60, (detailView.frame.size.height - 27) / 2, 79, 27);
        
        NSString *ActivityID = getDic[@"ActivityID"];
        if (![ActivityID isKindOfClass:[NSString class]]) {
            if ([ActivityID isKindOfClass:[NSNumber class]]) {
                ActivityID = [NSString stringWithFormat:@"%@",ActivityID];
            }else{
                ActivityID = @"";
            }
        }
        setSwitch.accessibilityLabel = ActivityID;//[getDic objectForKey:@"ActivityID"];
        [setSwitch addTarget:self action:@selector(selectSwitch:) forControlEvents:UIControlEventValueChanged];
        if(batchID == [NSNull null] || [batchID isEqualToString:@"(null)"]){
            [setSwitch setOn:NO animated:YES];
        }else{
            if([batchID isEqualToString:[NSString stringWithFormat:@"%@",[getDic objectForKey:@"ActivityID"]]]){
                [setSwitch setOn:YES animated:YES];
            }else{
                [setSwitch setOn:NO animated:YES];
            }
        }
        [detailView addSubview:setSwitch];
        
        i++;
    }
    NSLog(@"%@",batchID);
    
    CGFloat scrollHeight = _titleView.frame.size.height + _this_height * 0.2 * i;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight);
    
}



-(void) selectSwitch:(UISwitch *)sender{
    NSString *whichSwitchID = [NSString stringWithFormat:@"%@",sender.accessibilityLabel];
    for (UIView *view in [_scrollView subviews]) {
        for(UIView *detailView in [view subviews]){
            for(id object in [detailView subviews]){
                if([object isKindOfClass:[UISwitch class]]){
                    UISwitch *getSwitch = object;
                    NSString *getID = [NSString stringWithFormat:@"%@",getSwitch.accessibilityLabel];
                    if(![getID isEqualToString:whichSwitchID]){
                        [getSwitch setOn:NO animated:YES];
                    }else{
                       // if (!getSwitch.isOn) {
                            [getSwitch setOn:YES animated:YES];
                            [AizenStorage writeUserDataWithKey:getID forKey:@"batchID"];
                       // }
                       
                    }
                }
            }
        }
    }
}
-(UIView *)loadTitleView{
    if(_titleView == nil){
        _titleView = [[UIView alloc]init];
    }
    return _titleView;
}


-(UIScrollView *)loadScrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}
@end
