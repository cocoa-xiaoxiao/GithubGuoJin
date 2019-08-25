//
//  BRStudentPatolListModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/17.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface BRStudentPatolListModel : BRBaseModel
@property (nonatomic, copy) NSString *EnterpriseName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *PositionName;

@property (nonatomic, copy) NSString *StudentID;

@property (nonatomic, copy) NSString *TeacherID;

@property (nonatomic, copy) NSString *TeacherMobile;

@property (nonatomic, copy) NSString *TeacherUserName;

@property (nonatomic, copy) NSString *UserNo;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *FactUrl;


/*
 {
 EnterpriseName = "\U7f8e\U8fea\U79d1\U6444\U5f71\U5668\U6750\U6709\U9650\U516c\U53f8";
 FactUrl = "<null>";
 ID = 370;
 Mobile = 13690236169;
 PositionName = "\U5916\U8d38\U4e1a\U52a1\U5458";
 StudentID = 242;
 TeacherFactUrl = "/Upload/AdminFact/2018/08/12124731668573.jpg";
 TeacherID = 345;
 TeacherMobile = 13602580813;
 TeacherNo = 10509;
 TeacherUserName = "\U6768\U7231\U56fd";
 UserName = "\U6f58\U695a\U94a7";
 UserNo = 15200225;
 }

 */
@end
