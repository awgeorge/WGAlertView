//
//  ASAlertViewLayout.m
//  WGAlertViewTests
//
//  Created by William George on 15/05/2014.
//  Copyright (c) 2014 William George. All rights reserved.
//

#import "ASAlertViewLayout.h"

@implementation ASAlertViewLayout

-(void)layoutButtons:(NSArray *)buttons
{
    [super layoutButtons:buttons];
    
    for(UIButton *button in buttons){
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:button.titleLabel.font.pointSize];
    }
}

@end
