//
//  ViewController.h
//  SLEZ
//
//  Created by rey on 24/8/22.
//

#include "head.h"

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UITextField* usernameTextField;
@property IBOutlet UITextField* passwordTextField;
@property IBOutlet UIView* signInContainer;

- (IBAction)signIn:(UIButton*)sender;
- (IBAction)signUp:(UIButton*)sender;

@end

