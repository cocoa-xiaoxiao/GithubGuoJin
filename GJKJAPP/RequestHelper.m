//
//  RequestHelper.m
//  YiMi
//
//  Created by xiaoxiao xiao on 2017/5/12.
//  Copyright © 2017年 ZhiSou. All rights reserved.
//

#import "RequestHelper.h"

@implementation RequestHelper
+(NSString *)requestApiWith:(MMAPIType)apiType
{
    NSString * apiStr = nil;
    switch (apiType) {
        case GJAPIType_GetMyDefenceTeam:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetMyDefenceTeam";
            break;
        case GJAPIType_GetMyReviewList:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetMyReviewList";
            break;
        case GJAPIType_GetReviewInfo:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetReviewInfo";
            break;
        case GJAPIType_GetReviewConfig:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetReviewConfig";
            break;
        case GJAPIType_ReviewEvaluate:
            apiStr = @"/ApiInternshipInspectionTeamInfo/ReviewEvaluate";
            break;
        case GJAPIType_GetProjectApplyInfoList:
            apiStr = @"/ApiProject/GetProjectApplyInfoList";
            break;
        case GJAPIType_GetMyProjectApplyCheckList:
            apiStr = @"/ApiProject/GetMyProjectApplyCheckList";
            break;
        case GJAPIType_GetMyOverCheckList:
            apiStr = @"/ApiProject/GetMyOverCheckList";
            break;
        case GJAPIType_IsAllowAdd:
            apiStr = @"/ApiProject/IsAllowAdd";
            break;
        case GJAPIType_Create:
            apiStr = @"/ApiProject/Create";
            break;
        case GJAPIType_GetChoiceProjectList:
            apiStr = @"/ApiProject/GetChoiceProjectList";
            break;
        case GJAPIType_GetProjectApplyInfoByID:
            apiStr = @"/ApiProject/GetProjectApplyInfoByID";
            break;
        case GJAPIType_DeleteProjectApplyInfo:
            apiStr = @"/ApiProject/DeleteProjectApplyInfo";
            break;
        case GJAPIType_GetProjectApplyInfoCheckList:
            apiStr = @"/ApiProject/GetProjectApplyInfoCheckList";
            break;
        case GJAPIType_GetProjectApplyInfoNowCheckStep:
            apiStr = @"/ApiProject/GetProjectApplyInfoNowCheckStep";
            break;
        case GJAPIType_ProjectApplyCheck:
            apiStr = @"/ApiProject/ProjectApplyCheck";
            break;
        case GJAPIType_GetMyProjectDoumentList:
            apiStr = @"/ApiProjectDocument/GetMyProjectDoumentList";
            break;
        case GJAPIType_GetMyCheckList:
            apiStr = @"/ApiProjectDocument/GetMyCheckList";
            break;
        case GJAPIType_GetReportOverCheckList:
            apiStr = @"/ApiProjectDocument/GetMyOverCheckList";
            break;
        case GJAPIType_ProjectDocumentsCheck:
            apiStr = @"/ApiProjectDocument/ProjectDocumentsCheck";
            break;
        case GJAPIType_GetProjectDocumentsByID:
            apiStr = @"/ApiProjectDocument/GetProjectDocumentsByID";
            break;
        case GJAPIType_GetProjectDocumentsCheckList:
            apiStr = @"/ApiProjectDocument/GetProjectDocumentsCheckList";
            break;
        case GJAPIType_GetProjectDocumentsNowCheckStep:
            apiStr = @"/ApiProjectDocument/GetProjectDocumentsNowCheckStep";
            break;
        case GJAPIType_GetProjectDocumentsConfig:
            apiStr = @"/ApiProjectDocument/GetProjectDocumentsConfig";
            break;
        case GJAPIType_reportIsAllowAdd:
            apiStr = @"/ApiProjectDocument/IsAllowAdd";
            break;
        case GJAPIType_reportCreate:
            apiStr = @"/ApiProjectDocument/Create";
            break;
        case GJAPIType_reportModify:
            apiStr = @"/ApiProjectDocument/Modify";
            break;
        case GJAPIType_GetProjectFinalizationList:
            apiStr = @"/ApiProjectFinalization/GetProjectFinalizationList";
            break;
        case GJAPIType_GetMyProjectFinalizationCheckList:
            apiStr = @"/ApiProjectFinalization/GetMyProjectFinalizationCheckList";
            break;
        case GJAPIType_GetMyOverProjectFinalizationCheckList:
            apiStr = @"/ApiProjectFinalization/GetMyOverProjectFinalizationCheckList";
            break;
        case GJAPIType_GetProjectFinalizationByID:
            apiStr = @"/ApiProjectFinalization/GetProjectDocumentsByID";
            break;
        case GJAPIType_GetProjectFinalizationNowCheckStep:
            apiStr = @"/ApiProjectFinalization/GetProjectFinalizationNowCheckStep";
            break;
        case GJAPIType_ProjectFinalizationCheck:
            apiStr = @"/ApiProjectFinalization/ProjectFinalizationCheck";
            break;
        case GJAPIType_ProjectFinalizationUploadFile:
            apiStr = @"/ApiProjectFinalization/UploadFile";
            break;
        case GJAPIType_ProjectFinalizationIsAllowAdd:
            apiStr = @"/ApiProjectFinalization/IsAllowAdd";
            break;
        case GJAPIType_ProjectFinalizationCreate:
            apiStr = @"/ApiProjectFinalization/Create";
            break;
        case GJAPIType_ProjectFinalizationCheckRepeat:
            apiStr = @"/ApiProjectFinalization/CheckRepeat";
            break;
        case GJAPIType_ProjectFinalizationCheckRepeatResult:
            apiStr = @"/ApiProjectFinalization/CheckRepeatResult";
            break;
        case GJAPIType_ProjectFinalizationCheckRepeatDownload:
            apiStr = @"/ApiProjectFinalization/CheckRepeatDownload";
            break;
        case GJAPIType_GetMyTaskBookList:
            apiStr = @"/ApiProjectTaskBook/GetMyTaskBookList";
            break;
        case GJAPIType_GetMyStudentTaskBookList:
            apiStr = @"/ApiProjectTaskBook/GetMyStudentTaskBookList";
            break;
        case GJAPIType_GetMyTaskBookCheckList:
            apiStr = @"/ApiProjectTaskBook/GetMyCheckList";
            break;
        case GJAPIType_GetMyTaskBookOverList:
            apiStr = @"/ApiProjectTaskBook/GetMyOverCheckList";
            break;
        case GJAPIType_ProjectTaskBookCheck:
            apiStr = @"/ApiProjectTaskBook/ProjectTaskBookCheck";
            break;
        case GJAPIType_GetProjectTaskBookByID:
            apiStr = @"/ApiProjectTaskBook/GetProjectTaskBookByID";
            break;
        case GJAPIType_GetProjectTaskBookCheckList:
            apiStr = @"/ApiProjectTaskBook/GetProjectTaskBookCheckList";
            break;
        case GJAPIType_GetProjectTaskBookNowCheckStep:
            apiStr = @"/ApiProjectTaskBook/GetProjectTaskBookNowCheckStep";
            break;
        case GJAPIType_GetProjectTaskBookConfig:
            apiStr = @"/ApiProjectTaskBook/GetProjectTaskBookConfig";
            break;
        case GJAPIType_ProjectTaskBookCreate:
            apiStr = @"/ApiProjectTaskBook/Create";
            break;
        case GJAPIType_ProjectTaskBookModify:
            apiStr = @"/ApiProjectTaskBook/Modify";
            break;
        case GJAPIType_GetMyStudentApplyList:
            apiStr = @"/ApiProjectFinalization/GetMyStudentApplyList";
            break;
        case GJAPIType_ProjectFinalScore:
            apiStr = @"/ApiProjectFinalization/Score";
            break;
        case GJAPIType_GetSOSList:
            apiStr = @"/ApiCheckWork/GetSOSList";
            break;
        case GJAPIType_GetSOS:
            apiStr = @"/ApiCheckWork/GetSOSByID";
            break;
        case GJAPIType_GetSOSMap:
            apiStr = @"/ApiCheckWork/GetSosMap";
            break;
        case GJAPIType_GetContactsByAdminID:
            apiStr = @"/ApiCheckWork/GetContactsByAdminID";
            break;
        case GJAPIType_GetSubjectTree:
            apiStr = @"/ApiSystem/GetSubjectTree";
            break;
        case GJAPIType_GetResultsStatisticsList:
            apiStr = @"/ApiProjectFinalization/GetResultsStatisticsList";
            break;
        case GJAPIType_AttendanceStatisticsList:
            apiStr = @"/ApiInternshipApplyEnterpriseInfo/AttendanceStatisticsList";
            break;
        case GJAPIType_StudentDocumentStatisticsList:
            apiStr = @"/ApiInternshipApplyEnterpriseInfo/StudentDocumentStatisticsList";
            break;
        case GJAPIType_UnitStatisticsList:
            apiStr = @"/ApiInternshipApplyEnterpriseInfo/UnitStatisticsList";
            break;
        case GJAPIType_GetStatisticsList:
            apiStr = @"/ApiProjectFinalization/GetStatisticsList";
            break;
        case GJAPIType_GetNoCheckTeamRecordList:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetNoCheckTeamRecordList";
            break;
        case GJAPIType_GetOverCheckTeamRecordList:
            apiStr = @"/ApiInternshipInspectionTeamInfo/GetOverCheckTeamRecordList";
            break;
        case GJAPIType_GetRecordListByDetailID:
            apiStr = @"/ApiActivityTaskInfo/GetRecordListByDetailID";
            break;
        case GJAPIType_GetByID:
            apiStr = @"/ApiActivityTaskInfo/GetByID";
            break;
        default:
            break;
    }
    return apiStr;
}
@end
