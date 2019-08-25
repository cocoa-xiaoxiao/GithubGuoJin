//
//  ChooseSingImage.h
//  Meirong
//
//  Created by gitBurning on 15/8/30.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseSingImage : UIView
@property(strong,nonatomic) UIColor *navColor;
@property (assign,nonatomic) BOOL canEidit;
+(instancetype)shareChooseImage;

/**
 *  显示 图片选择器
 *
 *  @param vc <#vc description#>
 */
-(void)showPhotoWithVC:(UIViewController*)vc withBlock:(void(^)(UIImage *image,NSDictionary *dict))chooseImageBlock;

- (void)showCameraPhotoWithVC:(UIViewController*)vc withBlock:(void(^)(UIImage *image,NSDictionary *dict))chooseImageBlock;
@end
