//
//  ReportDetailViewController.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2019/4/4.
//  Copyright © 2019 谭耀焯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ReportDetailViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, assign) int shenhe;

@end

NS_ASSUME_NONNULL_END
