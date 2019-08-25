//
//  BROpenWordManager.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/21.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BROpenWordManager : NSObject

+ (instancetype)share;
- (void)br_openAWordWithUrl:(NSString *)url fileId:(NSString *)fileId vc:(BaseViewController *)vc;
@end
