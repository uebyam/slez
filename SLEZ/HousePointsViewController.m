//
//  HousePointsViewController.m
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import "HousePointsViewController.h"
#include "AddHousePointsViewController.h"

@interface HousePointsViewController ()

@end

@implementation HousePointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    self.ref = [[FIRDatabase databaseWithURL:@"https://slez-b6095-default-rtdb.asia-southeast1.firebasedatabase.app/"] reference];
    
    // Setting view colours
    self.bluePointsView.backgroundColor = UIColor.systemBlueColor;
    self.redPointsView.backgroundColor = UIColor.systemRedColor;
    self.blackPointsView.backgroundColor = UIColor.blackColor;
    self.yellowPointsView.backgroundColor = UIColor.systemYellowColor;
    self.greenPointsView.backgroundColor = UIColor.systemGreenColor;
    
    // Get views desired width
    CGFloat width = self.pointsView.frame.size.width * 0.2;
    
    // Setting view frames
    CGRect desiredViewFrame = CGRectMake(0, 0, width, 0);
    self.bluePointsView.frame = desiredViewFrame;
    self.redPointsView.frame = desiredViewFrame;
    self.blackPointsView.frame = desiredViewFrame;
    self.yellowPointsView.frame = desiredViewFrame;
    self.greenPointsView.frame = desiredViewFrame;
    
    self.bluePointsLabel.text = @"";
    self.redPointsLabel.text = @"";
    self.blackPointsLabel.text = @"";
    self.yellowPointsLabel.text = @"";
    self.greenPointsLabel.text = @"";
    
    [self refreshPoints];
}

- (IBAction)refreshButtonPressed:(UIButton*)sender {
    self.refreshButton.enabled = false;
    [self refreshPoints];
}

- (void)refreshPoints {
    [[self.ref child:@"points"] getDataWithCompletionBlock:^(NSError * _Nullable error, FIRDataSnapshot * _Nullable snapshot) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
            self.refreshButton.enabled = true;
        }];
        if (error) {
            NSLog(@"Error occurred: %@", error);
            self.pointsView.hidden = true;
        } else {
            self.pointsView.hidden = false;
            self.pointsDict = [(NSDictionary*)(snapshot.value) mutableCopy];
            NSLog(@"Success getting dict: %@", self.pointsDict);
            
            // Get views desired width
            CGFloat width = self.pointsView.frame.size.width * 0.2;
            CGFloat labelHeight = self.redPointsLabel.frame.size.height;
            CGFloat fullHeight = self.pointsView.frame.size.height - 8;
            CGFloat offset = 8;
            
            // Get max height and points
            CGFloat maxHeight = fullHeight - labelHeight - 8;
            
            CGFloat bluePoints = self.pointsDict[@"blue"].doubleValue;
            CGFloat redPoints = self.pointsDict[@"red"].doubleValue;
            CGFloat blackPoints = self.pointsDict[@"black"].doubleValue;
            CGFloat yellowPoints = self.pointsDict[@"yellow"].doubleValue;
            CGFloat greenPoints = self.pointsDict[@"green"].doubleValue;
            
            CGFloat maxPoints = MAX(bluePoints, redPoints);
            maxPoints = MAX(maxPoints, blackPoints);
            maxPoints = MAX(maxPoints, yellowPoints);
            maxPoints = MAX(maxPoints, greenPoints);
            
            bluePoints *= maxHeight / maxPoints;
            redPoints *= maxHeight / maxPoints;
            blackPoints *= maxHeight / maxPoints;
            yellowPoints *= maxHeight / maxPoints;
            greenPoints *= maxHeight / maxPoints;
            
            // Setting view colours
            self.bluePointsView.backgroundColor = UIColor.systemBlueColor;
            self.redPointsView.backgroundColor = UIColor.systemRedColor;
            self.blackPointsView.backgroundColor = UIColor.blackColor;
            self.yellowPointsView.backgroundColor = UIColor.systemYellowColor;
            self.greenPointsView.backgroundColor = UIColor.systemGreenColor;
            
            // Setting view frames
            CGRect blueFrame = CGRectMake(0, fullHeight - bluePoints + offset, width, bluePoints);
            CGRect redFrame = CGRectMake(0, fullHeight - redPoints + offset, width, redPoints);
            CGRect blackFrame = CGRectMake(0, fullHeight - blackPoints + offset, width, blackPoints);
            CGRect yellowFrame = CGRectMake(0, fullHeight - yellowPoints + offset, width, yellowPoints);
            CGRect greenFrame = CGRectMake(0, fullHeight - greenPoints + offset, width, greenPoints);
            
            CGRect blueLabelFrame = blueFrame;
            CGRect redLabelFrame = redFrame;
            CGRect blackLabelFrame = blackFrame;
            CGRect yellowLabelFrame = yellowFrame;
            CGRect greenLabelFrame = greenFrame;
            blueLabelFrame.origin.y -= labelHeight + 8;
            blueLabelFrame.size.height = labelHeight;
            redLabelFrame.origin.y -= labelHeight + 8;
            redLabelFrame.size.height = labelHeight;
            blackLabelFrame.origin.y -= labelHeight + 8;
            blackLabelFrame.size.height = labelHeight;
            yellowLabelFrame.origin.y -= labelHeight + 8;
            yellowLabelFrame.size.height = labelHeight;
            greenLabelFrame.origin.y -= labelHeight + 8;
            greenLabelFrame.size.height = labelHeight;
            
            
            self.bluePointsView.frame = blueFrame;
            self.redPointsView.frame = redFrame;
            self.blackPointsView.frame = blackFrame;
            self.yellowPointsView.frame = yellowFrame;
            self.greenPointsView.frame = greenFrame;
            
            self.bluePointsLabel.text = self.pointsDict[@"blue"].stringValue;
            self.redPointsLabel.text = self.pointsDict[@"red"].stringValue;
            self.blackPointsLabel.text = self.pointsDict[@"black"].stringValue;
            self.yellowPointsLabel.text = self.pointsDict[@"yellow"].stringValue;
            self.greenPointsLabel.text = self.pointsDict[@"green"].stringValue;
            
            self.bluePointsLabel.frame = blueLabelFrame;
            self.redPointsLabel.frame = redLabelFrame;
            self.blackPointsLabel.frame = blackLabelFrame;
            self.yellowPointsLabel.frame = yellowLabelFrame;
            self.greenPointsLabel.frame = greenLabelFrame;
            
            
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"addHousePointsSegue"]) {
        AddHousePointsViewController* destVc = segue.destinationViewController;
        destVc.ref = self.ref;
        destVc.house = @[@"blue", @"red", @"black", @"yellow", @"green"][((UIButton*)sender).tag - 1];
        destVc.number = self.pointsDict[destVc.house].longValue;
    }
}

@end
