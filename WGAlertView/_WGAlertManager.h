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

@class WGAlertView;

__attribute__((visibility("hidden")))
@interface _WGAlertManager : NSObject

@property(readwrite, nonatomic, retain) UIView *dimView;

//+ (struct CGAffineTransform { float x1; float x2; float x3; float x4; float x5; float x6; })_alertTranslationForInterfaceOrientation:(int)arg1 andTranslation:(float)arg2;
//+ (void)_applyAlertTransforms;
//+ (void)alertPopoutCompleted;
//+ (void)alertWindowAnimationDidStop:(id)arg1 finished:(id)arg2 context:(void*)arg3;
//+ (void)applyClientWindowTransform:(struct CGAffineTransform { float x1; float x2; float x3; float x4; float x5; float x6; })arg1;
//+ (void)applyInternalWindowTransform:(struct CGAffineTransform { float x1; float x2; float x3; float x4; float x5; float x6; })arg1;
//+ (struct CGAffineTransform { float x1; float x2; float x3; float x4; float x5; float x6; })calculatedAlertTransform;
//+ (void)createAlertWindowIfNeeded:(BOOL)arg1 deferDisplay:(BOOL)arg2;
//+ (void)hideAlertsForTermination;
//+ (void)hideTopmostMiniAlert;
//+ (void)initialize;
//+ (void)noteOrientationChangingTo:(int)arg1 animated:(BOOL)arg2;
//+ (void)noteOrientationChangingTo:(int)arg1;
//+ (void)reorientAlertWindowTo:(int)arg1 animated:(BOOL)arg2 keyboard:(id)arg3;
//+ (void)showTopmostMiniAlertWithSynchronizationPort:(unsigned int)arg1;
//+ (void)sizeAlertWindowForCurrentOrientation;
//+ (void)tellSpringboardHidingAlert:(id)arg1 animated:(BOOL)arg2 forSpringBoardAlertTransition:(BOOL)arg3;
//+ (void)tellSpringboardShowingAlert:(id)arg1 animated:(BOOL)arg2 forSpringBoardAlertTransition:(BOOL)arg3;
//+ (id)visibleAlert;
//
//- (void)_didHideDimmingView:(id)arg1 finished:(id)arg2;

+ (void)addToStack:(WGAlertView *)alertView dontDimBackground:(BOOL)arg2;
+ (BOOL)stackContainsAlert:(WGAlertView *)alertView;
+ (void)removeFromStack:(WGAlertView *)alertView;

+ (BOOL)hideTopMostAlertAnimated:(BOOL)animated;

+ (BOOL)cancelAlertsAnimated:(BOOL)animated;
+ (BOOL)cancelTopMostAlertAnimated:(BOOL)animated;

+ (WGAlertView *)topMostAlert;

+ (void)hideDimmingViewAnimated:(BOOL)animated;
+ (void)showDimmingViewAnimated:(BOOL)animated;
+ (void)createAlertWindowIfNeeded:(BOOL)needed;

+(_WGAlertManager *)shared;

@end
