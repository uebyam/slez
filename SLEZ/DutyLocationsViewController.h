//
//  DutiesViewController.h
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import <UIKit/UIKit.h>
#include <time.h>

#include "head.h"

NS_ASSUME_NONNULL_BEGIN



@interface DutyLocationsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView* tableView;
@property IBOutlet UILabel* otherLabel;

@property NSArray<NSString*>* dutyLocations;
@property FIRFirestore* store;
@property NSDictionary<NSString*, NSArray<NSString*>*>* dutyTakers;
@property NSInteger selectedLocation;
@property int day;
@property FIRCollectionReference* collection;
/*
 dutyTakers
 
[
    [
        "S1.tag"  // L1, monday
        "S2.tag"  // L1, monday
    ],
    [
        "S1.tag"  // L2, monday
    ]
]
 
 */

@end

NS_ASSUME_NONNULL_END
