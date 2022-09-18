//
//  DutyStudentsViewController.h
//  SLEZ
//
//  Created by rey on 11/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DutyStudentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView* tableView;
@property NSArray<NSString*>* students;

@end

NS_ASSUME_NONNULL_END
