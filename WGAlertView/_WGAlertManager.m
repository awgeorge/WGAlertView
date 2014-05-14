/**
 *  Copyright (c) 2013 William George.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 *  @author William George
 *  @package WGFramework
 *  @category AlertView
 *  @date 01/11/2013
 */

#import "_WGAlertManager.h"

//WGFramework
#import "WGAlertView.h"

@interface _WGAlertManager ()

@property(readwrite, nonatomic, retain) UIWindow *alertWindow;
@property(readwrite, nonatomic, retain) NSMutableArray *alertViews;

@end

@implementation _WGAlertManager

#pragma mark - Public Methods

+(void)addToStack:(WGAlertView *)alertView dontDimBackground:(BOOL)arg2
{
    if(![self stackContainsAlert:alertView]){
        //Do we have any more alerts?
        if([[_WGAlertManager shared].alertViews count] > 0){
             [self hideTopMostAlertAnimated:YES];
        } else {
            [self showDimmingViewAnimated:YES];
        }
       
        [[_WGAlertManager shared].alertViews addObject:alertView];
        [[_WGAlertManager shared].alertWindow addSubview:alertView];
    }
}

+(void)removeFromStack:(WGAlertView *)alertView
{
    if([self stackContainsAlert:alertView]){
        [[_WGAlertManager shared].alertViews removeObject:alertView];
        
        //Do we have any more alerts?
        if([[_WGAlertManager shared].alertViews count] > 0){
            [[self topMostAlert] show];
        } else {
            [self hideDimmingViewAnimated:YES];
        }
    }
}

+(BOOL)stackContainsAlert:(WGAlertView *)alertView
{
    return [[_WGAlertManager shared].alertViews containsObject:alertView];
}

+(WGAlertView *)topMostAlert
{
    return [[_WGAlertManager shared].alertViews lastObject];
}

+(BOOL)cancelAlertsAnimated:(BOOL)animated
{
    for(WGAlertView *alertView in [[_WGAlertManager shared].alertViews copy]){
        [alertView dismissWithClickedButtonIndex:-1 animated:animated];
    }
    
    return YES;
}

+(BOOL)cancelTopMostAlertAnimated:(BOOL)animated
{
    WGAlertView *alertView = [self topMostAlert];
    
    if(alertView){
        [alertView dismissWithClickedButtonIndex:-1 animated:animated];
        return YES;
    }
    
    return NO;
}

+(BOOL)hideTopMostAlertAnimated:(BOOL)animated
{
    WGAlertView *alertView = [self topMostAlert];
    
    if(alertView){
        [alertView dismissAnimated:animated];
        return YES;
    }
    
    return NO;
}

+(void)showDimmingViewAnimated:(BOOL)animated
{
    [self createAlertWindowIfNeeded:animated];
    
    [UIView animateWithDuration:(animated)?0.2:0 animations: ^{
        [_WGAlertManager shared].dimView.alpha = 1.0f;
    }];
}

+(void)hideDimmingViewAnimated:(BOOL)animated
{
    [UIView animateWithDuration:(animated)?0.3:0 animations: ^{
        [_WGAlertManager shared].dimView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_WGAlertManager shared].alertWindow = nil;
    }];
}

+ (void)createAlertWindowIfNeeded:(BOOL)needed
{
    UIWindow *alertWindow = [_WGAlertManager shared].alertWindow;
    
    if(!alertWindow){
        alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.windowLevel = UIWindowLevelAlert;
        alertWindow.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        alertWindow.tintColor = [UIApplication sharedApplication].keyWindow.tintColor;
#endif
        [alertWindow addSubview:[_WGAlertManager shared].dimView];
        
        [_WGAlertManager shared].alertWindow = alertWindow;
        [[_WGAlertManager shared].alertWindow makeKeyAndVisible];
    }
}

#pragma mark - Internal Methods

/**
 *  Get Instance
 *  @return (Constants) - Instance of self
 */
+(_WGAlertManager *)shared
{
    static _WGAlertManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(id)init
{
    if(self = [super init]){
        _alertViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - Getters

-(UIView *)dimView
{
    if(!_dimView){
        _dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _dimView.alpha = 0.0f;
    }
    
    return _dimView;
}

@end
