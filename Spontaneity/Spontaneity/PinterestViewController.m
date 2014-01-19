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
    [self getThingToBake];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getThingToBake
{
    NSLog(@"Getting thing to bake...");
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
    NSLog(@"%@", pin);
    if ([pin objectForKey:@"data"] != nil) {
        [self updateLabels];
    }
    
}

- (void)updateLabels
{
    NSString *name = [[[[pin objectForKey:@"data"] objectForKey:@"rich_data"] objectForKey:@"recipe"] objectForKey:@"name"];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width, 100.0)];
    title.textAlignment =  NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Helvetica" size:(32)];
    [self.view addSubview:title];
    title.text = name;
    
    NSMutableDictionary *dict = [[[[pin objectForKey:@"data"] objectForKey:@"rich_data"] objectForKey:@"recipe"] objectForKey:@"categorized_ingredients"];
    NSMutableArray *ingredients = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *d in dict) {
        [ingredients addObject:[[[d objectForKey:@"ingredients"] objectAtIndex:0]
                                objectForKey:@"name"]];
    }
    for (int i = 0; i < [ingredients count]; i ++) {
        UILabel *ingrLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(15, 120.0 + i*25, self.view.bounds.size.width, 43.0)];
        ingrLabel.textAlignment =  NSTextAlignmentLeft;
        ingrLabel.textColor = [UIColor whiteColor];
        ingrLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(20.0)];
        [self.view addSubview:ingrLabel];
        ingrLabel.text = [ingredients objectAtIndex:i];
    }
    
    UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pinterest-logo.png"]];
    pinImageView.frame = CGRectMake(self.view.bounds.size.width/2-25, self.view.bounds.size.height - 150, 50, 50);
    [self.view addSubview:pinImageView];
}

@end
