//
//  UIViewController+addTablew.m
//  CompanyCircle
//
//  Created by gitBurning on 16/4/20.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "UIViewController+addTablew.h"
#import <objc/runtime.h>

static char const * const nomolTablewKey = "nomolTablew";
//static char const * const groupTablewKey = "groupTablew";

@implementation UIViewController (addTablew)

-(void)addNomolTablewDelegate:(id)delegate
{
    if (self.categoryTablew) {
        [self.categoryTablew removeFromSuperview];
    }
    self.categoryTablew = [[UITableView alloc] initWithFrame:CGRectZero];
    self.categoryTablew.dataSource = delegate;
    self.categoryTablew.delegate = delegate;
    
    [self.view addSubview:self.categoryTablew];
    self.categoryTablew.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.categoryTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        
       // make.edges.equalTo(ws.view);
        make.left.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@(kIphonexButtomHeight()));

    }];
    
    self.categoryTablew.tableFooterView = [UIView new];
    
    self.categoryTablew.backgroundColor = kTablewBgColorLight();

}

-(void)addGrounpTablewDelegate:(id)delegate
{

    
    if (self.categoryTablew) {
        [self.categoryTablew removeFromSuperview];
    }
    self.categoryTablew = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.categoryTablew.dataSource = delegate;
    self.categoryTablew.delegate = delegate;
    
    [self.view addSubview:self.categoryTablew];

    [self.categoryTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@(0));
        make.bottom.equalTo(@(kIphonexButtomHeight()));
    }];
    
    self.categoryTablew.backgroundColor = kTablewBgColorLight();
    self.categoryTablew.tableFooterView = [UIView new];

    self.categoryTablew.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;


}
-(void)addOffsetYGrounpTablewDelegate:(id)delegate withOffsetY:(CGFloat)offsetY
{
    if (self.categoryTablew) {
        [self.categoryTablew removeFromSuperview];
    }
    self.categoryTablew = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.categoryTablew.dataSource = delegate;
    self.categoryTablew.delegate = delegate;
    
    [self.view addSubview:self.categoryTablew];

    [self.categoryTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@(-offsetY));
        make.bottom.equalTo(@0);
    }];
    
    self.categoryTablew.backgroundColor = kTablewBgColorLight();
    self.categoryTablew.tableFooterView = [UIView new];
    
    self.categoryTablew.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

-(UITableView *)categoryTablew
{
    return objc_getAssociatedObject(self, nomolTablewKey);
}

-(void)setCategoryTablew:(UITableView *)categoryTablew
{
    [categoryTablew br_fitios11];
    objc_setAssociatedObject(self, nomolTablewKey, categoryTablew, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}





//-(UITableView *)groupTablew
//{
//    return objc_getAssociatedObject(self, groupTablewKey);
//}
//
//-(void)setGroupTablew:(UITableView *)groupTablew
//{
//    objc_setAssociatedObject(self, groupTablewKey, groupTablew, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//}
@end
