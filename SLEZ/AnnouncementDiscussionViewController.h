//
//  AnnouncementDiscussionViewController.h
//  SLEZ
//
//  Created by rey on 13/9/22.
//

#import <UIKit/UIKit.h>
#import "head.h"

#import "AnnouncementHead.h"

NS_ASSUME_NONNULL_BEGIN


@interface AnnouncementDiscussionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView* tableView;

@property FIRCollectionReference* commentRef;
@property Announcement* announcement;
@property NSMutableArray<Comment*>* comments;
@property NSMutableArray<Reply*>* replies;
@property bool viewingReplies;
@property bool shouldLoadComments;
@property bool shouldLoadReplies;

@end

NS_ASSUME_NONNULL_END
