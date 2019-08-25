//
//  PatrolModelXViewController.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/6/5.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolModelXViewController : BaseViewController
@property (nonatomic,weak) UIViewController *lastVC;
-(id) init_Value:(int)init_number width:(CGFloat *)init_width height:(CGFloat *)init_height dataDic:(NSMutableDictionary *)init_dic statusType:(NSString *)init_status;

@end
