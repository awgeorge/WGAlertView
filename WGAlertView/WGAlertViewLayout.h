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

#import <Foundation/Foundation.h>

typedef enum {
    WGAlertViewButtonLayoutDefault,
    WGAlertViewButtonLayoutStacked,
    WGAlertViewButtonLayoutTriStacked
} _WGAlertViewButtonLayout;
typedef signed short WGAlertViewButtonLayout;


@class WGAlertView;
@interface WGAlertViewLayout : NSObject

@property(nonatomic, readwrite, retain) WGAlertView *alertView;
@property(nonatomic, assign) WGAlertViewButtonLayout alertViewButtonLayout;
@property(nonatomic, assign) CGSize alertViewSize;

//Call Redraw Procedure
//###TODO:implement this
//-(void)invalidateLayout;

//Layout Hooks
-(void)prepareLayout;
-(void)layoutDimView:(UIView *)dimView;
-(void)layoutAlertView:(WGAlertView *)alertView;
-(void)layoutTitle:(UILabel *)titleLabel;
-(void)layoutMessage:(UILabel *)messageLabel;
-(void)layoutTextFields:(NSArray *)textFields;
-(void)layoutButtons:(NSArray *)buttons;

//Animation Hooks
-(void)initialLayoutForAppearingView:(WGAlertView *)alertView;
-(void)finalLayoutForDisappearingView:(WGAlertView *)alertView;

@end
