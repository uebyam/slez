//
//  AnnouncementPostViewController.m
//  SLEZ
//
//  Created by rey on 16/9/22.
//

#import "AnnouncementPostViewController.h"

@interface AnnouncementPostViewController ()

@end

@implementation AnnouncementPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    
    UITapGestureRecognizer* dismissKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismissKeyboard:)];
    [self.view addGestureRecognizer:dismissKeyboardGestureRecognizer];
    
    self.placeholderTextColor = UIColor.grayColor;
    self.mainTextColor = [UIColor colorNamed:@"appLabelColor"];
    self.inputViewPlaceholder = @"Type an announcement...";
    self.titleInputViewPlaceholder = @"Type a title...";
    
    self.inputView.textColor = self.placeholderTextColor;
    self.inputView.text = self.inputViewPlaceholder;
    self.titleInputView.textColor = self.placeholderTextColor;
    self.titleInputView.text = self.titleInputViewPlaceholder;
    
    self.inputView.delegate = self;
    self.titleInputView.delegate = self;
    
    self.keyboardIsShowing = false;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.parentVc = (AnnouncementsViewController*)self.presentingViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    // "constraints" :thonk:
    CGRect vf = self.view.frame;
    CGFloat titleLabelHeight = 29;
    CGFloat sendButtonHeight = 35;
    CGFloat importantHeight = 31;
    CGFloat titleInputViewHeight = 58;
    
    self.titleLabel.frame = CGRectMake(16, 20, vf.size.width - 32, titleLabelHeight);
    self.sendButton.frame = CGRectMake(16, vf.size.height - 20 - sendButtonHeight, vf.size.width - 32, sendButtonHeight);
    self.importantLabel.frame = CGRectMake(16, self.titleLabel.frame.origin.y + titleLabelHeight + 8, self.importantLabel.frame.size.width, importantHeight);
    self.importantSwitch.frame = CGRectMake(self.importantLabel.frame.origin.x + self.importantLabel.frame.size.width + 8, self.titleLabel.frame.origin.y + titleLabelHeight + 8, self.importantSwitch.frame.size.width, importantHeight);
    self.titleInputView.frame = CGRectMake(16, self.importantLabel.frame.origin.y + importantHeight + 8, vf.size.width - 32, titleInputViewHeight);
    self.inputView.frame = CGRectMake(16, self.titleInputView.frame.origin.y + titleInputViewHeight + 8, vf.size.width - 32, self.sendButton.frame.origin.y - self.titleInputView.frame.origin.y - titleInputViewHeight - 16);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual:self.placeholderTextColor]) {
        if (textView.tag == 0) {
            if ([textView.text isEqualToString:self.titleInputViewPlaceholder]) {
                textView.text = @"";
                textView.textColor = self.mainTextColor;
            }
        } else {
            if ([textView.text isEqualToString:self.inputViewPlaceholder]) {
                textView.text = @"";
                textView.textColor = self.mainTextColor;
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        if (textView.tag == 0) {
            // Set text to placeholder
            textView.text = self.titleInputViewPlaceholder;
        } else {
            // Set text to placeholder
            textView.text = self.inputViewPlaceholder;
        }
        textView.textColor = self.placeholderTextColor;
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
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

- (void)keyboardWillHide:(NSNotification*)notification {
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

- (IBAction)postAnnouncement:(UIButton*)sender {
    [self.view endEditing:YES];
    
    FIRCollectionReference* announcementsRef = [defaultFirestore collectionWithPath:@"/announcements"];
    FIRDocumentReference* announcementRef = [announcementsRef documentWithAutoID];
    
    NSDictionary<NSString*, id>* data = [NSDictionary
                                         dictionaryWithObjects:@[currentUser.email, self.titleInputView.text, self.inputView.text, [NSDate now], [NSNumber numberWithBool:self.importantSwitch.on]]
                                         forKeys:@[@"author", @"title", @"info", @"creation", @"important"]];
    
    __block Announcement* newAnnouncement = [[Announcement alloc] initWithTitle:data[@"title"] info:data[@"info"] creation:data[@"creation"] author:data[@"author"] comments:[announcementRef collectionWithPath:@"discussion"] important:((NSNumber*)data[@"important"]).boolValue];
    
    [announcementRef setData:data merge:NO completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed writing announcement: %@", error);
            return;
        }
        
        NSLog(@"Successfully posted announcement");
        if (self.parentVc.announcements.count) {
            [self.parentVc.announcements insertObject:newAnnouncement atIndex:0];
        }
        self.parentVc.shouldLoadAnnouncements = true;
        [self.parentVc.tableView reloadData];
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
