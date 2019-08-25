//
//  DisplayMap.h
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/2/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DisplayMap : NSObject {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
