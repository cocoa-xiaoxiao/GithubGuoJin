//
//  GJPublicCellModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/10/13.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface GJPublicCellModel : BRBaseModel
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic,assign) CGFloat sectionFooderHeight;
@property (nonatomic,assign) NSInteger sectionID;
@property (nonatomic,assign) NSInteger cellID;
@property (nonatomic, strong) NSMutableArray *rowArrays;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *mobile;
@end
