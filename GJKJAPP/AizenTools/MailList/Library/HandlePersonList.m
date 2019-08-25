//
//  HandlePersonList.m
//  GJKJAPP
//
//  Created by 谭耀焯 on 2018/3/21.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "HandlePersonList.h"
#import "PersonModel.h"

@implementation HandlePersonList


+(NSMutableArray *)handlelist:(NSArray *)dataArr{
    NSArray *letterArr = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    NSMutableArray *aArr = [[NSMutableArray alloc]init];
    NSMutableArray *bArr = [[NSMutableArray alloc]init];
    NSMutableArray *cArr = [[NSMutableArray alloc]init];
    NSMutableArray *dArr = [[NSMutableArray alloc]init];
    NSMutableArray *eArr = [[NSMutableArray alloc]init];
    NSMutableArray *fArr = [[NSMutableArray alloc]init];
    NSMutableArray *gArr = [[NSMutableArray alloc]init];
    NSMutableArray *hArr = [[NSMutableArray alloc]init];
    NSMutableArray *iArr = [[NSMutableArray alloc]init];
    NSMutableArray *jArr = [[NSMutableArray alloc]init];
    NSMutableArray *kArr = [[NSMutableArray alloc]init];
    NSMutableArray *lArr = [[NSMutableArray alloc]init];
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    NSMutableArray *nArr = [[NSMutableArray alloc]init];
    NSMutableArray *oArr = [[NSMutableArray alloc]init];
    NSMutableArray *pArr = [[NSMutableArray alloc]init];
    NSMutableArray *qArr = [[NSMutableArray alloc]init];
    NSMutableArray *rArr = [[NSMutableArray alloc]init];
    NSMutableArray *sArr = [[NSMutableArray alloc]init];
    NSMutableArray *tArr = [[NSMutableArray alloc]init];
    NSMutableArray *uArr = [[NSMutableArray alloc]init];
    NSMutableArray *vArr = [[NSMutableArray alloc]init];
    NSMutableArray *wArr = [[NSMutableArray alloc]init];
    NSMutableArray *xArr = [[NSMutableArray alloc]init];
    NSMutableArray *yArr = [[NSMutableArray alloc]init];
    NSMutableArray *zArr = [[NSMutableArray alloc]init];
    

    for(int i = 0;i<[dataArr count];i++){
        PersonModel *addressBook = [[PersonModel alloc] init];
        NSString *name = @"";
        if([dataArr[i] objectForKey:@"UserName"] != [NSNull null]){
            name = [dataArr[i] objectForKey:@"UserName"];
        }

        NSString *firstName = [self getFirstName:name];
        NSString *lastName = [self getLastName:name];
        
        NSString *phone = @"";
        if([dataArr[i] objectForKey:@"Mobile"] != [NSNull null]){
            phone = [dataArr[i] objectForKey:@"Mobile"];
        }
        
        NSString *email = @"";
        if([dataArr[i] objectForKey:@"Email"] != [NSNull null]){
            email = [dataArr[i] objectForKey:@"Email"];
        }
        
        NSString *sex = @"";
        if([dataArr[i] objectForKey:@"Sex"] != [NSNull null]){
            sex = [dataArr[i] objectForKey:@"Sex"];
        }
        
        addressBook.firstName = firstName;
        addressBook.lastName = lastName;
        addressBook.name1 = name;
        addressBook.phoneNumber = phone;
        addressBook.phonename = name;
        NSString *temp_header = [dataArr[i] objectForKey:@"FactUrl"];
        if ([temp_header isKindOfClass:[NSNull class]]) {
            temp_header = @"";
        }
        addressBook.headerUrl = [NSString stringWithFormat:@"%@/%@",kCacheHttpRoot,temp_header];
        addressBook.friendId = @"";
        addressBook.sectionNumber = [letterArr indexOfObject:[self getLetter:lastName]];
        addressBook.recordID = i;
        addressBook.rowSelected = NO;
        addressBook.email = email;
        addressBook.tel = phone;
        addressBook.icon = NULL;
        if([[self getLetter:lastName] isEqualToString:@"A"]){
            [aArr addObject:addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"B"]){
            [bArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"C"]){
            [cArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"D"]){
            [dArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"E"]){
            [eArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"F"]){
            [fArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"G"]){
            [gArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"H"]){
            [hArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"I"]){
            [iArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"J"]){
            [jArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"K"]){
            [kArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"L"]){
            [lArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"M"]){
            [mArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"N"]){
            [nArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"O"]){
            [oArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"P"]){
            [pArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"Q"]){
            [qArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"R"]){
            [rArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"S"]){
            [sArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"T"]){
            [tArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"U"]){
            [uArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"V"]){
            [vArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"W"]){
            [wArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"X"]){
            [xArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"Y"]){
            [yArr addObject: addressBook];
        }else if([[self getLetter:lastName] isEqualToString:@"Z"]){
            [zArr addObject: addressBook];
        }
    }
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    if([aArr count] > 0)
        [resultArr addObject:aArr];
    if([bArr count] > 0)
        [resultArr addObject:bArr];
    if([cArr count] > 0)
        [resultArr addObject:cArr];
    if([dArr count] > 0)
        [resultArr addObject:dArr];
    if([eArr count] > 0)
        [resultArr addObject:eArr];
    if([fArr count] > 0)
        [resultArr addObject:fArr];
    if([gArr count] > 0)
        [resultArr addObject:gArr];
    if([hArr count] > 0)
        [resultArr addObject:hArr];
    if([iArr count] > 0)
        [resultArr addObject:iArr];
    if([jArr count] > 0)
        [resultArr addObject:jArr];
    if([kArr count] > 0)
        [resultArr addObject:kArr];
    if([lArr count] > 0)
        [resultArr addObject:lArr];
    if([mArr count] > 0)
        [resultArr addObject:mArr];
    if([nArr count] > 0)
        [resultArr addObject:nArr];
    if([oArr count] > 0)
        [resultArr addObject:oArr];
    if([pArr count] > 0)
        [resultArr addObject:pArr];
    if([qArr count] > 0)
        [resultArr addObject:qArr];
    if([rArr count] > 0)
        [resultArr addObject:rArr];
    if([sArr count] > 0)
        [resultArr addObject:sArr];
    if([tArr count] > 0)
        [resultArr addObject:tArr];
    if([uArr count] > 0)
        [resultArr addObject:uArr];
    if([vArr count] > 0)
        [resultArr addObject:vArr];
    if([wArr count] > 0)
        [resultArr addObject:wArr];
    if([xArr count] > 0)
        [resultArr addObject:xArr];
    if([yArr count] > 0)
        [resultArr addObject:yArr];
    if([zArr count] > 0)
        [resultArr addObject:zArr];
        
    return resultArr;
}


+(NSString *) getLetter:(NSString *) strInput{

    if ([strInput length]) {
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:strInput];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        
        NSArray *pyArray = [ms componentsSeparatedByString:@" "];
        if(pyArray && pyArray.count > 0){
            ms = [[NSMutableString alloc] init];
            for (NSString *strTemp in pyArray) {
                ms = [ms stringByAppendingString:[strTemp substringToIndex:1]];
            }
            
            return [ms uppercaseString];
        }
        
        ms = nil;
    }
    return nil;
}


+(NSString *)getFirstName:(NSString *)name{
    NSString *firstName = @"";
    NSInteger *len = name.length;
    if(len > 2 && len <= 3){
        NSRange range = {1,2};
        firstName = [name substringWithRange:range];
    }else if(len = 2){
        NSRange range = {1,1};
        firstName = [name substringWithRange:range];
    }else if(len > 3){
        NSRange range = {2,2};
        firstName = [name substringWithRange:range];
    }
    return firstName;
}

+(NSString *)getLastName:(NSString *)name{
    NSString *lastName = @"";
    NSInteger *len = name.length;
    if(len > 3){
        NSRange range = {0,2};
        lastName = [name substringWithRange:range];
    }else{
        NSRange range = {0,1};
        lastName = [name substringWithRange:range];
    }
    return lastName;
}


@end

