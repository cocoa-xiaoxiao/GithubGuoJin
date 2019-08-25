//
//  UIViewController+addTablew.h
//  CompanyCircle
//
//  Created by gitBurning on 16/4/20.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (addTablew)<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *categoryTablew;


-(void)addNomolTablewDelegate:(id)delegate;
-(void)addGrounpTablewDelegate:(id)delegate;
-(void)addOffsetYGrounpTablewDelegate:(id)delegate withOffsetY:(CGFloat)offsetY;


@end
