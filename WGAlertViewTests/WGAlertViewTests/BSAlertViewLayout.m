//
//  BSAlertViewLayout.m
//  BetSocial
//
//  Created by William George on 06/11/2013.
//  Copyright (c) 2013 William George. All rights reserved.
//

#import "BSAlertViewLayout.h"

//WGFramework
#import "WGAlertView.h"

@implementation BSAlertViewLayout {
    CGSize windowSize;
    CGPoint padding;
    CGFloat y;
    UIScrollView *textScrollView;
    
    //Element Heights
    CGFloat _messageHeight;
    CGFloat _textFieldHeight;
    CGFloat _buttonHeight;
    
    //Supplimentary Views
    UIView *textFieldBackgroundView;
    NSArray *bouncyCircles;
    
    //Background Color
    UIColor *backgroundColor;
}

@synthesize alertViewSize = _alertViewSize;

-(void)prepareLayout
{
    windowSize = [[UIApplication sharedApplication] keyWindow].bounds.size;
    
    padding = CGPointMake(10, 10);
    
    _textFieldHeight = 30;
    _buttonHeight = 30;
    y = 0;
    
    //If we have more than two buttons, force stacked layout
    if(self.alertView.numberOfButtons > 2){
        self.alertViewButtonLayout = WGAlertViewButtonLayoutStacked;
    }
    
    //Work out if we need a scroll view
    CGFloat totalRequiredSpace = 0;
    if(self.alertView.alertViewStyle != UIAlertViewStyleDefault){
        totalRequiredSpace += padding.y + (_textFieldHeight * (self.alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput?2:1));
    }
    totalRequiredSpace += padding.y + (_buttonHeight * (self.alertViewButtonLayout == WGAlertViewButtonLayoutStacked?self.alertView.numberOfButtons:1));
    
    //Set Message Height
    _messageHeight = MAX(((self.alertViewSize.height)?:windowSize.height) - totalRequiredSpace, 50);
    
    if(!textScrollView){
        textScrollView = [[UIScrollView alloc] init];
        textScrollView.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:textScrollView];
    }
    
    //Background Color
    backgroundColor = (self.alertView.tintColor)?:[UIColor colorWithRed:0.647 green:0.796 blue:0.271 alpha:1.0];
}

-(void)layoutTitle:(UILabel *)titleLabel
{
    //Font + Color
    titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:24];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor whiteColor];
    
    //Find Text Label Size
    CGSize titleLableSize = [titleLabel.attributedText boundingRectWithSize:(CGSize){self.alertViewSize.width - (padding.x * 2), CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    titleLabel.frame = CGRectMake(padding.x, padding.y, self.alertViewSize.width - (padding.x * 2), titleLableSize.height + padding.y);
    
    //Add Title To Scroll View;
    [titleLabel removeFromSuperview];
    [textScrollView addSubview:titleLabel];
    textScrollView.frame = CGRectMake(0, 0, self.alertViewSize.width, CGRectGetMaxY(titleLabel.frame));
    
    y = CGRectGetMaxY(titleLabel.frame);
}

-(void)layoutMessage:(UILabel *)messageLabel
{
    //Font + Color
    messageLabel.font = [UIFont fontWithName:@"Avenir-Book" size:16];
    messageLabel.textColor = [UIColor whiteColor];
    
    //Set Paragraph Style
    NSMutableAttributedString *messageLabelText = [[NSMutableAttributedString alloc] initWithAttributedString:messageLabel.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineSpacing:2.5];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [messageLabelText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [messageLabelText length])];
    messageLabel.attributedText = messageLabelText;
    
    //Find Message Label Size
    CGSize messageLableSize = [messageLabel.attributedText boundingRectWithSize:(CGSize){self.alertViewSize.width - (padding.x * 2), CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    messageLabel.frame = CGRectMake(padding.x, y, self.alertViewSize.width - (padding.x * 2), messageLableSize.height + padding.y);
    
    //Add Title To Scroll View;
    [messageLabel removeFromSuperview];
    [textScrollView addSubview:messageLabel];
    
    y = CGRectGetMaxY(messageLabel.frame);
    
    if(y > _messageHeight){
        textScrollView.frame = CGRectMake(0, 0, self.alertViewSize.width, _messageHeight);
        textScrollView.contentSize = CGSizeMake(self.alertViewSize.width, y);
        [textScrollView flashScrollIndicators];
        y = textScrollView.frame.size.height;
    } else {
        textScrollView.frame = CGRectMake(0, 0, self.alertViewSize.width, y);
    }
}

-(void)layoutTextFields:(NSArray *)textFields
{
    y += padding.y;
    
    CGRect textFieldBackgroundViewFrame = CGRectNull;
    for(UITextField *textField in textFields){
        textField.frame = CGRectMake(padding.x + 10, y, self.alertViewSize.width - 20 - (padding.x * 2), _textFieldHeight);
        
        //Add Borders
        if(!CGRectIsNull(textFieldBackgroundViewFrame)){
            CALayer *borderTop = [CALayer layer];
            borderTop.frame = CGRectMake(0.0f, 0.0f, textField.frame.size.width, 1.0f);
            borderTop.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1].CGColor;
            [textField.layer addSublayer:borderTop];
        }
        
        textFieldBackgroundViewFrame = CGRectUnion(textFieldBackgroundViewFrame, textField.frame);
        y = CGRectGetMaxY(textField.frame);
    }
    
    y += padding.y;
    
    //Add Background If Needed
    if(!textFieldBackgroundView){
        textFieldBackgroundView = [[UIView alloc] init];
        textFieldBackgroundView.backgroundColor = [UIColor whiteColor];
        textFieldBackgroundView.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1].CGColor;
        textFieldBackgroundView.layer.borderWidth = 1.0f;
        textFieldBackgroundView.layer.cornerRadius = 5.0f;
        [self.alertView insertSubview:textFieldBackgroundView belowSubview:[textFields objectAtIndex:0]];
    }
    
    textFieldBackgroundView.frame = textFieldBackgroundViewFrame;
}

-(void)layoutButtons:(NSArray *)buttons
{
    NSMutableArray *layoutButtons = [[NSMutableArray alloc] initWithArray:buttons];
    
    //If we have a stacked layout
    if(self.alertViewButtonLayout == WGAlertViewButtonLayoutStacked && self.alertView.cancelButtonIndex != -1){
        //We want our cancel button to be the last.
        UIButton *cancelButton = [buttons objectAtIndex:self.alertView.cancelButtonIndex];
        [layoutButtons removeObject:cancelButton];
        [layoutButtons addObject:cancelButton];
    }
    
    CGFloat x = 0;
    NSInteger i = 0;
    for(UIButton *button in layoutButtons){
        //Add Hightlight
        [button addTarget:self action:@selector(didHighlightButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(didUnhighlightButton:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(didUnhighlightButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        button.layer.cornerRadius = 5.0f;
        
        //Dash Hack
        if(self.alertViewButtonLayout == WGAlertViewButtonLayoutStacked && [[button titleForState:UIControlStateNormal] isEqualToString:@"-"]){
            UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(x + (padding.x * 4), y + padding.y + 0.5, self.alertViewSize.width - (padding.x * 8), 2)];
            seperator.backgroundColor = button.backgroundColor;
            [self.alertView insertSubview:seperator aboveSubview:button];
            [button removeFromSuperview];
            y = CGRectGetMaxY(seperator.frame);
            
            i--;
        } else {
            //Position
            switch(self.alertViewButtonLayout){
                case WGAlertViewButtonLayoutStacked:
                    button.frame = CGRectMake(x + (padding.x * 4), y + padding.y, self.alertViewSize.width - (padding.x * 8), _buttonHeight);
                    y = CGRectGetMaxY(button.frame);
                break;
                default:
                case WGAlertViewButtonLayoutDefault:
                    button.frame = CGRectMake(x + (padding.x * 4) + (padding.x * i), y, (self.alertViewSize.width - (padding.x * 7) - (padding.x * [buttons count])) / [buttons count], _buttonHeight);
                    y = (x || [buttons count] == 1)?CGRectGetMaxY(button.frame):y;
                    x += CGRectGetWidth(button.frame);
                    i++;
                break;
            }
        }
    }
}

-(void)layoutAlertView:(WGAlertView *)alertView
{
    CGFloat alertViewHeight = self.alertViewSize.height;
    if(!alertViewHeight){
        alertViewHeight = y + 20;
    }
    
    //Reset Any Properties Orginially Set In InitialLayoutForAppearingView
    alertView.alpha = 1.0f;
    alertView.transform = CGAffineTransformIdentity; //Reset the trasform before setting the frame.
    
    alertView.frame = CGRectMake((windowSize.width - self.alertViewSize.width) / 2, (windowSize.height - alertViewHeight) / 2 + 20, self.alertViewSize.width, alertViewHeight);
    alertView.backgroundColor = backgroundColor;
    alertView.layer.cornerRadius = 50;
    alertView.clipsToBounds = NO;
    
    //Make Circles
    if(!bouncyCircles){
        UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(-30, 0, self.alertViewSize.width, self.alertViewSize.width)];
        circle1.backgroundColor = backgroundColor;
        circle1.layer.cornerRadius = circle1.frame.size.width / 2;
        [alertView insertSubview:circle1 atIndex:0];
        
        UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(45, -24, self.alertViewSize.width * .9, self.alertViewSize.width * .9)];
        circle2.backgroundColor = backgroundColor;
        circle2.layer.cornerRadius = circle2.frame.size.width / 2;
        [alertView insertSubview:circle2 atIndex:0];
        
        UIView *circle3 = [[UIView alloc] initWithFrame:CGRectMake(-10, -50, self.alertViewSize.width * .7, self.alertViewSize.width * .7)];
        circle3.backgroundColor = backgroundColor;
        circle3.layer.cornerRadius = circle3.frame.size.width / 2;
        [alertView insertSubview:circle3 atIndex:0];
        
        UIView *circle4 = [[UIView alloc] initWithFrame:CGRectMake(110, -80, self.alertViewSize.width * .2, self.alertViewSize.width * .2)];
        circle4.backgroundColor = backgroundColor;
        circle4.layer.cornerRadius = circle4.frame.size.width / 2;
        [alertView insertSubview:circle4 atIndex:0];
        
        UIView *circle5 = [[UIView alloc] initWithFrame:CGRectMake(170, -48, self.alertViewSize.width * .1, self.alertViewSize.width * .1)];
        circle5.backgroundColor = backgroundColor;
        circle5.layer.cornerRadius = circle5.frame.size.width / 2;
        [alertView insertSubview:circle5 atIndex:0];
        
        UIView *circle6 = [[UIView alloc] initWithFrame:CGRectMake(200, -15, self.alertViewSize.width * .05, self.alertViewSize.width * .05)];
        circle6.backgroundColor = backgroundColor;
        circle6.layer.cornerRadius = circle6.frame.size.width / 2;
        [alertView insertSubview:circle6 atIndex:0];
        bouncyCircles = @[circle6, circle5, circle4];
    }
    
    //Apply Motion Effects
    [self setMotionEffectWithView:alertView];
}

-(void)layoutDimView:(UIView *)dimView
{
    [dimView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.6]];
}

-(void)initialLayoutForAppearingView:(WGAlertView *)alertView
{
    alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    alertView.alpha = 0.0f;
    
    int i = 0;
    for(UIView *circle in bouncyCircles){        
        circle.alpha = 0.0;
        
        double delayInSeconds = 0.1 * i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [UIView animateWithDuration:0.1 animations:^{
                circle.alpha = 1;
            }];
            #warning - This causes the alert view to not appear above the keyboard
            //circle.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
            
            
            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            
            bounceAnimation.timingFunctions = @[
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
            ];
            bounceAnimation.values = @[
                @0.5,
                @1.2,
                @1.0
            ];
            bounceAnimation.keyTimes = @[
                 @0.0,
                 @0.7,
                 @1.0
            ];
            
            bounceAnimation.duration = 0.4;
            bounceAnimation.removedOnCompletion = NO;
            [circle.layer addAnimation:bounceAnimation forKey:@"bounce"];
            
            circle.layer.transform = CATransform3DIdentity;
        });
        
        i++;
    }
}

-(void)finalLayoutForDisappearingView:(WGAlertView *)alertView
{
    alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    alertView.alpha = 0.0f;
}

/**
 *  Alert View Size
 *  @return CGSize
 */
-(CGSize)alertViewSize
{
    if(CGSizeEqualToSize(_alertViewSize, CGSizeZero)){
        _alertViewSize = (CGSize){.width = 200, .height = 0};
    }
    
    return _alertViewSize;
}


#pragma mark - Helper Methods

/**
 *  Set Motion Effect
 *  This function will add the parallax effect to the view
 *  @return VOID
 */
- (void)setMotionEffectWithView:(WGAlertView *)view
{
    if([view respondsToSelector:@selector(setMotionEffects:)]){
        CGFloat kMotionEffectExtent = 8.0f;
        
        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        [xAxis setMinimumRelativeValue:@(-kMotionEffectExtent)];
        [xAxis setMaximumRelativeValue:@(kMotionEffectExtent)];
        
        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        [yAxis setMinimumRelativeValue:@(-kMotionEffectExtent)];
        [yAxis setMaximumRelativeValue:@(kMotionEffectExtent)];
        
        UIMotionEffectGroup *motionEffect = [UIMotionEffectGroup new];
        [motionEffect setMotionEffects:@[xAxis, yAxis]];
        
        [view addMotionEffect:motionEffect];
    }
}

/**
 *  Did Highlight Button
 *  This function makes up for the lack of setBackground:forState
 *  @return VOID
 */
-(void)didHighlightButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor colorWithWhite:0.874 alpha:1]];
}

/**
 *  Did Unhighlight Button
 *  This function makes up for the lack of setBackground:forState
 *  @return VOID
 */
-(void)didUnhighlightButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor whiteColor]];
}

@end
