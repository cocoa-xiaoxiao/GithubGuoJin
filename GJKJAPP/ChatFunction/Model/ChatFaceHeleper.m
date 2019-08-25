//
//  ChatFaceHeleper.m
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "ChatFaceHeleper.h"
#import "ChatFace.h"
//static ChatFaceHeleper * faceHeleper = nil;

@implementation ChatFaceHeleper

//+(ChatFaceHeleper * )sharedFaceHelper
//{
//    if (!faceHeleper) {
//
//        faceHeleper = [[ChatFaceHeleper alloc]init];
//
//    }
//
//    return  faceHeleper;
//}
+(instancetype)sharedFaceHelper{
    
    static ChatFaceHeleper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChatFaceHeleper alloc] init];
        
//        ChatFaceGroup * aGrounp = [[manager faceGroupArray] objectAtIndex:0];
//        if (aGrounp.facesArray == nil) {
//            /**
//             *   这个groupID 就是该组特有的 ID 例如，系统表情就是 0 自己添加的一组就是 1 等等
//             */
//            aGrounp.facesArray = [[ChatFaceHeleper sharedFaceHelper] getFaceArrayByGroupID:aGrounp.groupID];
//        }

    });
    return manager;
    
}
-(instancetype)init{
    self = [super init];
    if (self) {

        ChatFaceGroup * aGrounp = [[self faceGroupArray] objectAtIndex:0];
        if (aGrounp.facesArray == nil) {
            /**
             *   这个groupID 就是该组特有的 ID 例如，系统表情就是 0 自己添加的一组就是 1 等等
             */
            aGrounp.facesArray = [self getFaceArrayByGroupID:aGrounp.groupID];
        }

    }
    return self;
}
/**
 *   通过这个方法，从  plist 文件中取出来表情
 */
#pragma mark - Public Methods
- (NSArray *) getFaceArrayByGroupID:(NSString *)groupID
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:groupID ofType:@"plist"]];
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        ChatFace *face = [[ChatFace alloc] init];
        face.faceID = [dic objectForKey:@"face_id"];
        face.faceName = [dic objectForKey:@"face_name"];
        face.imageName = [dic objectForKey:@"image"];
        [data addObject:face];
    }
    
    return data;
}

#pragma mark -  ChatFaceGroup Getter
- (NSMutableArray *) faceGroupArray
{
    
    if (_faceGroupArray == nil) {
        _faceGroupArray = [[NSMutableArray alloc] init];
        
        ChatFaceGroup *group = [[ChatFaceGroup alloc] init];
        group.faceType = TLFaceTypeEmoji;
        group.groupID = @"normal_face";
        group.groupImageName = @"EmotionsEmojiHL";
        group.facesArray = nil;
        [_faceGroupArray addObject:group];
    }
    return _faceGroupArray;
}

@end
