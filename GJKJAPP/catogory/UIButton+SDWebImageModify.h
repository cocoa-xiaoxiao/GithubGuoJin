//
//  UIButton+SDWebImageModify.h
//  QingHaiTravle
//
//  Created by gitBurning on 16/9/12.
//  Copyright © 2016年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SDWebImageModify)
@property (nonatomic, strong) UIImageView *loadingImgView;

-(void)BR_SetBackgroundImageWithUrlString:(NSString*)url forState:(UIControlState)state placeholderImage:(UIImage *)image;


- (void)BR_SetBackgroundImageWithUrlString:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)image completed:(void (^)(UIImage *, NSError *, SDImageCacheType, NSURL *))completedBlock;

@end
