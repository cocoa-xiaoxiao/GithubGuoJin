//
//  GJShenheViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/1/2.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, shenheType) {
    shenheType_xuanti,
    shenheType_kaitibaogao,
    shenheType_report,
    shenheType_reportcexiao,
};
@interface GJShenheViewController : UIViewController
@property (nonatomic, copy) NSString * pid;
@property (nonatomic, assign) shenheType shenheType;
- (IBAction)shenhe:(id)sender;

@end

NS_ASSUME_NONNULL_END
