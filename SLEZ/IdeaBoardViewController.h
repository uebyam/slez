//
//  IdeaBoardViewController.h
//  SLEZ
//
//  Created by rey on 11/9/22.
//

#import <UIKit/UIKit.h>

#include "head.h"
#include "IdeaHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdeaBoardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView* tableView;
@property IBOutlet UILabel* otherLabel;
@property IBOutlet UILabel* boardTitleLabel;

@property long selectedIdea;

@property NSArray<NSString*>* boardIds;
@property NSArray<NSString*>* boardTitles;
@property NSString* selectedBoard;
@property NSMutableArray<Idea*>* ideas;
@property FIRCollectionReference* collection;
@property bool shouldLoadIdeas;

@end


NS_ASSUME_NONNULL_END
