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
#import "WGAlertView.h"

//WGFramwork
#import "_WGAlertManager.h"
#import "WGAlertViewLayout.h"

@interface WGAlertView (){
    UILabel   *_titleLabel;
    //UILabel   *_subtitleLabel;
    UILabel   *_bodyTextLabel;
    //UILabel   *_taglineTextLabel;
    //CGFloat    _startY;
    //CGPoint    _center;
    //id         _context;
    NSInteger  _cancelButton;
    NSInteger  _defaultButton;
    NSInteger  _firstOtherButton;
    //UIToolbar *_toolbar;
    UIWindow  *_originalWindow;
    UIWindow  *_dimWindow;
    //NSInteger  _suspendTag;
    NSInteger  _dismissButtonIndex;
    //CGFloat    _bodyTextHeight;
    NSMutableArray *_buttons;
    NSMutableArray *_textFields;
    //UIView *_keyboard;
    //UIView *_table;
    UIView *_dimView;
    //UIView *_backgroundImageView;
    //UIView *_contentViewNeue;
    //UIView *_textFieldBackgroundView;
    //UIWindow *_blurWindow;
    //UIView *_backdropView;
    
    //NSMutableDictionary *_separatorsViews;
}

@end

@implementation WGAlertView

@synthesize alertViewLayout = _alertViewLayout;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //UIAlertView
    }
    return self;
}

/**
 *  Init With Title
 *  @param NSString - title
 *  @param NSString - message
 *  @param ID - delegate
 *  @param NSString - cancelButtonTitle
 *  @param NSString - otherButtonTitles
 *  @return SELF
 */
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if(self = [self init]){
        //Construct Alert
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        
        if(cancelButtonTitle){
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = 0;
		}
		
		if(otherButtonTitles){
			_firstOtherButtonIndex = [_buttons count];
			[self addButtonWithTitle:otherButtonTitles];
			
			va_list args;
			va_start(args, otherButtonTitles);
			
			id arg;
			while((arg = va_arg(args, id)) != nil){
				if(![arg isKindOfClass:[NSString class]]){
					return nil;
                }
				
				[self addButtonWithTitle:(NSString *)arg];
			}
		}
    }
    
    return self;
}

/**
 *  dealloc
 *  @return VOID
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


/**
 *  Add Button With Title
 *  This methods adds buttons to our alert view
 *  @param NSString - title
 *  @return NSInteger - The index of the button added.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title
{
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:title forState:UIControlStateNormal];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    [button setTitleColor:(self.tintColor)?:[UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
#endif
    [button setTitleColor:[UIColor colorWithWhite:0.561 alpha:1] forState:UIControlStateDisabled];
    
    //We have added something, needs updating.
    [_buttons addObject:button];
	[self setNeedsLayout];
	
	return _buttons.count - 1;
}

/**
 *  Button Title At Index
 *  This function returns the title of a button
 *  @param NSInteger - buttonIndex
 *  @return NSString - the button title
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
	//Make sure we are within range
	if(buttonIndex < 0 || buttonIndex >= [_buttons count]){
		return nil;
    }
	
	UIButton *button = [_buttons objectAtIndex:buttonIndex];
	return [button titleForState:UIControlStateNormal];
}

/**
 *  Text Field At Index
 *  This function returns the text field at index
 *  @param NSInteger - textFieldIndex
 *  @return UITextField - The text field
 */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    //Make sure we are within range
	if(textFieldIndex < 0 || textFieldIndex >= [_textFields count]){
		return nil;
    }
	
	return (UITextField *)[_textFields objectAtIndex:textFieldIndex];
}

/**
 *  Show
 *  This function will display the alert view
 *  @return VOID
 */
-(void)show
{
    if(![_WGAlertManager stackContainsAlert:self]){
        [self addSubviews];
        
        //Call Delegate Method
        if([self.delegate respondsToSelector:@selector(willPresentAlertView:)]){
            [self.delegate willPresentAlertView:(UIAlertView *)self];
        }
        
//        //Window Creation
//        _dimWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _dimWindow.windowLevel = UIWindowLevelAlert;
//        _dimWindow.backgroundColor = [UIColor clearColor];
//        
//        _dimWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
//        [_dimWindow addSubview:self];
//        
//        _originalWindow = [[UIApplication sharedApplication] keyWindow];
//        [_dimWindow makeKeyAndVisible];

        //Prepare Our View
        [self layoutIfNeeded];
        
        //Add
        [_WGAlertManager addToStack:self dontDimBackground:NO];
    }
    
    [self.alertViewLayout initialLayoutForAppearingView:self];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.alertViewLayout layoutAlertView:self];
        //self.transform = CGAffineTransformIdentity;
        //self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        //Call Delegate Method
        if([self.delegate respondsToSelector:@selector(didPresentAlertView:)]){
            [self.delegate didPresentAlertView:(UIAlertView *)self];
        }
    }];
    
    if(self.alertViewStyle != UIAlertViewStyleDefault){
        [[_textFields objectAtIndex:0] becomeFirstResponder];
    }
}


/**
 *  Dismiss With Clicked Button Index
 *  This function will dismiss the alert view
 *  @param NSInteger - buttonIndex
 *  @param BOOL - animated
 *  @return VOID
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    _dismissButtonIndex = buttonIndex;
    
    //Remove Keyboard 
	if(self.alertViewStyle != UIAlertViewStyleDefault){
        for(UITextField *textField in _textFields){
            [textField resignFirstResponder];
        }
	}
	
    //We have a delegate the user can tap into.
	if([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]){
		[self.delegate alertView:(UIAlertView *)self willDismissWithButtonIndex:buttonIndex];
	}
    
    //Dismiss
    [_WGAlertManager removeFromStack:self];
    [self dismissAnimated:animated];
}
     
-(void)dismissAnimated:(BOOL)animated
{
    [UIView animateWithDuration:(animated)?0.3:0.0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.alertViewLayout finalLayoutForDisappearingView:self];
    } completion:^(BOOL finished) {
        //We have a delegate the user can tap into.
        if([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]){
            [self.delegate alertView:(UIAlertView *)self didDismissWithButtonIndex:_dismissButtonIndex];
        }
    }];
}

-(void)registerClass:(Class)layoutClass forAlertStyleIdentifier:(NSString *)identifier
{
    
}

#pragma mark - Private Methods

-(id)init
{
    if(self = [super init]){
        //Set Up Defaults
        _buttons = [[NSMutableArray alloc] init];
        _textFields = [[NSMutableArray alloc] init];
        
        _firstOtherButtonIndex = -1;
        _cancelButtonIndex = -1;
        _dismissButtonIndex = -1;
        
        _alertViewStyle = UIAlertViewStyleDefault;
        
//        CGSize alertViewSize = [self.alertViewLayout alertViewSize];
//        self.frame = CGRectMake(0, 0, alertViewSize.width, alertViewSize.height);
        self.clipsToBounds = YES;
    }
    
    return self;
}

/**
 *  Layout Subviews
 *  This function we position our elements
 *  @return VOID
 */
-(void)layoutSubviews
{
    [self.alertViewLayout prepareLayout];
    
    if(self.title){
        [self.alertViewLayout layoutTitle:_titleLabel];
    }
    
    if(self.message){
        [self.alertViewLayout layoutMessage:_bodyTextLabel];
    }
    
    if([_textFields count]){
        [self.alertViewLayout layoutTextFields:_textFields];
    }
    
    NSInteger buttonsCount;
    if((buttonsCount = self.numberOfButtons)){
        //Set Default Fonts
        switch(buttonsCount){
            case 1:{
                UIButton *button = (UIButton *)[_buttons objectAtIndex:0];
                button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:button.titleLabel.font.pointSize];
            }
            break;
            case 2:{
                UIButton *button = (UIButton *)[_buttons objectAtIndex:_firstOtherButtonIndex];
                button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:button.titleLabel.font.pointSize];
            }
            break;
            default:{
                if(_cancelButtonIndex != -1){
                    UIButton *button = (UIButton *)[_buttons objectAtIndex:_cancelButtonIndex];
                    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:button.titleLabel.font.pointSize];
                }
            }
        }
        
        //Disable Button
        if([self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)] && _firstOtherButtonIndex != -1){
            [[_buttons objectAtIndex:_firstOtherButtonIndex] setEnabled:[self.delegate alertViewShouldEnableFirstOtherButton:(UIAlertView *)self]];
        }
        
        [self.alertViewLayout layoutButtons:_buttons];
    }
    
    [self.alertViewLayout layoutAlertView:self];
    
    [self.alertViewLayout layoutDimView:[_WGAlertManager shared].dimView];
}

/**
 *  Add Subviews
 *  This function will add our elements to the alert view
 *  @return VOID
 */
-(void)addSubviews
{
    //Title Label
    [super addSubview:_titleLabel];

    //Message Label
    [super addSubview:_bodyTextLabel];

    //UITextFields
    for(UITextField *textField in _textFields){
        [super addSubview:textField];
    }

    //UIButtons
    for(UIButton *button in _buttons){
        [super addSubview:button];
    }
}

#pragma mark - Setters

-(void)setCancelButtonIndex:(NSInteger)cancelButtonIndex
{
    //Make sure we are within range
	if(cancelButtonIndex < 0 || cancelButtonIndex >= [_buttons count]){
		return;
    }
    
    _cancelButtonIndex = cancelButtonIndex ;
}

-(void)setAlertViewLayout:(WGAlertViewLayout *)alertViewLayout
{
    _alertViewLayout = alertViewLayout;
    _alertViewLayout.alertView = self;
}

-(void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    if(_alertViewStyle != alertViewStyle){
        switch(alertViewStyle){
            case UIAlertViewStyleSecureTextInput:
            case UIAlertViewStylePlainTextInput:
            case UIAlertViewStyleLoginAndPasswordInput:{
                BOOL loginAlertViewStyle = alertViewStyle == UIAlertViewStyleLoginAndPasswordInput;
                for(int i = 0; i < (loginAlertViewStyle?2:1); i++){
                    UITextField *textField = [[UITextField alloc] init];
                    [textField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
                    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    textField.secureTextEntry = (i == 1 || alertViewStyle == UIAlertViewStyleSecureTextInput);
                    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
                    textField.leftViewMode = UITextFieldViewModeAlways;
                    textField.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                    if(loginAlertViewStyle){
                        textField.placeholder = (i == 0)?@"Login":@"Password";
                    }
                    [_textFields addObject:textField];
                }
                
                //Lets Detect Keyboard
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            }
            break;
            case UIAlertViewStyleDefault:
                [_textFields removeAllObjects];
            break;
        }
        
        _alertViewStyle = alertViewStyle;
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    [self _titleLabel];
    _titleLabel.text = title;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    
    [self _bodyTextLabel];
    _bodyTextLabel.text = message;
}

-(void)setFrame:(CGRect)frame
{
    //Are we within bounds
    CGRect windowBounds = [[UIApplication sharedApplication] keyWindow].bounds;
    
    if(!CGRectContainsRect(windowBounds, frame)){
        CGSize alertViewSize = {270, windowBounds.size.height - 30};
        frame = CGRectMake((windowBounds.size.width - alertViewSize.width) / 2, (windowBounds.size.height - alertViewSize.height) / 2, alertViewSize.width, alertViewSize.height);
    }
    
    [super setFrame:frame];
}

#pragma mark - Getters

-(NSInteger)numberOfButtons
{
    return [_buttons count];
}

-(BOOL)isVisible
{
	return self.superview != nil;
}

-(UILabel *)_titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _titleLabel.numberOfLines = 0;
    }
    
    return _titleLabel;
}

- (UILabel *)_bodyTextLabel
{
    if(!_bodyTextLabel){
        _bodyTextLabel = [[UILabel alloc] init];
        _bodyTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _bodyTextLabel.textColor = [UIColor colorWithWhite:0.137 alpha:1];
        _bodyTextLabel.backgroundColor = [UIColor clearColor];
        _bodyTextLabel.textAlignment = UITextAlignmentCenter;
        _bodyTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        _bodyTextLabel.numberOfLines = 0;
    }
    
    return _bodyTextLabel;
}

-(WGAlertViewLayout *)alertViewLayout
{
    if(!_alertViewLayout){
        self.alertViewLayout = [[WGAlertViewLayout alloc] init];
    }
    
    return _alertViewLayout;
}


#pragma mark - UIButton

-(void)didSelectButton:(id)sender
{
    NSInteger buttonIndex = [_buttons indexOfObjectIdenticalTo:sender];
    
    //Fire Delegate If Needed
    if([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [self.delegate alertView:(UIAlertView *)self clickedButtonAtIndex:buttonIndex];
    }
    
    //Close Alert View
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UITextField

-(void)textFieldDidBegin:(UITextField *)textField
{
    
}

-(void)textFieldDidChange:(UITextField *)textField
{
    //Enable Button Perhaps
    if([self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]){
        UIButton *firstOtherButton = [_buttons objectAtIndex:_firstOtherButtonIndex];
        [firstOtherButton setEnabled:[self.delegate alertViewShouldEnableFirstOtherButton:(UIAlertView *)self]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - Keyboard Notifications

-(void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyboardRect = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.superview convertRect:keyboardRect fromView:nil];

    if(CGRectIntersectsRect(self.frame, keyboardRect)){
        CGPoint centerPoint = self.center;

        if(CGRectGetHeight(self.frame) > CGRectGetMinY(keyboardRect)){
            self.alertViewLayout.alertViewSize = CGSizeMake(self.alertViewLayout.alertViewSize.width, CGRectGetMinY(keyboardRect) - 20);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }

        centerPoint.y = CGRectGetMinY(keyboardRect) / 2;
        
        [UIView animateWithDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations: ^{
            [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
            
            [self setCenter:centerPoint];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)note
{
    if(_dismissButtonIndex == -1){
        [UIView animateWithDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations: ^{
            [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];

            self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
            self.frame = CGRectIntegral(self.frame);
        }];
    }
}


#pragma mark - NOOP
//SILLY
//-(void)addSubview:(UIView *)view
//{
//    //Apple have removed this functionality. So have we.
//    NSLog(@"%@", @"Sorry, addSubview is not supported. Please create a custom layout.");
//}

@end
