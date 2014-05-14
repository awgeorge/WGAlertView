/**
 *  Copyright (c) 2013 Wunelli LTD.
 *
 *  @author William George
 *  @package WGFramework
 *  @category AlertView
 *  @date 01/11/2013
 */

#import "WGAlertViewLayout.h"

//WGFramework
#import "WGAlertView.h"

//AppleInternal
#import <QuartzCore/QuartzCore.h>

@implementation WGAlertViewLayout {
    CGSize windowSize;
    CGPoint padding;
    CGFloat y;
    UIScrollView *textScrollView;
    
    //Element Heights
    CGFloat _messageHeight;
    CGFloat _textFieldHeight;
    CGFloat _buttonHeight;
    
    //Supplimentary Views
    UIView *_textFieldBackgroundView;
}

-(void)prepareLayout
{
    windowSize = [[UIApplication sharedApplication] keyWindow].bounds.size;
    
    padding = CGPointMake(10, 10);
    
    _textFieldHeight = 30;
    _buttonHeight = 44;
    
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
    _messageHeight = ((self.alertViewSize.height)?:windowSize.height) - totalRequiredSpace;
    
    if(!textScrollView){
        textScrollView = [[UIScrollView alloc] init];
        [self.alertView addSubview:textScrollView];
    }
    textScrollView.frame = CGRectMake(0, 0, self.alertViewSize.width, _messageHeight);
}

-(void)layoutTitle:(UILabel *)titleLabel
{
    //Find Text Label Size
    CGSize titleLableSize = [titleLabel.attributedText boundingRectWithSize:(CGSize){self.alertViewSize.width - (padding.x * 2), CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    titleLabel.frame = CGRectMake(padding.x, padding.y, self.alertViewSize.width - (padding.x * 2), titleLableSize.height + padding.y);
    
    //Add Title To Scroll View;
    [titleLabel removeFromSuperview];
    [textScrollView addSubview:titleLabel];
    
    y = CGRectGetMaxY(titleLabel.frame);
}

-(void)layoutMessage:(UILabel *)messageLabel
{
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
    if(y > textScrollView.frame.size.height){
        textScrollView.contentSize = CGSizeMake(self.alertViewSize.width, y);
        [textScrollView flashScrollIndicators];
        y = textScrollView.frame.size.height;
    } else {
        textScrollView.frame = CGRectMake(0, 0, textScrollView.frame.size.width, y);
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
    
    //Add Background If Needed
    if(!_textFieldBackgroundView){
        _textFieldBackgroundView = [[UIView alloc] init];
        _textFieldBackgroundView.backgroundColor = [UIColor whiteColor];
        _textFieldBackgroundView.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1].CGColor;
        _textFieldBackgroundView.layer.borderWidth = 1.0f;
        _textFieldBackgroundView.layer.cornerRadius = 5.0f;
        [self.alertView insertSubview:_textFieldBackgroundView belowSubview:[textFields objectAtIndex:0]];
    }
    
    _textFieldBackgroundView.frame = textFieldBackgroundViewFrame;
}

-(void)layoutButtons:(NSArray *)buttons
{
    NSMutableArray *layoutButtons = [[NSMutableArray alloc] initWithArray:buttons];
    
    y += padding.y;
    
    //If we have a stacked layout
    if(self.alertViewButtonLayout == WGAlertViewButtonLayoutStacked && self.alertView.cancelButtonIndex != -1){
        //We want our cancel button to be the last.
        UIButton *cancelButton = [buttons objectAtIndex:self.alertView.cancelButtonIndex];
        [layoutButtons removeObject:cancelButton];
        [layoutButtons addObject:cancelButton];
    }
    
    CGFloat x = 0;
    for(UIButton *button in layoutButtons){
        //Add Hightlight
        [button addTarget:self action:@selector(didHighlightButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(didUnhighlightButton:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(didUnhighlightButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //Position
        switch(self.alertViewButtonLayout){
            case WGAlertViewButtonLayoutStacked:
                button.frame = CGRectMake(x, y, self.alertViewSize.width, _buttonHeight);
                y = CGRectGetMaxY(button.frame);
            break;
            default:
            case WGAlertViewButtonLayoutDefault:
                button.frame = CGRectMake(x, y, self.alertViewSize.width / [buttons count], _buttonHeight);
                y = (x || [buttons count] == 1)?CGRectGetMaxY(button.frame):y;
                
                //Add Borders
                if(x){
                    CALayer *borderLeft = [CALayer layer];
                    borderLeft.frame = CGRectMake(0.0f, 0.0f, 1.0f, button.frame.size.height);
                    borderLeft.backgroundColor = [UIColor colorWithRed:0.839 green:0.843 blue:0.843 alpha:1].CGColor;
                    [button.layer addSublayer:borderLeft];
                }
                
                x += CGRectGetWidth(button.frame);
            break;
        }
        
        //Add Borders
        CALayer *borderTop = [CALayer layer];
        borderTop.frame = CGRectMake(0.0f, 0.0f, button.frame.size.width, 1.0f);
        borderTop.backgroundColor = [UIColor colorWithRed:0.839 green:0.843 blue:0.843 alpha:1].CGColor;
        [button.layer addSublayer:borderTop];
    }
}

-(void)layoutAlertView:(WGAlertView *)alertView
{
    CGFloat alertViewHeight = self.alertViewSize.height;
    if(!alertViewHeight){
        alertViewHeight = y;
    }
    
    //Reset Any Properties Orginially Set In InitialLayoutForAppearingView
    alertView.alpha = 1.0f;
    alertView.transform = CGAffineTransformIdentity; //Reset the trasform before setting the frame.
    
    alertView.frame = CGRectMake((windowSize.width - self.alertViewSize.width) / 2, (windowSize.height - alertViewHeight) / 2, self.alertViewSize.width, alertViewHeight);
    alertView.backgroundColor = [UIColor colorWithWhite:0.906 alpha:0.97];
    alertView.layer.cornerRadius = 8.0f;
    
    //Apply Motion Effects
    [self setMotionEffectWithView:alertView];
}

-(void)layoutDimView:(UIView *)dimView
{
   //Not needed, here just to show we can override :)
}

-(void)initialLayoutForAppearingView:(WGAlertView *)alertView
{
    alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    alertView.alpha = 0.0f;
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
        _alertViewSize = (CGSize){.width = 270, .height = 0};
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
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
#endif
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
    [button setBackgroundColor:[UIColor clearColor]];
}

@end
