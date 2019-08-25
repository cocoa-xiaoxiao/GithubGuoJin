//
//  UIImageView+SDWebImageModify.h
//  CompanyCircle
//
//  Created by gitBurning on 16/5/31.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
@interface UIImageView (SDWebImageModify)
//default_logo
@property (nonatomic, strong) UIImageView *loadingImgView;
/*!
 *  @brief  [imageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePerson].imageurl] placeholderImage:kUserDefaultImage options:SDWebImageLowPriority];
 */

-(void)br_SDWebSetImageWithURL:(NSURL*)url placeholderImage:(UIImage*)image;

-(void)br_SDWebSetImageWithURLString:(NSString*)urlString placeholderImage:(UIImage*)image;


-(void)br_SDWebSetImageWithURL:(NSURL*)url placeholderImage:(UIImage*)image options:(SDWebImageOptions)options;
-(void)br_SDWebSetImageWithURLString:(NSString*)urlString placeholderImage:(UIImage*)image options:(SDWebImageOptions)options;

- (void)br_SDWebSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)br_SDWebSetImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

+(void)br_DownSDWebImage:(NSURL *)url options:(SDWebImageOptions)options
                progress:(SDWebImageDownloaderProgressBlock)progressBlock
               completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;

+(void)br_DownSDWebImageString:(NSString *)urlString options:(SDWebImageOptions)options
                progress:(SDWebImageDownloaderProgressBlock)progressBlock
               completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;
@end
