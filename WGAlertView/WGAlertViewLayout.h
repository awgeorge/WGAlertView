/**
 *  Copyright (c) 2013 Wunelli LTD.
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
