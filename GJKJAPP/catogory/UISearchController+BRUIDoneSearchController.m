//
//  UISearchController+BRUIDoneSearchController.m
//  GJKJAPP
//
//  Created by git burning on 2018/9/8.
//  Copyright © 2018年 谭耀焯. All rights reserved.
//

#import "UISearchController+BRUIDoneSearchController.h"

@implementation UISearchController (BRUIDoneSearchController)
-(void)br_removeLogoKeyboard {
    if ([self.searchBar respondsToSelector:@selector(searchField)]) {
        UITextField *textField = [self.searchBar valueForKey:@"_searchField"];
        textField.leftViewMode = UITextFieldViewModeNever;
        textField.returnKeyType =  UIReturnKeyDone;
    }
  
}
@end
