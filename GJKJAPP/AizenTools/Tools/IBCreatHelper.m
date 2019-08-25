//
//  IBCreatHelper.m
//  test
//
//  Created by TRILLION on 16/8/11.
//  Copyright © 2016年 TRILLION. All rights reserved.
//

#import "IBCreatHelper.h"

@implementation IBCreatHelper

id getControllerFromStoryBoard (NSString * SBName , NSString * SBID) {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:SBName bundle:[NSBundle mainBundle]];
    
    id VC = [storyboard instantiateViewControllerWithIdentifier:SBID];
    
    if (!VC) {
        printf("Controller %s Where in %s is invalit (好吧，就是无效的页面获取，好好检查一下吧！！)\n",SBName.UTF8String,SBID.UTF8String);
        //给一个默认Controller 安全考虑
        VC = [UIViewController new];
    }
    
    return VC;
    
}

id getInitialFromStoryBoard (NSString * SBName) {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:SBName bundle:[NSBundle mainBundle]];
    
    id VC = [storyboard instantiateInitialViewController];
    
    return VC;
    
}

@end
