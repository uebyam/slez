//
//  AddHousePointsViewController.m
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import "AddHousePointsViewController.h"
#include "HousePointsViewController.h"

@interface AddHousePointsViewController ()

@end

@implementation AddHousePointsViewController

- (void)shouldDismissKeyboard:(UIGestureRecognizer*)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.number = [f numberFromString:self.inputField.text].longValue;
    self.diffLabel.text = [NSString stringWithFormat:@"%+ld", self.number - self.previousNumber];
    [self.view endEditing:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismissKeyboard:)];
    [self.view addGestureRecognizer:gr];
    
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    self.inputField.text = [NSString stringWithFormat:@"%ld", self.number];
    self.addState = self.minusState = false;
    self.das = 0.4;
    self.arr = 0.05;
    self.previousNumber = self.number;
}

- (void)addToNumber:(long)num {
    self.number += num;
    self.inputField.text = [NSString stringWithFormat:@"%ld", self.number];
    self.diffLabel.text = [NSString stringWithFormat:@"%+ld", self.number - self.previousNumber];
}

- (IBAction)addButtonPressed:(UIButton*)sender {
    self.addState = true;
    [self addToNumber:1];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.das repeats:false block:^(NSTimer * _Nonnull _) {
        if (self.addState) {
            [self addToNumber:1];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.arr repeats:true block:^(NSTimer * _Nonnull timer) {
                if (!self.addState) [self.timer invalidate];
                [self addToNumber:1];
            }];
        }
    }];
}

- (IBAction)addButtonReleased:(UIButton*)sender {
    self.addState = false;
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)minusButtonPressed:(UIButton*)sender {
    self.minusState = true;
    [self addToNumber:-1];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.das repeats:false block:^(NSTimer * _Nonnull _) {
        if (self.minusState) {
            [self addToNumber:-1];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.arr repeats:true block:^(NSTimer * _Nonnull timer) {
                if (!self.minusState) [self.timer invalidate];
                [self addToNumber:-1];
            }];
        }
    }];
}

- (IBAction)minusButtonReleased:(UIButton*)sender {
    self.minusState = false;
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)confirmPoints:(UIButton*)sender {
    [self shouldDismissKeyboard:nil];
    [[self.ref child:@"points"] getDataWithCompletionBlock:^(NSError * _Nullable error, FIRDataSnapshot * _Nullable snapshot) {
        NSMutableDictionary<NSString*, NSNumber*>* dict = [snapshot.value mutableCopy];
        dict[self.house] = [NSNumber numberWithLong:self.number];
        [[self.ref child:@"points"] setValue:dict];
        HousePointsViewController* parentVc = (HousePointsViewController*)self.presentingViewController;
        [parentVc refreshPoints];
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
