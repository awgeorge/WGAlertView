/**
 *  Copyright (c) 2013 Wunelli LTD.
 *
 *  @author William George
 *  @package WGFramework
 *  @category AlertView
 *  @date 01/11/2013
 */

#import <UIKit/UIKit.h>

@class WGAlertViewLayout;
@interface WGAlertView : UIView

/**
 *  Public Properties
 */
@property(nonatomic, retain) WGAlertViewLayout *alertViewLayout;
@property(nonatomic, weak) id <UIAlertViewDelegate> delegate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;   // secondary explanation text
@property(readonly, nonatomic, assign) NSInteger numberOfButtons;
@property(nonatomic, assign) NSInteger cancelButtonIndex; // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex; // -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

// Alert view style - defaults to UIAlertViewStyleDefault
@property(nonatomic,assign) UIAlertViewStyle alertViewStyle NS_AVAILABLE_IOS(5_0);


/**
 *  Public Methods
 */

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)registerClass:(Class)layoutClass forAlertStyleIdentifier:(NSString *)identifier;

// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
// cancel button which will be positioned based on HI requirements. buttons cannot be customized.
- (NSInteger)addButtonWithTitle:(NSString *)title;    // returns index of button. 0 based.
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

// shows popup alert animated.
- (void)show;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
-(void)dismissAnimated:(BOOL)animated;

/* Retrieve a text field at an index - raises NSRangeException when textFieldIndex is out-of-bounds.
 The field at index 0 will be the first text field (the single field or the login field), the field at index 1 will be the password field. */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex NS_AVAILABLE_IOS(5_0);



@end
