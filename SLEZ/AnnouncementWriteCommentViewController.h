//
//  AnnouncementWriteCommentViewController.h
//  SLEZ
//
//  Created by rey on 14/9/22.
//

#import <UIKit/UIKit.h>
#include "head.h"
#include "AnnouncementHead.h"
#include "AnnouncementDiscussionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementWriteCommentViewController : UIViewController<UITextViewDelegate>

@property IBOutlet UILabel* writeCommentLabel;
@property IBOutlet UITextView* inputView;
@property IBOutlet UIButton* sendButton;
@property NSString* inputViewPlaceholder;
@property UIColor* inputViewPlaceholderTextColor;
@property UIColor* inputViewMainTextColor;
@property bool keyboardIsShowing;

@property Announcement* announcement;
@property AnnouncementDiscussionViewController* parentVc;

@end

NS_ASSUME_NONNULL_END
