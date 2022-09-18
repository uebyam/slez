//
//  HousePointsViewController.h
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import <UIKit/UIKit.h>

#include "head.h"

NS_ASSUME_NONNULL_BEGIN

@interface HousePointsViewController : UIViewController

@property IBOutlet UIView* bluePointsView;
@property IBOutlet UIView* redPointsView;
@property IBOutlet UIView* blackPointsView;
@property IBOutlet UIView* yellowPointsView;
@property IBOutlet UIView* greenPointsView;
@property IBOutlet UIView* pointsView;

@property IBOutlet UILabel* bluePointsLabel;
@property IBOutlet UILabel* redPointsLabel;
@property IBOutlet UILabel* blackPointsLabel;
@property IBOutlet UILabel* yellowPointsLabel;
@property IBOutlet UILabel* greenPointsLabel;

@property IBOutlet UIButton* refreshButton;

@property FIRDatabaseReference *ref;

- (void)refreshPoints;


@property NSMutableDictionary<NSString*, NSNumber*>* pointsDict;

@end

NS_ASSUME_NONNULL_END
