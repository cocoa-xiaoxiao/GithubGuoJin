//
//  HttpService+users.m
//  ubiaMainView
//
//  Created by PC_xiaoxiao on 2018/10/30.
//  Copyright © 2018年 youchuan. All rights reserved.
//

#import "HttpService+users.h"
#import "HttpService.h"
#import "RequestHelper.h"
@implementation HttpService (users)

+(NSURLSessionDataTask *)GetMyDefenceTeam:(NSString *)AdminID with:(NSString *)ActivityID with:(NSString *)InspectionTeamName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyDefenceTeam];
    NSDictionary *param = @{@"AdminID":AdminID,
                            @"ActivityID":ActivityID,
                            @"InspectionTeamName":InspectionTeamName?InspectionTeamName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyReviewList:(NSString *)AdminID with:(NSString *)ActivityID with:(NSString *)StudentName with:(NSString *)TeacherName with:(int)SpeedType and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyReviewList];
    NSDictionary *param = @{@"AdminID":AdminID,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"TeacherName":TeacherName?TeacherName:@"",
                            @"SpeedType":@(SpeedType),
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetReviewInfo:(NSString *)reviewID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetReviewInfo];
    NSDictionary *param = @{@"ID":reviewID
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetReviewConfig:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetReviewConfig];
    NSDictionary *param = @{@"ActivityID":ActivityID
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ReviewEvaluate:(NSString *)ActivityID with:(NSString *)AdminID andID:(NSString *)ID Field1:(NSString *)Field1 Score1:(NSString *)Score1 Field2:(NSString *)Field2 Score2:(NSString *)Score2 Field3:(NSString *)Field3 Score3:(NSString *)Score3 Field4:(NSString *)Field4 Score4:(NSString *)Score4 Field5:(NSString *)Field5 Score5:(NSString *)Score5 Field6:(NSString *)Field6 Score6:(NSString *)Score6 Field7:(NSString *)Field7 Score7:(NSString *)Score7 Field8:(NSString *)Field8 Score8:(NSString *)Score8 FinalScore:(NSString *)FinalScore success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ReviewEvaluate];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            @"AdminID":AdminID,
                            @"ID":ID,
                            @"Field1":Field1,
                            @"Score1":Score1,
                            @"Field2":Field2,
                            @"Score2":Score2,
                            @"Field3":Field3,
                            @"Score3":Score3,
                            @"Field4":Field4,
                            @"Score4":Score4,
                            @"Field5":Field5,
                            @"Score5":Score5,
                            @"Field6":Field6,
                            @"Score6":Score6,
                            @"Field7":Field7,
                            @"Score7":Score7,
                            @"Field8":Field8,
                            @"Score8":Score8,
                            @"FinalScore":FinalScore
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectApplyInfoListStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID andProjectSubName:(NSString *)ProjectSubName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectApplyInfoList];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"ProjectSubName":ProjectSubName?ProjectSubName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyProjectApplyCheckList:(NSString *)Updater and:(NSString *)ActivityID and:(NSString *)ProjectSubName and:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyProjectApplyCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"ProjectSubName":ProjectSubName?ProjectSubName:@"",
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyOverCheckList:(NSString *)Updater and:(NSString *)ActivityID and:(NSString *)ProjectSubName and:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyOverCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"ProjectSubName":ProjectSubName?ProjectSubName:@"",
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)IsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_IsAllowAdd];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)createWithStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID andProjectName:(NSString *)ProjectName andProjectSubName:(NSString *)ProjectSubName andIsTeam:(BOOL)IsTeam andTips:(NSString *)Tips andReferenceMaterial:(NSString *)ReferenceMaterial andDescription:(NSString *)Description andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_Create];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"ProjectName":ProjectName,
                            @"ProjectSubName":IsTeam?ProjectSubName:ProjectName,
                            @"IsTeam":IsTeam?@"true":@"false",
                            @"Tips":Tips,
                            @"ReferenceMaterial":ReferenceMaterial,
                            @"Description":Description,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)GetChoiceProjectListWithColleges:(int)Colleges andActivityID:(NSString *)ActivityID andProjectName:(NSString *)ProjectName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetChoiceProjectList];
    NSDictionary *param = @{@"Colleges":@(Colleges),
                            @"ActivityID":ActivityID,
                            @"ProjectName":ProjectName?ProjectName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectApplyInfoByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectApplyInfoByID];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
+(NSURLSessionDataTask *)DeleteProjectApplyInfoID:(NSString *)ID fromAdminID:(NSString *)AdminID withTimeStamp:(NSString *)TimeStamp withToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_DeleteProjectApplyInfo];
    NSDictionary *param = @{@"ID":ID,
                            @"AdminID":AdminID,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)GetProjectApplyInfoCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectApplyInfoCheckList];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectApplyInfoNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectApplyInfoNowCheckStep];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectApplyCheckByID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectApplyCheck];
    NSDictionary *param = @{@"ID":ID,
                            @"AdminID":AdminID,
                            @"FlowDetailID":FlowDetailID,
                            @"CheckState":@(CheckState),
                            @"CheckRemark":CheckRemark,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyProjectDoumentListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyProjectDoumentList];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyCheckListByUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID aboutStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetReportOverCheckListByUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID aboutStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetReportOverCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectDocumentsCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectDocumentsCheck];
    NSDictionary *param = @{@"ID":ID,
                            @"AdminID":AdminID,
                            @"FlowDetailID":FlowDetailID,
                            @"CheckState":@(CheckState),
                            @"CheckRemark":CheckRemark,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectDocumentsByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectDocumentsByID];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectDocumentsCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectDocumentsCheckList];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectDocumentsNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectDocumentsNowCheckStep];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectDocumentsConfigByActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectDocumentsConfig];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ReportIsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_reportIsAllowAdd];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ReportCreateByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID andProjectApplyID:(NSString *)ProjectApplyID andDocumentTitle:(NSString *)DocumentTitle andSubmit:(BOOL)Submit andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token Field1:(NSString *)Field1 Field2:(NSString *)Field2 Field3:(NSString *)Field3 Field4:(NSString *)Field4 Field5:(NSString *)Field5 Field6:(NSString *)Field6 Field7:(NSString *)Field7 Field8:(NSString *)Field8 success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
        NSString *api = [RequestHelper requestApiWith:GJAPIType_reportCreate];
        NSDictionary *param = @{@"ActivityID":ActivityID,
                                @"StudentID":StudentID,
                                @"ProjectApplyID":ProjectApplyID,
                                @"DocumentTitle":DocumentTitle,
                                @"Submit":Submit?@"true":@"false",
                                @"TimeStamp":TimeStamp,
                                @"Token":Token,
                                @"Field1":Field1,
                                @"Field1":Field2,
                                @"Field1":Field3,
                                @"Field1":Field4,
                                @"Field1":Field5,
                                @"Field1":Field6,
                                @"Field1":Field7,
                                @"Field1":Field8,
                                };
        NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
            if (responseObject) {
                success(responseObject);
            }
        } failure:^(NSError *error) {
            failure(error);
        }];
        return task;
}


+(NSURLSessionDataTask *)ReportModifyByStudentID:(NSString *)StudentID fromID:(NSString *)ID andActivityID:(NSString *)ActivityID andProjectApplyID:(NSString *)ProjectApplyID andDocumentTitle:(NSString *)DocumentTitle andSubmit:(BOOL)Submit andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token Field1:(NSString *)Field1 Field2:(NSString *)Field2 Field3:(NSString *)Field3 Field4:(NSString *)Field4 Field5:(NSString *)Field5 Field6:(NSString *)Field6 Field7:(NSString *)Field7 Field8:(NSString *)Field8 success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_reportCreate];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            @"ID":ID,
                            @"StudentID":StudentID,
                            @"ProjectApplyID":ProjectApplyID,
                            @"DocumentTitle":DocumentTitle,
                            @"Submit":Submit?@"true":@"false",
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            @"Field1":Field1,
                            @"Field1":Field2,
                            @"Field1":Field3,
                            @"Field1":Field4,
                            @"Field1":Field5,
                            @"Field1":Field6,
                            @"Field1":Field7,
                            @"Field1":Field8,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectFinalizationListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectFinalizationList];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyProjectFinalizationCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyProjectFinalizationCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyOverProjectFinalizationCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyOverProjectFinalizationCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectFinalizationByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectFinalizationByID];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectFinalizationNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectFinalizationNowCheckStep];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)ProjectFinalizationCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationCheck];
    NSDictionary *param = @{@"ID":ID,
                            @"AdminID":AdminID,
                            @"FlowDetailID":FlowDetailID,
                            @"CheckState":@(CheckState),
                            @"CheckRemark":CheckRemark,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)ProjectFinalizationUploadWithFile:(NSString *)file andAdminID:(NSString *)AdminID andModuleName:(NSString *)ModuleName andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationUploadFile];
    NSDictionary *param = @{@"file":file,
                            @"AdminID":AdminID,
                            @"ModuleName":@"ProjectFinalization",
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectFinalizationIsAllowAdd:(NSString *)StudentID and:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationIsAllowAdd];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
+(NSURLSessionDataTask *)ProjectFinalizationCreateWithStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID andFileUrl:(NSString *)FileUrl andDescription:(NSString *)Description andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationCreate];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"FileUrl":FileUrl,
                            @"Description":Description,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationCheckRepeat];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatResultByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationCheckRepeatResult];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectFinalizationCheckRepeatDownloadByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalizationCheckRepeatDownload];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
+(NSURLSessionDataTask *)GetMyTaskBookListByStudentID:(NSString *)StudentID andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyTaskBookList];
    NSDictionary *param = @{@"StudentID":StudentID,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyStudentTaskBookListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyStudentTaskBookList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyTaskBookCheckListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyTaskBookCheckList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetMyTaskBookOverListFromUpdater:(NSString *)Updater andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyTaskBookOverList];
    NSDictionary *param = @{@"Updater":Updater,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectTaskBookCheckFromID:(NSString *)ID andAdminID:(NSString *)AdminID andFlowDetailID:(NSString *)FlowDetailID andCheckState:(int)CheckState andCheckRemark:(NSString *)CheckRemark andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectTaskBookCheck];
    NSDictionary *param = @{@"ID":ID,
                            @"AdminID":AdminID,
                            @"FlowDetailID":FlowDetailID,
                            @"CheckState":@(CheckState),
                            @"CheckRemark":CheckRemark,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectTaskBookByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectTaskBookByID];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectTaskBookCheckListByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectTaskBookCheckList];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectTaskBookNowCheckStepByID:(NSString *)ID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectTaskBookNowCheckStep];
    NSDictionary *param = @{@"ID":ID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetProjectTaskBookConfigByActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetProjectTaskBookConfig];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

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
                                           success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectTaskBookCreate];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            @"StudentID":StudentID,
                            @"DocumentTitle":DocumentTitle,
                            @"Submit":Submit?@"true":@"false",
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            @"Field1":Field1,
                            @"Field2":Field2,
                            @"Field3":Field3,
                            @"Field4":Field4,
                            @"Field5":Field5,
                            @"Field6":Field6,
                            @"Field7":Field7,
                            @"Field8":Field8,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
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
                                           success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectTaskBookModify];
    NSDictionary *param = @{@"ActivityID":ActivityID,
                            @"ID":ID,
                            @"StudentID":StudentID,
                            @"DocumentTitle":DocumentTitle,
                            @"Submit":Submit?@"true":@"false",
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            @"Field1":Field1,
                            @"Field1":Field2,
                            @"Field1":Field3,
                            @"Field1":Field4,
                            @"Field1":Field5,
                            @"Field1":Field6,
                            @"Field1":Field7,
                            @"Field1":Field8,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
    
}

+(NSURLSessionDataTask *)GetMyStudentApplyListAdminID:(NSString *)AdminID andActivityID:(NSString *)ActivityID andStudentName:(NSString *)StudentName and:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetMyStudentApplyList];
    NSDictionary *param = @{@"AdminID":AdminID,
                            @"ActivityID":ActivityID,
                            @"StudentName":StudentName?StudentName:@"",
                            @"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)ProjectFinalizationScoreFromID:(NSString *)ID andUpdater:(NSString *)Updater andScore:(NSString *)FinalScore andTimeStamp:(NSString *)TimeStamp andToken:(NSString *)Token success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_ProjectFinalScore];
    NSDictionary *param = @{@"ID":ID,
                            @"Updater":Updater,
                            @"FinalScore":FinalScore,
                            @"TimeStamp":TimeStamp,
                            @"Token":Token,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypePOST api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetSOSListDataWithRows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetSOSList];
    NSDictionary *param = @{@"rows":@(rows),
                            @"page":@(page),
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetSosByID:(NSString *)sosId success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetSOS];
    NSDictionary *param = @{@"ID":sosId};
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetSosMapListByID:(NSString *)sosId success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetSOSMap];
    NSDictionary *param = @{@"ID":sosId};
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetContactsByAdminByID:(NSString *)UserID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetContactsByAdminID];
    NSDictionary *param = @{@"StudentID":UserID};
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetSubjectTreeWithAdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetSubjectTree];
    NSDictionary *param = @{@"AdminID":AdminID};
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetResultsStatisticsListWithDepartmentID:(NSString *)DepartmentID andactivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetResultsStatisticsList];
    NSDictionary *param = @{@"DepartmentID":DepartmentID,
                            @"ActivityID":ActivityID
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
+(NSURLSessionDataTask *)GetAttendanceStatisticsListWithDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID StartDate:(NSString *)StartDate EndDate:(NSString *)EndDate success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_AttendanceStatisticsList];
    NSDictionary *param = @{@"DeptID":DeptID,
                            @"ActivityID":ActivityID,
                            @"AdminID":AdminID,
                            @"StartDate":StartDate,
                            @"EndDate":EndDate,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetStudentDocumentStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_StudentDocumentStatisticsList];
    NSDictionary *param = @{@"DeptID":DeptID,
                            @"ActivityID":ActivityID,
                            @"AdminID":AdminID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}


+(NSURLSessionDataTask *)GetUnitStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID AdminID:(NSString *)AdminID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_UnitStatisticsList];
    NSDictionary *param = @{@"DeptID":DeptID,
                            @"ActivityID":ActivityID,
                            @"AdminID":AdminID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetStatisticsListDeptID:(NSString *)DeptID ActivityID:(NSString *)ActivityID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetStatisticsList];
    NSDictionary *param = @{@"DepartmentID":DeptID,
                            @"ActivityID":ActivityID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetNoCheckTeamRecordList:(NSString *)DeptID ActivityID:(NSString *)ActivityID Rows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetNoCheckTeamRecordList];
    NSDictionary *param = @{@"DeptID":DeptID,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)GetOverCheckTeamRecordList:(NSString *)DeptID ActivityID:(NSString *)ActivityID Rows:(int)rows and:(int)page success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetOverCheckTeamRecordList];
    NSDictionary *param = @{@"DeptID":DeptID,
                            @"ActivityID":ActivityID,
                            @"rows":@(rows),
                            @"page":@(page)
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)sxtaskDetail:(NSString *)TaskID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetByID];
    NSDictionary *param = @{@"TaskID":TaskID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}

+(NSURLSessionDataTask *)sxtaskDetailRecord:(NSString *)ActivityTaskDetailID success:(SuccessResponseBlock)success failure:(FailureResponseBlock)failure
{
    NSString *api = [RequestHelper requestApiWith:GJAPIType_GetRecordListByDetailID];
    NSDictionary *param = @{@"ActivityTaskDetailID":ActivityTaskDetailID,
                            };
    NSURLSessionDataTask *task = [HttpService dataTaskWithMethodType:HTTPMethodTypeGET api:api parameters:param success:^(id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    return task;
}
@end
