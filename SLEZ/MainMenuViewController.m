//
//  MainMenuViewController.m
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    // Do any additional setup after loading the view.
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue *)unwindSegue {
    
    // Use data from the view controller which initiated the unwind segue
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
