//
//  BRDetailStationModel.h
//  GJKJAPP
//
//  Created by git burning on 2018/9/9.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "BRBaseModel.h"

@interface BRDetailStationModel : BRBaseModel

//"专业相关程度")
@property (nonatomic,assign) BOOL RelevantType;
/**
 "工作场所：从事高空、井下、放射性、有毒、易燃易爆，以及其他具有较高安全风险的实习")
 */
@property (nonatomic, assign) BOOL IsWorkplace;

/**
"休息休假：存在安排学生在法定节假日实习的情况")
 */
@property (nonatomic, assign) BOOL IsRest;

/**
"加班夜班：存在安排学生加班和上夜班的情况"
 */
@property (nonatomic, assign) BOOL IsOvertime;

/**
"实习计划"
 */
@property (nonatomic, assign) BOOL IsPlan;

/**
"实习教育"
 */
@property (nonatomic, assign) BOOL IsEducation;

/**
"制度保障")
 */
@property (nonatomic, assign) BOOL IsGuarantee;

/**
"预警机制")
 */
@property (nonatomic, assign) BOOL IsWarning;

/**
= "单位员工数：实习生人数超过实习单位在岗职工总数的10%"
 */
@property (nonatomic, assign) BOOL IsENumber;

/**
= "岗位员工数：具体岗位的实习生人数高于该岗位职工总人数的20%")
 */
@property (nonatomic, assign) BOOL IsPNumber;

/**
"外部干预情况：存在学校以外的单位干预实习安排的情况")
 */
@property (nonatomic, assign) BOOL IsExIntervention;

/**
"外部强制情况：存在强制职业学校安排学生到指定单位实习的情况"
 */
@property (nonatomic, assign) BOOL IsExForce;

/**
"在校年级保障：一年级在校学生参加顶岗实习")]
 */
@property (nonatomic, assign) BOOL IsGradeOne;

/**
"学生年龄保障：未满16周岁的学生参加跟岗实习、顶岗实习"
 */
@property (nonatomic, assign) BOOL IsAdult;

/**
= "未成年工保障：未成年学生从事《未成年工特殊保护规定》中禁忌从事的劳动
 */
@property (nonatomic, assign) BOOL IsTaboo;

/**
"女职工保障：女学生从事《女职工劳动保护特别规定》中禁忌从事的劳动"
 */
@property (nonatomic, assign) BOOL IsWomenTaboo;

/**
"娱乐场所限制：到酒吧、夜总会、歌厅、洗浴中心等营业性娱乐场所实习"
 */
@property (nonatomic, assign) BOOL IsBar;

/**
"中介代理限制：通过中介机构或有偿代理组织、安排和管理学生实习工作")
 */
@property (nonatomic, assign) BOOL IsIntermediary;


@end
