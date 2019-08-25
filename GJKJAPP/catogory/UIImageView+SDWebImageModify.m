//
//  UIImageView+SDWebImageModify.m
//  CompanyCircle
//
//  Created by gitBurning on 16/5/31.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "UIImageView+SDWebImageModify.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <objc/runtime.h>

 static const char *loadingImgViewkey = "loadingImgView";
@implementation UIImageView (SDWebImageModify)

-(void)setLoadingImgView:(UIImageView *)loadingImgView {
    
    objc_setAssociatedObject(self, loadingImgViewkey, loadingImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)loadingImgView{
   
    return objc_getAssociatedObject(self, loadingImgViewkey);
}
//- (void)br_showDefaultImage:(BOOL)isShow{
//    if (self.loadingImgView == nil) {
//        self.loadingImgView = [[UIImageView alloc] init];
//        [self addSubview:self.loadingImgView];
//        CGFloat size_width = self.bounds.size.width * 0.4;
//        size_width = MIN(size_width, 50);
//        [self.loadingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//
////            make.width.equalTo(self).multipliedBy(0.4);
//            make.height.equalTo(self.loadingImgView.mas_width);
////            make.width.mas_greaterThanOrEqualTo(40);
//            make.width.mas_equalTo(size_width);
//
//        }];
//        self.loadingImgView.image = [UIImage imageNamed:@"loading_default_logo"];
//    }
//    self.loadingImgView.hidden = !isShow;
//    if (isShow) {
//        self.backgroundColor = [UIColor lightGrayColor];
//    }
//    else{
//        self.backgroundColor = [UIColor clearColor];
//    }
//
//}
-(void)br_SDWebSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image
{
    
    NSString *urlString = url.absoluteString;
    if (urlString.length == 0) {
        self.image = image;

        return;
    }
    if ([urlString rangeOfString:@"http"].location == NSNotFound) {
        
//        urlString = [PICTURE_HOST stringByAppendingString:urlString];
    }
    
    NSLog(@"----imageUrl %@",urlString);
    url = [NSURL URLWithString:urlString];
    
//    [self br_showDefaultImage:YES];
//    image = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (url.absoluteString.length>0) {

            UIImage *cachaImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
            
            if (cachaImage) {
                
                self.image = cachaImage;
              //  [self br_showDefaultImage:NO];

            }
            else{
                
                WS(ws);
              //  [self sd_setImageWithURL:url placeholderImage:image];
//                [self br_SDWebSetImageWithURL:url placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    [ws br_showDefaultImage:NO];
//                }];
                [self sd_setImageWithURL:url placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 //   [ws br_showDefaultImage:NO];
                }];
               
            }
        }else{
            self.image = image;
          //  [self br_showDefaultImage:NO];

        }
    });
    
}
-(void)br_SDWebSetImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)image
{
    
    if (urlString) {
        
        [self br_SDWebSetImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image];
    }else{
        self.image = image;

    }
}



-(void)br_SDWebSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image options:(SDWebImageOptions)options
{

//    if (url.absoluteString.length>0) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self sd_setImageWithURL:url placeholderImage:image options:options];
//            
//        });
//    }else{
//        self.image = image;
//    }
    
    NSString *urlString = url.absoluteString;
    if (urlString.length == 0) {
        self.image = image;

        return;
    }
    
    if ([urlString rangeOfString:@"http"].location == NSNotFound) {
        
        urlString = [@"" stringByAppendingString:urlString];
    }
    
//    [self br_showDefaultImage:YES];
//    image = nil;
    url = [NSURL URLWithString:urlString];
     dispatch_async(dispatch_get_main_queue(), ^{
        if (url.absoluteString.length>0) {
            
            UIImage *cachaImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
            
            if (cachaImage) {
                
                self.image = cachaImage;
               // [self br_showDefaultImage:NO];

            }
            else{
               
                WS(ws);
                [self sd_setImageWithURL:url placeholderImage:image options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   //// [ws br_showDefaultImage:NO];
                }];
                    
               
            }
        }else{
            self.image = image;
          //  [self br_showDefaultImage:NO];

        }
    });
    
}
-(void)br_SDWebSetImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)image options:(SDWebImageOptions)options
{
    if (urlString) {
        
        [self br_SDWebSetImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image options:options];
    }else{
        self.image = image;
        
    }

}

-(void)br_SDWebSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
//    if (url.absoluteString.length>0) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//          //  [self br_SDWebSetImageWithURL:url placeholderImage:placeholder completed:completedBlock];
//            [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
//        });
//    }else{
//        self.image = placeholder;
//    }
    
    
    NSString *urlString = url.absoluteString;
    if (urlString.length == 0) {
        self.image = placeholder;

        return;
    }
    
    if ([urlString rangeOfString:@"http"].location == NSNotFound) {
        
        urlString = [@"" stringByAppendingString:urlString];
    }
    
//    [self br_showDefaultImage:YES];
//    placeholder = nil;
    url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_main_queue(), ^{

        if (url.absoluteString.length>0) {
            
            UIImage *cachaImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
            
            if (cachaImage) {
                
                self.image = cachaImage;
              //  [self br_showDefaultImage:NO];

            }
            else{
              //  WS(ws);
                    [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock ];
                    
            }
        }else{
            self.image = placeholder;
          //  [self br_showDefaultImage:NO];

        }
    });

    
}


-(void)br_SDWebSetImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    if (urlString) {
        
        [self br_SDWebSetImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder completed:completedBlock];
    }else{
        self.image = placeholder;
        
    }

}
+(void)br_DownSDWebImage:(NSURL *)url options:(SDWebImageOptions)options
                progress:(SDWebImageDownloaderProgressBlock)progressBlock
               completed:(SDWebImageCompletionWithFinishedBlock)completedBlock
{
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:options progress:progressBlock completed:completedBlock];
    
}


+(void)br_DownSDWebImageString:(NSString *)urlString options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionWithFinishedBlock)completedBlock
{
    if (urlString) {
        [UIImageView br_DownSDWebImage:[NSURL URLWithString:urlString] options:options progress:progressBlock completed:completedBlock];
    }
}
@end
