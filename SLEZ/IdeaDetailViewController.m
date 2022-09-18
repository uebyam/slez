//
//  IdeaDetailViewController.m
//  SLEZ
//
//  Created by rey on 12/9/22.
//

#import "IdeaDetailViewController.h"
#import "IdeaBoardDiscussionViewController.h"

@interface IdeaDetailViewController ()

@end

@implementation IdeaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    self.discussionButton.layer.cornerRadius = 8;
    self.discussionButton.layer.cornerCurve = kCACornerCurveContinuous;
    
    self.infoView.text = self.idea.info;
    self.titleLabel.text = self.idea.title;
    self.authorLabel.text = [NSString stringWithFormat:@"by %@", self.idea.author];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ideaShowDiscussionSegue"]) {
        IdeaBoardDiscussionViewController* destVc = segue.destinationViewController;
        destVc.idea = self.idea;
    }
}

@end
