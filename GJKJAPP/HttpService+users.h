//
//  HttpService+users.h
//  ubiaMainView
//
//  Created by PC_xiaoxiao on 2018/10/30.
//  Copyright © 2018年 youchuan. All rights reserved.
//

#import "HttpService.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HttpService (users)


/**
 获取我的答辩小组
 @param AdminID 当前用户ID
 @param ActivityID 当前批次ID
 @param InspectionTeamName 小组名（可选填)
 @param rows 每页显示条数
 @param page 当前页码

 */
+(NSURLSessionDataTask *)GetMyDefenceTeam:(NSString *)AdminID with:(NSString *)ActivityID with:(NSString *)InspectionTeamName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 获取我的答辩意见
 @param AdminID 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生名（可选填)
 @param TeacherName 导师名（可选填)
 @param SpeedType 是否完成
 @param rows 每页显示条数
 @param page 当前页码
 
 */
+(NSURLSessionDataTask *)GetMyReviewList:(NSString *)AdminID with:(NSString *)ActivityID with:(NSString *)StudentName with:(NSString *)TeacherName with:(int)SpeedType and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 获取我的答辩意见详情
 @param reviewID 答辩意见ID
  */
+(NSURLSessionDataTask *)GetReviewInfo:(NSString *)reviewID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 获取我的答辩意见配置
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)GetReviewConfig:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 录入答辩意见
 @param ActivityID 当前批次ID
 @param AdminID 当前用户ID
 @param ID 答辩意见ID
 @param Field1 评价意见
 @param Score1 评价分数
 */
+(NSURLSessionDataTask *)ReviewEvaluate:(NSString *)ActivityID  with:(NSString *)AdminID andID:(NSString *)ID
                                       Field1:(NSString *)Field1 Score1:(NSString *)Score1
                                       Field2:(NSString *)Field2 Score2:(NSString *)Score2
                                       Field3:(NSString *)Field3 Score3:(NSString *)Score3
                                       Field4:(NSString *)Field4 Score4:(NSString *)Score4
                                       Field5:(NSString *)Field5 Score5:(NSString *)Score5
                                       Field6:(NSString *)Field6 Score6:(NSString *)Score6
                                       Field7:(NSString *)Field7 Score7:(NSString *)Score7
                                       Field8:(NSString *)Field8 Score8:(NSString *)Score8
                                       FinalScore:(NSString *)FinalScore
                                success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.7 获取我的选题[2018年12月06日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param ProjectSubName 选题关键字（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetProjectApplyInfoListStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID andProjectSubName:(NSString *)ProjectSubName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;
/**
 10.8 获取选题待审核列表 [2018年12月06日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param ProjectSubName 选题关键字（可选填）
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyProjectApplyCheckList:(NSString *)Updater and:(NSString *)ActivityID and:(NSString *)ProjectSubName and:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.9 获取选题已审核列表 [2018年12月06日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param ProjectSubName 选题关键字（可选填）
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyOverCheckList:(NSString *)Updater and:(NSString *)ActivityID and:(NSString *)ProjectSubName and:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.10 检测是否允许选题 [2018年12月08日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)IsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.11 学生选题 [2018年12月08日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param ProjectName 论文主标题
 @param ProjectSubName 论文副标题[当选择团队时才允许输入]
 @param IsTeam 是否团队[如是，则主副标题都要填]
 @param Tips 申报提示
 @param ReferenceMaterial 参考资料
 @param Description 项目说明
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)createWithStudentID:(NSString *)StudentID
                                   andActivityID:(NSString *)ActivityID
                                  andProjectName:(NSString *)ProjectName
                                 andProjectSubName:(NSString *)ProjectSubName
                                       andIsTeam:(BOOL)IsTeam
                                 andTips:(NSString *)Tips
                            andReferenceMaterial:(NSString *)ReferenceMaterial
                                 andDescription:(NSString *)Description
                                    andTimeStamp:(NSString *)TimeStamp
                                 andToken:(NSString *)Token
                                success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.12 获取选题库[2018年12月08日]
 @param Colleges 当前用户所在学院ID
 @param ActivityID 当前批次ID
 @param ProjectName 选题关键字（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetChoiceProjectListWithColleges:(int)Colleges andActivityID:(NSString *)ActivityID andProjectName:(NSString *)ProjectName  and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.13 查看选题[2018年12月08日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectApplyInfoByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.14 删除选题[2018年12月08日]
 @param ID 选题ID
 @param AdminID 当前用户ID
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)DeleteProjectApplyInfoID:(NSString *)ID fromAdminID:(NSString *)AdminID withTimeStamp:(NSString *)TimeStamp withToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.15 获取选题审核结果列表[2018年12月08日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectApplyInfoCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.16 获取当前选题审核环节[2018年12月08日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectApplyInfoNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.17 审核选题[2018年12月08日]
 @param ID 选题ID
 @param AdminID 当前用户ID
 @param FlowDetailID 当前审核步骤ID
 @param CheckState 审核状态
 @param CheckRemark 审核备注
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectApplyCheckByID:(NSString *)ID
                               andAdminID:(NSString *)AdminID
                              andFlowDetailID:(NSString *)FlowDetailID
                           andCheckState:(int)CheckState
                                   andCheckRemark:(NSString *)CheckRemark
                                     andTimeStamp:(NSString *)TimeStamp
                                    andToken:(NSString *)Token
                                     success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.18 获取我的开题报告 [2018年12月10日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyProjectDoumentListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.19 获取开题报告待审核列表 [2018年12月11日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyCheckListByUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID aboutStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.20 获取开题报告已审核列表 [2018年12月11日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetReportOverCheckListByUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID aboutStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.21 审核开题报告[2018年12月11日]
 @param ID 选题ID
 @param AdminID 当前用户ID
 @param FlowDetailID 当前审核步骤ID
 @param CheckState 审核状态
 @param CheckRemark 审核备注
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectDocumentsCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID  andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.22 查看开题报告[2018年12月11日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectDocumentsByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.23 获取开题报告审核结果列表[2018年12月11日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectDocumentsCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.24 获取当前开题报告审核环节[2018年12月11日]
 @param ID 选题ID
 */
+(NSURLSessionDataTask *)GetProjectDocumentsNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.25 获取当前开题报告字段配置[2018年12月11日]
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)GetProjectDocumentsConfigByActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.26 检测是否允许新增开题报告 [2018年12月11日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)ReportIsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.27 新增开题报告 [2018年12月11日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param ProjectApplyID 学生有效选题ID
 @param DocumentTitle 报告主标题
 @param Submit 是否提交[是则提交，否则存草稿]
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ReportCreateByStudentID:(NSString *)StudentID
                                   andActivityID:(NSString *)ActivityID
                               andProjectApplyID:(NSString *)ProjectApplyID
                                andDocumentTitle:(NSString *)DocumentTitle
                                       andSubmit:(BOOL)Submit
                                    andTimeStamp:(NSString *)TimeStamp
                                        andToken:(NSString *)Token
                                 Field1:(NSString *)Field1
                                 Field2:(NSString *)Field2
                                 Field3:(NSString *)Field3
                                 Field4:(NSString *)Field4
                                 Field5:(NSString *)Field5
                                 Field6:(NSString *)Field6
                                 Field7:(NSString *)Field7
                                 Field8:(NSString *)Field8
                                success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.28 修改开题报告 [2018年12月11日]
 @param StudentID 当前用户ID
 @param ID 当前开题报告ID
 @param ActivityID 当前批次ID
 @param ProjectApplyID 学生有效选题ID
 @param DocumentTitle 报告主标题
 @param Submit 是否提交[是则提交，否则存草稿]
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ReportModifyByStudentID:(NSString *)StudentID
                                          fromID:(NSString *)ID
                                   andActivityID:(NSString *)ActivityID
                               andProjectApplyID:(NSString *)ProjectApplyID
                                andDocumentTitle:(NSString *)DocumentTitle
                                       andSubmit:(BOOL)Submit
                                    andTimeStamp:(NSString *)TimeStamp
                                        andToken:(NSString *)Token
                                          Field1:(NSString *)Field1
                                          Field2:(NSString *)Field2
                                          Field3:(NSString *)Field3
                                          Field4:(NSString *)Field4
                                          Field5:(NSString *)Field5
                                          Field6:(NSString *)Field6
                                          Field7:(NSString *)Field7
                                          Field8:(NSString *)Field8
                                         success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;



/**
 10.29 获取我的定稿列表 [2018年12月18日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetProjectFinalizationListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.30 获取定稿待审核列表 [2018年12月18日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyProjectFinalizationCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.31 获取定稿已审核列表 [2018年12月18日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyOverProjectFinalizationCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.32 查看定稿[2018年12月18日]
 @param ID 定稿ID
 */
+(NSURLSessionDataTask *)GetProjectFinalizationByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.33 获取当前定稿审核环节[2018年12月18日]
 @param ID 定稿ID
 */
+(NSURLSessionDataTask *)GetProjectFinalizationNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.34 审核定稿[2018年12月18日]
 @param ID 选题ID
 @param AdminID 当前用户ID
 @param FlowDetailID 当前审核步骤ID
 @param CheckState 审核状态
 @param CheckRemark 审核备注
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectFinalizationCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID  andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.35 上传定稿附件[2018年12月19日]
 @param AdminID 当前用户ID
 @param file 文件
 @param ModuleName 模块名：固定使用” ProjectFinalization”
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectFinalizationUploadWithFile:(NSString *)file andAdminID:(NSString *)AdminID andModuleName:(NSString *)ModuleName andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.36 检测是否允许提交定稿[2018年12月19日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)ProjectFinalizationIsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.37 提交定稿[2018年12月19日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param FileUrl 文件路径
 @param Description 备注
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectFinalizationCreateWithStudentID:(NSString *)StudentID
                               andActivityID:(NSString *)ActivityID
                                  andFileUrl:(NSString *)FileUrl
                              andDescription:(NSString *)Description
                                andTimeStamp:(NSString *)TimeStamp
                                    andToken:(NSString *)Token
                                     success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.38 提交定稿查重[2018年12月21日]
 @param ID 定稿ID
 */
+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.39 获取定稿查重数据[2018年12月21日]
 @param ID 定稿ID
 */
+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatResultByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.40 获取定稿查重报告[2018年12月21日]
 @param ID 定稿ID
 */
+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatDownloadByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.41 获取我的任务书 [2018年12月22日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyTaskBookListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.42 获取我的学生任务书列表 [2018年12月22日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyStudentTaskBookListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID  and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.43 获取任务书待审核列表 [2018年12月22日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyTaskBookCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.44 获取任务书已审核列表 [2018年12月22日]
 @param Updater 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyTaskBookOverListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.45 审核任务书[2018年12月23日]
 @param ID 选题ID
 @param AdminID 当前用户ID
 @param FlowDetailID 当前审核步骤ID
 @param CheckState 审核状态
 @param CheckRemark 审核备注
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectTaskBookCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID  andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.46 查看任务书[2018年12月23日]
 @param ID 任务书ID
 */
+(NSURLSessionDataTask *)GetProjectTaskBookByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.47 获取任务书审核结果列表[2018年12月23日]
 @param ID 任务书ID
 */
+(NSURLSessionDataTask *)GetProjectTaskBookCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.48 获取当前任务书审核环节[2018年12月23日]
 @param ID 任务书ID
 */
+(NSURLSessionDataTask *)GetProjectTaskBookNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.49 获取当前任务书字段配置[2018年12月23日]
 @param ActivityID 当前批次ID
 */
+(NSURLSessionDataTask *)GetProjectTaskBookConfigByActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;



/**
 10.50 新增任务书 [2018年12月23日]
 @param StudentID 当前用户ID
 @param ActivityID 当前批次ID
 @param DocumentTitle 报告主标题
 @param Submit 是否提交[是则提交，否则存草稿]
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)TaskBookCreateByStudentID:(NSString *)StudentID
                                   andActivityID:(NSString *)ActivityID
                                andDocumentTitle:(NSString *)DocumentTitle
                                       andSubmit:(BOOL)Submit
                                    andTimeStamp:(NSString *)TimeStamp
                                        andToken:(NSString *)Token
                                          Field1:(NSString *)Field1
                                          Field2:(NSString *)Field2
                                          Field3:(NSString *)Field3
                                          Field4:(NSString *)Field4
                                          Field5:(NSString *)Field5
                                          Field6:(NSString *)Field6
                                          Field7:(NSString *)Field7
                                          Field8:(NSString *)Field8
                                         success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.51 修改任务书 [2018年12月23日]
 @param StudentID 当前用户ID
 @param ID 当前开题报告ID
 @param ActivityID 当前批次ID
 @param DocumentTitle 报告主标题
 @param Submit 是否提交[是则提交，否则存草稿]
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)TaskBookModifyByStudentID:(NSString *)StudentID
                                          fromID:(NSString *)ID
                                   andActivityID:(NSString *)ActivityID
                                andDocumentTitle:(NSString *)DocumentTitle
                                       andSubmit:(BOOL)Submit
                                    andTimeStamp:(NSString *)TimeStamp
                                        andToken:(NSString *)Token
                                          Field1:(NSString *)Field1
                                          Field2:(NSString *)Field2
                                          Field3:(NSString *)Field3
                                          Field4:(NSString *)Field4
                                          Field5:(NSString *)Field5
                                          Field6:(NSString *)Field6
                                          Field7:(NSString *)Field7
                                          Field8:(NSString *)Field8
                                         success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.52 获取待评分列表 [2019年1月1日]
 @param AdminID 当前用户ID
 @param ActivityID 当前批次ID
 @param StudentName 学生姓名/学号（可选填）
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetMyStudentApplyListAdminID:(NSString *)AdminID andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.53 定稿评分[2019年1月1日]
 @param ID 定稿ID
 @param Updater 当前用户ID
 @param FinalScore 分数
 @param TimeStamp 时间戳
 @param Token 握手密钥
 */
+(NSURLSessionDataTask *)ProjectFinalizationScoreFromID:(NSString *)ID andUpdater:(NSString *)Updater andScore:(NSString *)FinalScore andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 10.54 获取SOS列表
 @param rows 每页显示条数
 @param page 当前页码
 */
+(NSURLSessionDataTask *)GetSOSListDataWithRows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.55 获取SOS地址
 */
+(NSURLSessionDataTask *)GetSosMapListByID:(NSString *)sosId success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 10.56 获取SOS信息
 */
+(NSURLSessionDataTask *)GetSosByID:(NSString *)sosId success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;
/**
 10.57 获取紧急联系人
 @param UserID 用户id
 */
+(NSURLSessionDataTask *)GetContactsByAdminByID:(NSString *)UserID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;
/**
 10.58 获取级别
 @param AdminID 用户id
 */
+(NSURLSessionDataTask *)GetSubjectTreeWithAdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;
/**
 10.58 获取成绩
 @param DepartmentID 系别
 @param ActivityID 活动id
 */
+(NSURLSessionDataTask *)GetResultsStatisticsListWithDepartmentID:(NSString *)DepartmentID andactivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 考勤统计
 @param DeptID 部门ID
 @param ActivityID 批次ID
 @param AdminID 当前用户ID
 @param StartDate 开始时间（必填）
 @param EndDate 结束时间（必填）
 @param success 成功返回
 @param failure 失败返回
 */
+(NSURLSessionDataTask *)GetAttendanceStatisticsListWithDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID StartDate:(NSString *)StartDate EndDate:(NSString *)EndDate success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 文档统计
 @param DeptID 部门ID
 @param ActivityID 批次ID
 @param AdminID 当前用户ID
 */
+(NSURLSessionDataTask *)GetStudentDocumentStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 单位
 @param DeptID 部门ID
 @param ActivityID 批次ID
 @param AdminID 当前用户ID
 */
+(NSURLSessionDataTask *)GetUnitStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;


/**
 中期检查
 @param DeptID 部门ID
 @param ActivityID 批次ID
 */
+(NSURLSessionDataTask *)GetStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

//http://120.78.148.58/ApiInternshipInspectionTeamInfo/GetNoCheckTeamRecordList?DeptID=13&ActivityID=1&rows=10000&page=1

/**
 报告待审核

 @param DeptID 部门ID
 @param ActivityID 批次ID
 @param rows 数量
 @param page 页数
 */
+(NSURLSessionDataTask *)GetNoCheckTeamRecordList:(NSString *)DeptID ActivityID:(NSString *)ActivityID Rows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

/**
 报告已审核
 
 @param DeptID 部门ID
 @param ActivityID 批次ID
 @param rows 数量
 @param page 页数
 */
+(NSURLSessionDataTask *)GetOverCheckTeamRecordList:(NSString *)DeptID ActivityID:(NSString *)ActivityID Rows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure;

@end

NS_ASSUME_NONNULL_END
