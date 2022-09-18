//
//  ViewController.m
//  SLEZ
//
//  Created by rey on 24/8/22.
//

#import "SignInViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)viewDidAppear:(BOOL)animated {
    self.signInContainer.layer.cornerRadius = self.signInContainer.frame.size.width / 2;
    self.signInContainer.layer.cornerCurve = kCACornerCurveCircular;
}


- (NSMutableArray<NSNumber*>*)getArrayFromCGRect:(CGRect)rect {
    double rx = rect.origin.x + 0.0001, ry = rect.origin.y + 0.0001, rw = rect.size.width + 0.0001, rh = rect.size.height + 0.0001;
    NSMutableArray* arr = [@[[NSNumber numberWithDouble:rx], [NSNumber numberWithDouble:ry], [NSNumber numberWithDouble:rw], [NSNumber numberWithDouble:rh]] mutableCopy];
    return arr;
}


- (IBAction)signIn:(UITapGestureRecognizer *)sender {
    GIDConfiguration *config = [[GIDConfiguration alloc] initWithClientID:[FIRApp defaultApp].options.clientID];
    [GIDSignIn.sharedInstance signInWithConfiguration:config presentingViewController:self callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            switch (error.code) {
                case kGIDSignInErrorCodeCanceled: NSLog(@"User cancelled sign in"); break;
                default:
                    NSLog(@"Error signing in: %@", error);
                    break;
            }
            return;
        }
        
        GIDAuthentication* auth = user.authentication;
        FIRAuthCredential* cred = [FIRGoogleAuthProvider credentialWithIDToken:auth.idToken
                                                                   accessToken:auth.accessToken];
        [defaultAuth signInWithCredential:cred completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error occurred signing in: %@", error);
            } else {
                currentUser = authResult.user;
                NSLog(@"Signed in as %@ (email verified: %d)", currentUser.email, currentUser.emailVerified);
                [self performSegueWithIdentifier:@"loginToMainMenu" sender:self];
            }
        }];
        
    }];
    
    
    
    /*
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    printf("Signing in with username: %s, password: %s\n", username.UTF8String, password.UTF8String);
    [FIRAuth.auth signInWithEmail:username password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        currentUser = authResult.user;
        NSLog(@"logged in: %@", currentUser.uid);
        
        [self performSegueWithIdentifier:@"loginToMainMenu" sender:self];
    }];
     */
}

- (IBAction)signUp:(UIButton *)sender {
    printf("Signing up with username: %s, password: %s\n", self.usernameTextField.text.UTF8String, self.passwordTextField.text.UTF8String);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

@end
