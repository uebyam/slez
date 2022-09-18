//
//  AnnouncementWriteCommentViewController.m
//  SLEZ
//
//  Created by rey on 14/9/22.
//

#import "AnnouncementWriteCommentViewController.h"

@interface AnnouncementWriteCommentViewController ()

@end

@implementation AnnouncementWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* dismissKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismissKeyboard:)];
    [self.view addGestureRecognizer:dismissKeyboardGestureRecognizer];
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    self.parentVc = (AnnouncementDiscussionViewController*)self.presentingViewController;
    // "constraints" :thonk:
}

- (void)viewWillAppear:(BOOL)animated {
    self.writeCommentLabel.frame = CGRectMake(16, 20, self.view.frame.size.width - 32, 29);
    self.sendButton.frame = CGRectMake(32, self.view.frame.size.height - 32 - 20, self.view.frame.size.width - 64, 35);
    self.inputView.frame = CGRectMake(16, self.writeCommentLabel.frame.origin.y + self.writeCommentLabel.frame.size.height + 8, self.view.frame.size.width - 32, (self.sendButton.frame.origin.y - 8) - (self.writeCommentLabel.frame.origin.y + self.writeCommentLabel.frame.size.height + 8));
    
    self.inputView.layer.cornerRadius = 8;
    self.inputView.delegate = self;
    
    self.inputViewPlaceholderTextColor = UIColor.grayColor;
    self.inputViewMainTextColor = [UIColor colorNamed:@"appLabelColor"];
    self.inputViewPlaceholder = @"Type a comment...";
    
    self.inputView.textColor = self.inputViewPlaceholderTextColor;
    self.inputView.text = self.inputViewPlaceholder;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyboardIsShowing = false;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.inputView.text isEqualToString:self.inputViewPlaceholder]
        && [self.inputView.textColor isEqual:self.inputViewPlaceholderTextColor]) {
        self.inputView.text = @"";
        self.inputView.textColor = self.inputViewMainTextColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        // Set text to placeholder
        self.inputView.text = self.inputViewPlaceholder;
        self.inputView.textColor = self.inputViewPlaceholderTextColor;
    }
}


// Moving view out of way when keyboard is shown
- (void)keyboardWillShow:(NSNotification*) notification {
    if (self.keyboardIsShowing) {
        return;
    }
    
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (!keyboardFrameValue) {
        NSLog(@"Error getting keyboard frame");
        return;
    }
    
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGFloat yDiff = keyboardFrame.size.height;
    {
        CGRect newFrame = self.sendButton.frame;
        newFrame.origin.y -= yDiff;
        self.sendButton.frame = newFrame;
    }
    {
        CGRect newFrame = self.inputView.frame;
        newFrame.size.height -= yDiff;
        self.inputView.frame = newFrame;
    }
    self.keyboardIsShowing = true;
}

- (void)keyboardWillHide:(NSNotification*) notification {
    if (!self.keyboardIsShowing) {
        return;
    }
    
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (!keyboardFrameValue) {
        NSLog(@"Error getting keyboard frame");
        return;
    }
    
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGFloat yDiff = keyboardFrame.size.height;
    {
        CGRect newFrame = self.sendButton.frame;
        newFrame.origin.y += yDiff;
        self.sendButton.frame = newFrame;
    }
    {
        CGRect newFrame = self.inputView.frame;
        newFrame.size.height += yDiff;
        self.inputView.frame = newFrame;
    }
    self.keyboardIsShowing = false;
}

- (void)shouldDismissKeyboard:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

- (IBAction)sendComment:(UIButton*)sender {
    [self.view endEditing:YES];
    
    
    NSDictionary<NSString*, id>* data = [[NSDictionary<NSString*, id> alloc]
                                         initWithObjects:@[currentUser.email, self.inputView.text, [NSDate now]]
                                         forKeys:@[@"author", @"info", @"creation"]];
    
    __block NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:false block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Data write timeout");
        
        // TODO: add error message and don't dismiss view controller
//        [self dismissViewControllerAnimated:YES completion:nil];
        UIView* errorView = [[UIView alloc] initWithFrame:self.sendButton.frame];
        errorView.backgroundColor = [UIColor systemRedColor];
        errorView.layer.cornerRadius = self.sendButton.layer.cornerRadius;
        errorView.layer.cornerCurve = self.sendButton.layer.cornerCurve;
        
        UILabel* errorLabel = [[UILabel alloc] initWithFrame:self.sendButton.bounds];
        errorLabel.text = @"Couldn't reach database";
        errorLabel.textColor = [UIColor colorNamed:@"appLabelColor"];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.sendButton.superview insertSubview:errorView aboveSubview:self.sendButton];
        [errorView addSubview:errorLabel];
        
        CABasicAnimation* viewFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        viewFadeIn.duration = 0.3;
        viewFadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        viewFadeIn.fromValue = @0;
        viewFadeIn.toValue = @1;
        viewFadeIn.timeOffset = 0;
        
        CABasicAnimation* viewFadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
        viewFadeOut.duration = 0.3;
        viewFadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        viewFadeOut.fromValue = @1;
        viewFadeOut.toValue = @0;
        viewFadeOut.timeOffset = 2.5;
        
        [errorView.layer addAnimation:viewFadeIn forKey:@"fadeIn"];
//        [errorView.layer addAnimation:viewFadeOut forKey:@"fadeOut"];
        [NSTimer scheduledTimerWithTimeInterval:2.8 repeats:false block:^(NSTimer * _Nonnull timer) {
            [errorLabel removeFromSuperview];
            [errorView removeFromSuperview];
        }];
    }];
    
    __block FIRDocumentReference* docref = [self.announcement.comments documentWithAutoID];
    [docref setData:data merge:NO completion:^(NSError * _Nullable error) {
        if (!timer.isValid) return;
        
        [timer invalidate];
        
        if (error) {
            NSLog(@"Error writing data: %@", error.localizedDescription);
            return;
        }
        
        NSLog(@"Successfully written comment info");
        if (self.parentVc.comments.count) {
            Comment* newComment = [[Comment alloc] initWithInfo:data[@"info"] author:data[@"author"] creation:data[@"creation"] replies:nil];
            [self.parentVc.comments insertObject:newComment atIndex:0];
        }
        self.parentVc.shouldLoadComments = true;
        [self.parentVc.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
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
