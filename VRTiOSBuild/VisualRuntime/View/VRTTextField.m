//
//  VRTTextField.m
//  DC_iOS
//
//  Created by MonsterENT on 10/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTTextField.h"

@interface VRTTextField()<UITextFieldDelegate>
@end

@implementation VRTTextField

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [_vrt_delegate vrtTextFieldShouldReturn:textField.text vrtId:self.originModel.vrtId];
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [_vrt_delegate vrtTextFieldDidChange:[textField.text stringByReplacingCharactersInRange:range withString:string] vrtId:self.originModel.vrtId];
    return true;
}


@end
