//
//  LoginViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  View Controller for App Launch and Facebook Login
//

#import <FacebookSDK/FacebookSDK.h>

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
- (IBAction)buttonClicked:(id)sender;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    imgView.image = [UIImage imageNamed:@"a_image.png"];
    
	// Do any additional setup after loading the view.
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"Show View" forState:UIControlStateNormal];

    self.loginButton.frame = CGRectMake((self.view.frame.size.width - 263)/2, 140, 263, 52);
    [self.loginButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"facebook.png"];
    [self.loginButton setImage:btnImage forState:UIControlStateNormal];
    self.loginButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:self.loginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
