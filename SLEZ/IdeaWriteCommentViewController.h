//
//  IdeaWriteCommentViewController.h
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import <UIKit/UIKit.h>
#include "head.h"
#include "IdeaHead.h"
#include "IdeaBoardDiscussionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdeaWriteCommentViewController : UIViewController<UITextViewDelegate>

@property IBOutlet UITextView* inputView;
@property IBOutlet UILabel* titleLabel;
@property IBOutlet UIButton* sendButton;

@property UIColor* placeholderColor;
@property UIColor* mainColor;
@property NSString* placeholderText;

@property Idea* idea;

@property CGFloat contentYInset;
@property IdeaBoardDiscussionViewController* parentVc;

@end

NS_ASSUME_NONNULL_END
