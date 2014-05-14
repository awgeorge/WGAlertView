//
//  WGViewController.m
//  WGAlertViewTests
//
//  Created by William George on 14/05/2014.
//  Copyright (c) 2014 William George. All rights reserved.
//

#import "WGViewController.h"

//WGAlertView
#import "WGAlertView.h"

//Custom Styles
#import "BSAlertViewLayout.h"

@interface WGViewController ()

@end

@implementation WGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row){
        case 0: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"This is apples native alert view" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
        }
        break;
        case 1: {
            WGAlertView *alert = [[WGAlertView alloc] initWithTitle:@"WGAlertView" message:@"This is an imposter" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
        }
        break;
        case 2: {
            WGAlertView *alert = [[WGAlertView alloc] initWithTitle:@"UIAlertView" message:@"This is apples native alert view" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.alertViewLayout = [[BSAlertViewLayout alloc] init];
            [alert show];
        }
        break;
        
    }
}

@end
