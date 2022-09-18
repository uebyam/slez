//
//  AnnouncementViewController.h
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import <UIKit/UIKit.h>

#include "AnnouncementHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementViewController : UIViewController

@property IBOutlet UITextView* infoView;
@property IBOutlet UILabel* titleLabel;
@property IBOutlet UILabel* authorLabel;
@property IBOutlet UIButton* discussionButton;
@property Announcement* announcement;


@end

NS_ASSUME_NONNULL_END
