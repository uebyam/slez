//
//  IdeaWriteCommentViewController.m
//  SLEZ
//
//  Created by rey on 18/9/22.
//

#import "IdeaWriteCommentViewController.h"

CGFloat getCGRectBottom(CGRect r) {
    return r.origin.y + r.size.height;
}

CGFloat getCGRectTop(CGRect r) {
    return r.origin.y;
}

CGFloat getCGRectLeft(CGRect r) {
    return r.origin.x;
}

CGFloat getCGRectRight(CGRect r) {
    return r.origin.x + r.size.width;
}

@interface IdeaWriteCommentViewController ()

@end

@implementation IdeaWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    self.parentVc = (IdeaBoardDiscussionViewController*)self.presentingViewController;
    
    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDismissKeyboard:)];
    [self.view addGestureRecognizer:gr];
    
    self.placeholderColor = UIColor.grayColor;
    self.placeholderText = @"Type a comment...";
    self.mainColor = [UIColor colorNamed:@"appLabelColor"];
    
    self.inputView.text = self.placeholderText;
    self.inputView.textColor = self.placeholderColor;
    self.inputView.delegate = self;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.contentYInset = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    CGFloat titleLabelHeight = 21;
    CGFloat sendButtonHeight = 35;
    CGRect vf = self.view.safeAreaLayoutGuide.layoutFrame;
    
    self.titleLabel.frame = CGRectMake(16, 20, vf.size.width - 32, titleLabelHeight);
    self.sendButton.frame = CGRectMake(32, getCGRectBottom(vf) - sendButtonHeight - 20,
                                       vf.size.width - 64, sendButtonHeight);
    self.inputView.frame = CGRectMake(16, getCGRectBottom(self.titleLabel.frame) + 8,
                                      vf.size.width - 32, getCGRectTop(self.sendButton.frame) - 8 - getCGRectBottom(self.titleLabel.frame) - 8);
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
    CGFloat newContentYInset = keyboardFrame.size.height;
    {
        CGRect newFrame = self.inputView.frame;
        newFrame.size.height -= newContentYInset - self.contentYInset;
        self.inputView.frame = newFrame;
    }
    {
        CGRect newFrame = self.sendButton.frame;
        newFrame.origin.y -= newContentYInset - self.contentYInset;
        self.sendButton.frame = newFrame;
    }
    
    self.contentYInset = newContentYInset;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGFloat newContentYInset = 0;
    {
        CGRect newFrame = self.inputView.frame;
        newFrame.size.height -= newContentYInset - self.contentYInset;
        self.inputView.frame = newFrame;
    }
    {
        CGRect newFrame = self.sendButton.frame;
        newFrame.origin.y -= newContentYInset - self.contentYInset;
        self.sendButton.frame = newFrame;
    }
    
    self.contentYInset = newContentYInset;
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification {
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
    CGFloat newContentYInset = keyboardFrame.size.height;
    {
        CGRect newFrame = self.inputView.frame;
        newFrame.size.height -= newContentYInset - self.contentYInset;
        self.inputView.frame = newFrame;
    }
    {
        CGRect newFrame = self.sendButton.frame;
        newFrame.origin.y -= newContentYInset - self.contentYInset;
        self.sendButton.frame = newFrame;
    }
    
    self.contentYInset = newContentYInset;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual:self.placeholderColor]) {
        textView.text = @"";
        textView.textColor = self.mainColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = self.placeholderText;
        textView.textColor = self.placeholderColor;
    }
}

- (void)shouldDismissKeyboard:(UIButton*)sender {
    [self.view endEditing:true];
}

- (IBAction)sendButtonPressed:(UIButton*)sender {
    NSLog(@"Sending comment...");
    [self shouldDismissKeyboard:sender];
    
    FIRDocumentReference* ref = [self.idea.comments documentWithAutoID];
    NSDictionary<NSString*, id>* data = [NSDictionary dictionaryWithObjects:@[self.inputView.text, currentUser.email, NSDate.now] forKeys:@[@"info", @"author", @"creation"]];
    
    __block IdeaComment* c = [[IdeaComment alloc] initWithInfo:data[@"info"] author:data[@"author"] creation:data[@"creation"] replies:[ref collectionWithPath:@"replies"]];
    
    [ref setData:data merge:false completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending comment: %@", error);
            return;
        }
        NSLog(@"Sent comment successfully");
        if (self.parentVc.comments.count) {
            [self.parentVc.comments insertObject:c atIndex:0];
        }
        self.parentVc.shouldLoadComments = true;
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
