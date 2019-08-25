//
//  WorkBaseModel.h
//  GJKJAPP
//
//  Created by PC_xiaoxiao on 2018/12/10.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkBaseModel : NSObject

@end


@interface myProjModel : NSObject   //我的选题模型

@property (nonatomic, copy) NSString *pname;        //选题名称
@property (nonatomic, copy) NSString *ptime;      //提交时间
@property (nonatomic, assign) int pteacher; //0审核  1通过 2未通过
@property (nonatomic, copy) NSString *pscore; //审阅得分
@property (nonatomic, copy) NSString *pID; //选题id
@end


@interface qBankModel : NSObject   //题库列表模型
@property (nonatomic, copy) NSString *bname;      //选题名称
@property (nonatomic, copy) NSString *btishi;   //申报提示
@property (nonatomic, copy) NSString *bziliao;    //参考资料
@property (nonatomic, copy) NSString *bshuoming;  //其他说明
@property (nonatomic, copy) NSString *bID;  //题库id

@end

@interface myFinalizationModel : NSObject //我的定稿

@property (nonatomic, copy) NSString *fname; //定稿标题
@property (nonatomic, copy) NSString *fcheck;   //导师审阅
@property (nonatomic, copy) NSString *ftime;    //日期
@property (nonatomic, copy) NSString *fstate;  //查重状态
@property (nonatomic, copy) NSString *fscore; //审阅评分
@property (nonatomic, assign) int  is_chachong; //是否已查重  0未查重 1查重中 2已查重
@property (nonatomic, copy) NSString *fID; 
@end


@interface myDefenseArrangeModel : NSObject //答辩安排

@property (nonatomic, copy) NSString *dname; //论文选题
@property (nonatomic, copy) NSString *dauthor; //论文作者
@property (nonatomic, copy) NSString *dtutor; //论文指导老师
@property (nonatomic, copy) NSString *dqualification; //答辩资格
@property (nonatomic, copy) NSString *dteam; //答辩小组
@property (nonatomic, copy) NSString *dtime; //答辩时间
@property (nonatomic, copy) NSString *dplace; //答辩地点

@end

@interface CheckProListModel : NSObject //老师选题审核
@property (nonatomic, copy) NSString *pname;      //选题名称
@property (nonatomic, copy) NSString *psource;   //来源
@property (nonatomic, copy) NSString *ptime;    //日期
@property (nonatomic, copy) NSString *pstate;  //状态
@property (nonatomic, copy) NSString *pteam;  //团队
@property (nonatomic, copy) NSString *pID;  //选题id
@end


@interface taskBookListModel : NSObject //老师下达任务书

@property (nonatomic, copy) NSString *bname;      //选题标题
@property (nonatomic, copy) NSString *subtitle;      //副标题
@property (nonatomic, copy) NSString *bsource;   //来源
@property (nonatomic, copy) NSString *btime;    //日期
@property (nonatomic, copy) NSString *bstate;  //状态
@property (nonatomic, copy) NSString *bteam;  //团队
@property (nonatomic, copy) NSString *bID;  //选题id
@end

@interface checkProposalListModel : NSObject //老师开题报告审核

@property (nonatomic, copy) NSString *pname;      //选题名称
@property (nonatomic, copy) NSString *psource;   //来源
@property (nonatomic, copy) NSString *ptime;    //日期
@property (nonatomic, copy) NSString *pstate;  //状态
@property (nonatomic, copy) NSString *pteam;  //团队
@property (nonatomic, copy) NSString *pID;  //开题id

@end

@interface FinalizationListModel : NSObject //老师审核定稿
@property (nonatomic, copy) NSString *fname;      //选题名称
@property (nonatomic, copy) NSString *fsource;   //来源
@property (nonatomic, copy) NSString *ftime;    //日期
@property (nonatomic, copy) NSString *fstate;  //查重
@property (nonatomic, copy) NSString *fcheck;  //导师审查
@property (nonatomic, copy) NSString *fscore;  //成绩
@property (nonatomic, copy) NSString *fteam;  //是否是团队
@property (nonatomic, copy) NSString *fID;  //定稿id
@property (nonatomic, copy) NSString *wordUrl; //word文档地址
@end

@interface MyReviewListModel : NSObject //老师录入答辩意见
@property (nonatomic, copy) NSString *rname;      //选题名称
@property (nonatomic, copy) NSString *rsource;   //来源
@property (nonatomic, copy) NSString *rtime;    //日期
@property (nonatomic, copy) NSString *rstate;  //查重
@property (nonatomic, copy) NSString *rteacher;  //导师
@property (nonatomic, copy) NSString *rscore;  //成绩
@property (nonatomic, copy) NSString *rplcae;  //地址
@property (nonatomic, copy) NSString *rID;  //答辩意见id
@end

@interface ProReviewModel : NSObject //评阅任务

@property (nonatomic, copy)NSString *project;//标题
@property (nonatomic, copy)NSString *time;//时间
@property (nonatomic, copy)NSString *student;//学生
@property (nonatomic, copy)NSString *chachong;//相似度
@property (nonatomic, copy)NSString *score;//成绩
@property (nonatomic, copy)NSString *proID;//id

@end

@interface SOSListModel : NSObject

@property (nonatomic, copy) NSString *sosName;
@property (nonatomic, copy) NSString *sosPlace;
@property (nonatomic, copy) NSString *time; 
@property (nonatomic, copy) NSString *warnReason;
@property (nonatomic, assign) BOOL ishandle; //是否处理
@property (nonatomic, copy) NSString *sosID;
@end


@interface SOSInfoModel : NSObject

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy) NSString *sosTime;
@property (nonatomic, copy) NSString *sosPlace;
@property (nonatomic, copy) NSString *title; //预警信息
@property (nonatomic, copy) NSString *sosContent; //预警处理
@end

@interface SOSSendModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@end

@interface SubjectTreeModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *departmentID;

@end

@interface resultScoreModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat yxl;//优秀率
@property (nonatomic, assign) CGFloat lhl;//良好率
@property (nonatomic, assign) CGFloat zdl;//中等率
@property (nonatomic, assign) CGFloat hgl;//合格率
@property (nonatomic, assign) CGFloat bhgl;//不合格率
@property (nonatomic, assign) int sxrs; //学生总数
@property (nonatomic, assign) int sccj; //生成成绩
@property (nonatomic, assign) int wcc; //无成绩
@property (nonatomic, assign) CGFloat ccscl;//成绩生成率
@end

@interface kaoqinTableModel:NSObject;
@property (nonatomic, copy) NSString *qiandao; //签到
@property (nonatomic, copy) NSString *qiantui; //签退
@property (nonatomic, copy) NSString *sureqiandao; //确认签到
@property (nonatomic, copy) NSString *sureqiantui; //确认签退
@property (nonatomic, copy) NSString *name; //部门
@end


@interface DocumentModel:NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString * renshu; //实习人数
@property (nonatomic, copy) NSString * xy_total; //应有协议
@property (nonatomic, copy) NSString * xy_yj; //已交协议
@property (nonatomic, copy) NSString * rw_total; //任务总数
@property (nonatomic, copy) NSString * rw_yj; //已交任务
@property (nonatomic, copy) NSString * rw_yzd; //已指导任务
@property (nonatomic, copy) NSString * rw_sj; //审结任务
@property (nonatomic, copy) NSString * zj_total; //应交周记
@property (nonatomic, copy) NSString * zj_yj; //已交周记
@property (nonatomic, copy) NSString * zj_yp; //已批周记

@end

@interface UnitModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int renshu; //实习人数
@property (nonatomic, assign) int unit_zg; //在岗人数
@property (nonatomic, assign) int unit_dg; //待岗人数
@property (nonatomic, assign) int unit_jd; //基地实习
@property (nonatomic, assign) CGFloat unit_sxl; //在岗实习率
@property (nonatomic, assign) CGFloat unit_jdsxl; //基地实习率
@property (nonatomic, assign) CGFloat unit_dgl; //待岗率

@end

@interface myteacherModel : NSObject

@end

/*
AppendData": {
"total": 38,
"rows": [{
    "ID": 83,
    "EnterpriseID": 15,
    "EnterpriseName": "广东顺德展畅商贸有限公司",
    "SubsidyTitle": "E片区",
    "RecordTitle": "吴国华2019-04-02广东顺德展畅商贸有限公司巡查报告",
    "CreateDate": "\/Date(1554193492357)\/",
    "CheckState": 3,
    "UserName": "吴国华",
    "RecordPlace": "中国广东省佛山市顺德区碧水路"
}, {
    */
@interface checkReportModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *RecordPlace;
@property (nonatomic, copy) NSString *RecordTitle;
@property (nonatomic, copy) NSString *SubsidyTitle;
@property (nonatomic, copy) NSString *EnterpriseName;
@property (nonatomic, assign) int CheckState;
@property (nonatomic, assign) int select;

@end
NS_ASSUME_NONNULL_END
