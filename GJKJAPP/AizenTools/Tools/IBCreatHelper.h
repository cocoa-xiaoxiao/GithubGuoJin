//
//  IBCreatHelper.h
//  test
//
//  Created by TRILLION on 16/8/11.
//  Copyright © 2016年 TRILLION. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IBCreatHelper : NSObject

/**
 *  通过storyboard初始化一个Controller
 *
 *  @param SBName storyboard 文件名称
 *  @param SBID   页面identifier
 *
 *  @return 返回目标ViewController对象
 */
id getControllerFromStoryBoard (NSString * SBName , NSString * SBID);

/**
 *  通过storyboard对接rootVC
 *
 *  @param SBName storyboard 文件名称
 *
 *  @return 返回目标ViewController对象
 */
id getInitialFromStoryBoard (NSString * SBName);
    
@end
