//
//  RequestHelper.h
//  YiMi
//
//  Created by xiaoxiao xiao on 2017/5/12.
//  Copyright © 2017年 ZhiSou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,MMAPIType)
{
    GJAPIType_GetMyDefenceTeam, //获取我的答辩小组
    GJAPIType_GetMyReviewList, //获取我的答辩意见
    GJAPIType_GetReviewInfo, //获取我的答辩意见详情
    GJAPIType_GetReviewConfig, //获取我的答辩意见配置
    GJAPIType_ReviewEvaluate, //录入答辩意见
    GJAPIType_GetProjectApplyInfoList, //获取我的选题
    GJAPIType_GetMyProjectApplyCheckList, //获取选题待审核列表
    GJAPIType_GetMyOverCheckList, //获取选题已审核列表
    GJAPIType_IsAllowAdd, //检测是否允许选题
    GJAPIType_Create, //学生选题
    GJAPIType_GetChoiceProjectList, //获取选题库
    GJAPIType_GetProjectApplyInfoByID, //查看选题
    GJAPIType_DeleteProjectApplyInfo, //删除选题
    GJAPIType_GetProjectApplyInfoCheckList, //获取选题审核结果列表
    GJAPIType_GetProjectApplyInfoNowCheckStep, //获取当前选题审核环节
    GJAPIType_ProjectApplyCheck, //审核选题
    GJAPIType_GetMyProjectDoumentList, //获取我的开题报告
    GJAPIType_GetMyCheckList, //获取开题报告待审核列表
    GJAPIType_GetReportOverCheckList, //获取开题报告已审核列表
    GJAPIType_ProjectDocumentsCheck, //审核开题报告
    GJAPIType_GetProjectDocumentsByID, //查看开题报告
    GJAPIType_GetProjectDocumentsCheckList, //获取开题报告审核结果列表
    GJAPIType_GetProjectDocumentsNowCheckStep, //获取当前开题报告审核环节
    GJAPIType_GetProjectDocumentsConfig, //获取当前开题报告字段配置
    GJAPIType_reportIsAllowAdd, //检测是否允许新增开题报告
    GJAPIType_reportCreate, //新增开题报告
    GJAPIType_reportModify, //修改开题报告
    GJAPIType_GetProjectFinalizationList, //获取我的定稿列表
    GJAPIType_GetMyProjectFinalizationCheckList, //获取定稿待审核列表
    GJAPIType_GetMyOverProjectFinalizationCheckList, //获取定稿已审核列表
    GJAPIType_GetProjectFinalizationByID, //查看定稿
    GJAPIType_GetProjectFinalizationNowCheckStep, //获取当前定稿审核环节
    GJAPIType_ProjectFinalizationCheck,//审核定稿
    GJAPIType_ProjectFinalizationUploadFile,//上传定稿附件
    GJAPIType_ProjectFinalizationIsAllowAdd,//检测是否允许提交定稿
    GJAPIType_ProjectFinalizationCreate,//提交定稿
    GJAPIType_ProjectFinalizationCheckRepeatResult,//获取定稿查重数据
    GJAPIType_ProjectFinalizationCheckRepeat,//提交定稿查重
    GJAPIType_ProjectFinalizationCheckRepeatDownload,//获取定稿查重报告
    GJAPIType_GetMyTaskBookList,//获取我的任务书
    GJAPIType_GetMyStudentTaskBookList,//获取我的学生任务书列表
    GJAPIType_GetMyTaskBookCheckList,//获取任务书待审核列表
    GJAPIType_GetMyTaskBookOverList,//获取任务书已审核列表
    GJAPIType_ProjectTaskBookCheck,//审核任务书
    GJAPIType_GetProjectTaskBookByID,//查看任务书
    GJAPIType_GetProjectTaskBookCheckList,//获取任务书审核结果列表
    GJAPIType_GetProjectTaskBookNowCheckStep,//获取当前任务书审核环节
    GJAPIType_GetProjectTaskBookConfig,//获取当前任务书字段配置
    GJAPIType_ProjectTaskBookCreate,//新增任务书
    GJAPIType_ProjectTaskBookModify,//修改任务书
    GJAPIType_GetMyStudentApplyList,//获取待评分列表
    GJAPIType_ProjectFinalScore,//定稿评分
    GJAPIType_GetSOSList,//获取sos列表
    GJAPIType_GetSOS,//获取sos信息
    GJAPIType_GetSOSMap,//获取sos地图
    GJAPIType_GetContactsByAdminID,//获取紧急联系人
    GJAPIType_GetSubjectTree,//获取系列表
    GJAPIType_GetResultsStatisticsList,//获取成绩汇总
    GJAPIType_AttendanceStatisticsList,//考勤统计
    GJAPIType_StudentDocumentStatisticsList,//文档统计
    GJAPIType_UnitStatisticsList,//单位统计
    GJAPIType_GetStatisticsList,//中期检查
    GJAPIType_GetNoCheckTeamRecordList,//报告待审核
    GJAPIType_GetOverCheckTeamRecordList,//报告已审核
    GJAPIType_GetRecordListByDetailID,//任务详情记录
    GJAPIType_GetByID,//任务详情
};
@interface RequestHelper : NSObject

/**
 *  @brief 返回api地址
 *
 *  @param apiType api枚举
 *
 *  @return api地址字符串
 */
+ (NSString *)requestApiWith:(MMAPIType)apiType;

@end
