//
//  PinterestViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//

#import "PinterestViewController.h"
#import "AppDelegate.h"

#import <Firebase/Firebase.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface PinterestViewController ()

@end

@implementation PinterestViewController

@synthesize pin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Initialize the root of our Firebase namespace.
        self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
        
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
    [self addSubmitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubmitButton
{
    UIImage *createButtonImage = [UIImage imageNamed:@"submit-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(createFacebookEvent)
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = CGRectMake(self.view.frame.size.width/2 - 247.95/2, 480, 247.95, 42.75);
    [button setBackgroundImage:createButtonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    return [formatter stringFromDate:date];
}

- (void)createFacebookEvent
{
    NSString *eventName = [@"Let's get baking! -- " stringByAppendingString:[[[[pin objectForKey:@"data"] objectForKey:@"rich_data"] objectForKey:@"recipe"] objectForKey:@"name"]];
    NSString *description = @"Baking adventures. Created by Spontaneity";
    
    // NOTE: privacy type defaults to open
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            eventName, @"name",
                            [self dateToString:[NSDate date]], @"start_time",
                            @"Your place!", @"location",
                            description, @"description",
                            nil
                            ];
    
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me/events"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                              if (!error && result) {
                                  // Add event to Firebase under user's events and interest category
                                  NSString* username = appDelegate.username;
                                  Firebase* eventsRef = [[[self.firebase childByAppendingPath:@"users"]
                                                          childByAppendingPath:username] childByAppendingPath:@"events"];
                                  
                                  Firebase* interestRef = [[self.firebase childByAppendingPath:@"events"] childByAppendingPath:@"baking"];
                                  
                                  [[eventsRef childByAutoId] setValue:result[@"id"]];
                                  [[interestRef childByAutoId] setValue:result[@"id"]];
                                  NSLog(@"Created event %@", result[@"id"]);
                                  
                                  [self exit];
                                  
                              } else {
                                  [appDelegate showMessage:@"Error creating event, try again later" withTitle:@"Error"];
                              }
                          }];
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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, self.view.bounds.size.width, 100.0)];
    title.text = name;
    title.textAlignment =  NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    
    double size = 28.0;
    int length = [title.text length];
    if (length == 0)
        length = 1;
    if (length > 36)
    {
        size = size*36/length;
    }
    title.font = [UIFont fontWithName:@"Helvetica" size:size];
    [self.view addSubview:title];
    
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
