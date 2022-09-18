//
//  IdeaDetailViewController.h
//  SLEZ
//
//  Created by rey on 12/9/22.
//

#import <UIKit/UIKit.h>

#include "IdeaHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdeaDetailViewController : UIViewController

@property IBOutlet UILabel* titleLabel;
@property IBOutlet UILabel* authorLabel;
@property IBOutlet UITextView* infoView;
@property IBOutlet UIButton* discussionButton;

@property Idea* idea;

@end

NS_ASSUME_NONNULL_END
