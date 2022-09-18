//
//  AnnouncementPostViewController.h
//  SLEZ
//
//  Created by rey on 16/9/22.
//

#import <UIKit/UIKit.h>
#include "head.h"
#include "AnnouncementHead.h"
#include "AnnouncementsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementPostViewController : UIViewController<UITextViewDelegate>

@property IBOutlet UITextView* inputView;
@property IBOutlet UITextView* titleInputView;
@property IBOutlet UIButton* sendButton;
@property IBOutlet UILabel* titleLabel;
@property IBOutlet UILabel* importantLabel;
@property IBOutlet UISwitch* importantSwitch;

@property AnnouncementsViewController* parentVc;
@property NSString* inputViewPlaceholder;
@property NSString* titleInputViewPlaceholder;
@property UIColor* placeholderTextColor;
@property UIColor* mainTextColor;

@property bool keyboardIsShowing;

@end

NS_ASSUME_NONNULL_END
