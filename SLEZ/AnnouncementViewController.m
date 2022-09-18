//
//  AnnouncementViewController.m
//  SLEZ
//
//  Created by rey on 10/9/22.
//

#import "AnnouncementViewController.h"
#import "AnnouncementDiscussionViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    // Do any additional setup after loading the view.
    
    self.infoView.text = self.announcement.info;
    self.titleLabel.text = self.announcement.title;
    self.authorLabel.text = [NSString stringWithFormat:@"by %@", self.announcement.author];
    self.authorLabel.textColor = UIColor.systemGrayColor;
    self.infoView.textColor = UIColor.whiteColor;
    
    self.discussionButton.layer.cornerRadius = 8;
    self.discussionButton.layer.cornerCurve = kCACornerCurveContinuous;
    if (self.announcement.important) {
        UIColor* gcol = [UIColor colorNamed:@"appGoldenColor5"];
        CGFloat gcol_comps[4];
        [gcol getRed:gcol_comps green:&gcol_comps[1] blue:&gcol_comps[2] alpha:&gcol_comps[3]];
        UIColor* gcol_trans = [UIColor colorWithRed:gcol_comps[0]*0.4 green:gcol_comps[1]*0.4 blue:gcol_comps[2]*0.4 alpha:1];
        
        self.view.layer.backgroundColor = self.infoView.layer.backgroundColor = gcol_trans.CGColor;
        self.discussionButton.layer.backgroundColor = gcol.CGColor;
    } else {
        self.discussionButton.layer.backgroundColor = UIColor.systemBlueColor.CGColor;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AnnouncementDiscussionViewController* destVc = segue.destinationViewController;
    destVc.announcement = self.announcement;
}


@end
