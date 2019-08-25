//
//  ZKAnnotation.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/27.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//遵循协议
@interface ZKAnnotation : NSObject<MKAnnotation>
//经纬度
@property (nonatomic)CLLocationCoordinate2D coordinate;
//父标题
@property (nonatomic,copy)NSString *title;
//子标题
@property (nonatomic,copy)NSString *subtitle;

@end
