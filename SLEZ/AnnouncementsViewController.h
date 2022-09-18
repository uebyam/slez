//
//  AnnouncementsViewController.h
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import <UIKit/UIKit.h>

#include "head.h"
#include "AnnouncementHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView* tableView;
@property NSMutableArray<Announcement*>* announcements;
@property bool shouldLoadAnnouncements;

@property FIRFirestore* store;

@end


NS_ASSUME_NONNULL_END
