//
//  UIViewController+addFresh.h
//  MakeMoney
//
//  Created by gitBurning on 15/9/15.
//  Copyright (c) 2015年 王坜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (addFresh)
@property(strong,nonatomic) UITableView * freshTablew;
-(void)addFreshPull:(id )tablew withBlock:(void (^)(id info))pullBlock;
- (void)modifyHeaderMjOffsetY:(CGFloat)offsetY;
-(void)headerEndFreshPull;
-(void)headerBeginFreshPull;
-(void)removeHeader;

-(void)addFooterFresh:(id)tablew withBlock:(void (^)(id info))pullBlock;
- (void)modifyFooderMjOffsetY:(CGFloat)offsetY;

-(void)footerEndFreshPull;
-(void)footerBeginFreshPull;
-(void)removeFooter;

- (UIView *)br_getHeaderView;
- (void)br_configNotDataDefaultShow;
@end
