//
//  PinterestViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//

#import "PinterestViewController.h"

@interface PinterestViewController ()

@end

@implementation PinterestViewController

@synthesize pin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /* Setting up navigation bar items */
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        titleImageView.frame = CGRectMake(40, 10, 124, 30);
        [logoView addSubview:titleImageView];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(exit)];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getThingToBake)];
        
        self.navigationItem.titleView = logoView;
        self.navigationItem.leftBarButtonItem = backButton;
        self.navigationItem.rightBarButtonItem = refreshButton;
        
        /* Background Image */
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        [[UIImage imageNamed:@"baking-bg.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
    }
    return self;
}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getThingToBake
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.pinterest.com/v3/pidgets/boards/pinterest/delicious-eats/pins/"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSError *jsonParsingError = nil;
    NSDictionary *jsonPins = [NSJSONSerialization JSONObjectWithData:response
                                                             options:0 error:&jsonParsingError];
    int randomNum = 0 + arc4random() % (20);
    
    NSDictionary *pins = [[[jsonPins objectForKey:@"data"] objectForKey:@"pins"] objectAtIndex:randomNum];
    NSString *link = [pins objectForKey:@"link"];
    NSString *tmpLink = [@"https://api.pinterest.com/v3/rich_pins/validate/?link=" stringByAppendingString:link];
    NSString *validateLink = [tmpLink stringByAppendingString:@"&access_token=MTQzNTUzOTo0NDgzMTk0NzUzMTQzNDEyMzY6MXwxMzkwMDc5OTU1OjAtLTAxZTFiMjIwZThkNTNlYzRlNmU2MjBlMmVkYjExZmI5YjdlMzhkZGU="];
    
    NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:validateLink]
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                    timeoutInterval:10];
    [req2 setHTTPMethod:@"GET"];
    NSURLResponse *linkResponse = nil;
    NSData *response2 = [NSURLConnection sendSynchronousRequest:req2 returningResponse:&linkResponse error:&requestError];
    NSDictionary *richPin = [NSJSONSerialization JSONObjectWithData:response2 options:0 error:&jsonParsingError];
    
    pin = richPin;
    
    /* Change bg image! */
}

@end
