//
//  UIButton+SDWebImageModify.m
//  QingHaiTravle
//
//  Created by gitBurning on 16/9/12.
//  Copyright © 2016年 BR. All rights reserved.
//

#import "UIButton+SDWebImageModify.h"
#import <objc/runtime.h>

static const char *loadingBtnImgViewkey = "loadingBtnImgViewkey";
@implementation UIButton (SDWebImageModify)

-(void)setLoadingImgView:(UIImageView *)loadingImgView {
    
    objc_setAssociatedObject(self, loadingBtnImgViewkey, loadingImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)loadingImgView{
    
    return objc_getAssociatedObject(self, loadingBtnImgViewkey);
}
- (void)br_showDefaultImage:(BOOL)isShow{
    if (self.loadingImgView == nil) {
        self.loadingImgView = [[UIImageView alloc] init];
        [self addSubview:self.loadingImgView];
//        [self.loadingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//            make.width.equalTo(self).multipliedBy(0.4);
//            make.width.mas_greaterThanOrEqualTo(40);
//            make.height.equalTo(self.loadingImgView.mas_width);
//        }];
        
        CGFloat size_width = self.bounds.size.width * 0.4;
        size_width = MIN(size_width, 50);
        [self.loadingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            
            //            make.width.equalTo(self).multipliedBy(0.4);
            make.height.equalTo(self.loadingImgView.mas_width);
            //            make.width.mas_greaterThanOrEqualTo(40);
            make.width.mas_equalTo(size_width);
            
        }];
        self.loadingImgView.image = [UIImage imageNamed:@"loading_default_logo"];
    }
    self.loadingImgView.hidden = !isShow;
    if (isShow) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)BR_SetBackgroundImageWithUrlString:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)image
{
    url = [self detailUrl:url];
    
    
    if (url) {
        [self br_showDefaultImage:YES];
        image = nil;
        WS(ws);
//        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [ws br_showDefaultImage:NO];
//        }];
//        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:image];
        
    }else{
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
}

- (void)BR_SetBackgroundImageWithUrlString:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)image completed:(void (^)(UIImage *, NSError *, SDImageCacheType, NSURL *))completedBlock {
    
    url = [self detailUrl:url];
    
    if (url) {
        
//        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:image options:SDWebImageRetryFailed completed:completedBlock];
        //        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:image];
        
    }else{
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    
}

-(NSString*)detailUrl:(NSString*)url
{
    NSString *urlString = url;
    if (urlString.length == 0) {
        
        return nil;
    }
    if ([urlString rangeOfString:@"http"].location == NSNotFound) {
        
        urlString = [@"" stringByAppendingString:urlString];
    }
    
    return urlString;

}
@end
