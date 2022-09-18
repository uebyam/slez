//
//  AddHousePointsViewController.h
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import <UIKit/UIKit.h>
#include "head.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddHousePointsViewController : UIViewController

@property IBOutlet UILabel* diffLabel;
@property IBOutlet UITextField* inputField;

@property CGFloat das;
@property CGFloat arr;
@property bool addState;
@property bool minusState;
@property NSTimer* _Nullable timer;
@property long previousNumber;

@property NSString* house;

@property long number;

@property FIRDatabaseReference* ref;

@end

NS_ASSUME_NONNULL_END
