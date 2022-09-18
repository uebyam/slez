//
//  IdeaBoardDiscussionViewController.h
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import <UIKit/UIKit.h>
#include "head.h"
#include "IdeaHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdeaBoardDiscussionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView* tableView;

@property FIRCollectionReference* commentRef;
@property Idea* idea;
@property NSMutableArray<IdeaComment*>* comments;
@property NSMutableArray<IdeaReply*>* replies;
@property bool shouldLoadComments;

@end

NS_ASSUME_NONNULL_END
