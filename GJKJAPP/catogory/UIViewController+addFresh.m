//
//  UIViewController+addFresh.m
//  MakeMoney
//
//  Created by gitBurning on 15/9/15.
//  Copyright (c) 2015年 王坜. All rights reserved.
//

#import "UIViewController+addFresh.h"
#import <objc/runtime.h>
#import "MJRefresh.h"

static char const * const ObjectTagKey = "tablew";
@implementation UIViewController (addFresh)
-(void)addFreshPull:(id)tablew withBlock:(void (^)(id))pullBlock
{
    
    self.freshTablew=tablew;
    if (pullBlock) {
        
        WS(ws);
        self.freshTablew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (![ws.freshTablew.mj_footer isRefreshing]) {
                pullBlock(nil);

            }else{
                [ws headerEndFreshPull];
            }
        }];
      
    }
}
- (void)addActivityFreshPull:( id)tablew withBlock:(void (^)(id))pullBlock {
    
    self.freshTablew=tablew;
    if (pullBlock) {
        
        WS(ws);
        self.freshTablew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (![ws.freshTablew.mj_footer isRefreshing]) {
                pullBlock(nil);
                
            }else{
                [ws headerEndFreshPull];
            }
        }];
        
    }
    
}

- (void)modifyHeaderMjOffsetY:(CGFloat)offsetY {
    
    self.freshTablew.mj_header.ignoredScrollViewContentInsetTop = offsetY;

}
- (void)modifyFooderMjOffsetY:(CGFloat)offsetY {
    
    self.freshTablew.mj_footer.ignoredScrollViewContentInsetBottom = offsetY;
}
-(void)headerEndFreshPull
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.freshTablew.mj_header endRefreshing];
        [self.freshTablew.mj_footer endRefreshing];

    });
  
}
-(void)headerBeginFreshPull
{
    if (self.freshTablew.mj_header == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        if (![self.freshTablew.mj_header isRefreshing]) {
            
            [self.freshTablew.mj_header beginRefreshing];
        }
        
    });
    
}
-(void)removeHeader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.freshTablew.mj_header removeFromSuperview];
        
    });
}
- (UIView *)br_getHeaderView {
    return self.freshTablew.mj_header;
}
-(void)removeFooter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.freshTablew.mj_footer removeFromSuperview];
       // self.freshTablew.tableFooterView = [UIView new];
    
    });


}
-(void)footerEndFreshPull{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.freshTablew.mj_footer endRefreshing];
            [self.freshTablew.mj_header endRefreshing];

        
    });

}
-(void)footerBeginFreshPull
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self.freshTablew.mj_footer isRefreshing]) {
           [self.freshTablew.mj_footer beginRefreshing];
        }
        
    });

}
-(void)addFooterFresh:(id )tablew withBlock:(void (^)(id))pullBlock
{
    self.freshTablew=tablew;
    if (pullBlock) {
        WS(ws);
        //MJRefreshAutoNormalFooter  MJRefreshBackNormalFooter
        self.freshTablew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            
            if (![ws.freshTablew.mj_header isRefreshing]) {
                pullBlock(nil);
                
            }else{
                [ws footerEndFreshPull];
            }
        }];
    }
}

-(UITableView *)freshTablew
{
    return objc_getAssociatedObject(self, ObjectTagKey);
}

-(void)setFreshTablew:(UITableView *)freshTablew
{
    objc_setAssociatedObject(self, ObjectTagKey, freshTablew, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

@end
