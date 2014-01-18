//
//  CreateViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  Event Details Screen
//

#import "AppDelegate.h"
#import "CreateViewController.h"
#import "PinterestViewController.h"
#import "AppDelegate.h"


#import <Firebase/Firebase.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface CreateViewController ()

@end

@implementation CreateViewController


@synthesize timeLabel;
@synthesize neededLabel;
@synthesize interests;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _editTimeClicks = 0;
        _neededPeople = 5;
        
        locationManager = [[CLLocationManager alloc] init];
        [self startStandardUpdates];
        
        //creates background image
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        //TODO: randomly generate bg image based off event
        [self addBackgroundImage];
        [self addEventsDetailLabel];
        [self addPlaceLabel];
        [self addTimeLabel];
        [self addInvitedLabel];
        [self addNeededLabel];
        [self addSubmitButton];
        
        /* Exit button */
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton addTarget:self
                       action:@selector(exit)
             forControlEvents:UIControlEventTouchDown];
        [exitButton setImage:[UIImage imageNamed:@"close-button-2.png"]
                    forState: UIControlStateNormal];
        exitButton.frame = CGRectMake(self.view.bounds.size.width-40, 30, 30, 30);
        [self.view addSubview:exitButton];
        
        /* Test Button for Pinterest */
        UIButton *pinterest = [UIButton buttonWithType:UIButtonTypeCustom];
        [pinterest addTarget:self
                       action:@selector(pinterest)
             forControlEvents:UIControlEventTouchDown];
        [pinterest setImage:[UIImage imageNamed:@"close-button-2.png"]
                    forState: UIControlStateNormal];
        pinterest.frame = CGRectMake(self.view.bounds.size.width-40, 70, 30, 30);
        [self.view addSubview:pinterest];
        
        
    }
    return self;
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}


// Loads stored user's interests from Firebase
- (void)loadAndUpdateInterests {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* interestsRef = [[[self.firebase childByAppendingPath:@"users"]
                               childByAppendingPath:username] childByAppendingPath:@"interests"];
    
    [interestsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString* interest = snapshot.name;
        NSLog(@"Interest added: %@", interest);
        [self.interests addObject:interest];
    }];
    
    [interestsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Interest deleted: %@", snapshot.name);
        
        [self.interests removeObject:snapshot.name];

    }];
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinterest
{
    PinterestViewController *pvc = [[PinterestViewController alloc] init];
    [self presentViewController:pvc animated:YES completion:nil];

}

- (void)addBackgroundImage
{
    [[UIImage imageNamed:@"clubbing-bg-2.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)addEventsDetailLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    label.text = @"Event Details";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 50, 1000, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-Oblique" size:35.0];
    
    //adds event details label
    [self.view addSubview:label];
    
}

- (void)addPlaceLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    label.text = @"Place: ";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 100, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //adds event details label
    [self.view addSubview:label];
}

- (void)addTimeLabel
{
    timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString *newTime = [timeFormatter stringFromDate:[self dateToNearest15Minutes]];
    
    timeLabel.text = [@"Time: " stringByAppendingString:newTime];
    
    //creates shadow
    timeLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    timeLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    timeLabel.layer.shadowOpacity = 1.0;
    
    //create frame for text
    timeLabel.frame = CGRectMake(20, 170, 400, 100);
    
    //set font style/text
    timeLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //add up and down arrows
    [self addTimeArrowButtons:220 y:170];
    
    //adds event details label
    [self.view addSubview:timeLabel];
    
}

- (void)addInvitedLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    label.text = @"Invited: ";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 240, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //adds event details label
    [self.view addSubview:label];
}

- (void)addNeededLabel
{
    neededLabel = [[UILabel alloc] init];
    neededLabel.textColor = [UIColor whiteColor];
    
    //take number from the invited section
    int people = 5;
    
    neededLabel.text = [@"Needed: " stringByAppendingString:[NSString stringWithFormat:@"%d", people]];
    
    
    //creates shadow
    neededLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    neededLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    neededLabel.layer.shadowOpacity = 1.0;
    
    //create frame for text
    neededLabel.frame = CGRectMake(20, 310, 400, 100);
    
    //set font style/text
    neededLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //add up and down arrows
    [self addNeededArrowButtons:220 y:310];
    
    //adds event details label
    [self.view addSubview:neededLabel];
}

- (void)addSubmitButton
{
    UIImage *createButtonImage = [UIImage imageNamed:@"submit-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(submitNewEvent:)
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = CGRectMake(self.view.frame.size.width/2 - 247.95/2, 450, 247.95, 42.75);
    [button setBackgroundImage:createButtonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

- (void)submitNewEvent:(id)sender
{
    NSLog(@"Submitted a new event!");
    [self createFacebookEvent:_eventName withStartTime:_dateTime andLocation:_location];
}

- (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:date];
}

- (void)createFacebookEvent:(NSString *)name withStartTime:(NSDate*)date
                andLocation:(NSString *)location
{
    // TODO: add needed
    
    // NOTE: privacy type defaults to open
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"name",
                            [self dateToString:date], @"start_time",
                            location, @"location",
                            @"Created by Spontaneity", @"description",
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
                              /* handle the result */
                              AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                              if (!error && result)
                              {
                                  // TODO: add to Firebase
                                  
                                  [appDelegate showMessage:@"Event created!" withTitle:@"Success"];
                              } else
                              {
                                  [appDelegate showMessage:@"Error creating event, try again later" withTitle:@"Error"];
                              }
                          }];
}


- (void)addTimeArrowButtons:(int)x y:(int)y
{
    //creates up button
    UIImage *createUpButtonImage = [UIImage imageNamed:@"up-arrow.png"];
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upButton addTarget:self
                 action:@selector(addTimeClicks)
       forControlEvents:UIControlEventTouchDown];
    
    upButton.frame = CGRectMake(x, y+33, 33.6, 17.6);
    [upButton setBackgroundImage:createUpButtonImage forState:UIControlStateNormal];
    
    //creates down button
    UIImage *createDownButtonImage = [UIImage imageNamed:@"down-arrow.png"];
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downButton addTarget:self
                   action:@selector(subTimeClicks)
         forControlEvents:UIControlEventTouchDown];
    
    downButton.frame = CGRectMake(x, y+63, 33.62, 17.6);
    [downButton setBackgroundImage:createDownButtonImage forState:UIControlStateNormal];
    
    
    [self.view addSubview:upButton];
    [self.view addSubview:downButton];
}

- (void)addNeededArrowButtons:(int)x y:(int)y
{
    //creates up button
    UIImage *createUpButtonImage = [UIImage imageNamed:@"up-arrow.png"];
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upButton addTarget:self
                 action:@selector(addPeopleClicks)
       forControlEvents:UIControlEventTouchDown];
    
    upButton.frame = CGRectMake(x, y+33, 33.6, 17.6);
    [upButton setBackgroundImage:createUpButtonImage forState:UIControlStateNormal];
    
    //creates down button
    UIImage *createDownButtonImage = [UIImage imageNamed:@"down-arrow.png"];
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downButton addTarget:self
                   action:@selector(subPeopleClicks)
         forControlEvents:UIControlEventTouchDown];
    
    downButton.frame = CGRectMake(x, y+63, 33.62, 17.6);
    [downButton setBackgroundImage:createDownButtonImage forState:UIControlStateNormal];
    
    
    [self.view addSubview:upButton];
    [self.view addSubview:downButton];
}

- (NSDate *)dateToNearest15Minutes {
    // Set up flags.
    unsigned unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit;
    // Extract components.
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    // Set the minute to the nearest 15 minutes.
    [comps setMinute:((([comps minute] - 8 ) / 15 ) * 15 ) + 15];
    // Zero out the seconds.
    [comps setSecond:0];
    // Construct a new date.
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)editTime
{
    
    NSDateComponents *changeComponent = [[NSDateComponents alloc] init];
    changeComponent.second = 60 * 15 * _editTimeClicks;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *newDate = [theCalendar dateByAddingComponents:changeComponent toDate:[self dateToNearest15Minutes] options:0];
    
    _dateTime = newDate;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString *newTime = [timeFormatter stringFromDate:newDate];
    
    timeLabel.text = [@"Time: " stringByAppendingString:newTime];
}

- (void)editPeople:(int)p
{
    _neededPeople += p;
    neededLabel.text = [@"Needed: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)_neededPeople]];
}

- (void)addTimeClicks
{
    _editTimeClicks++;
    [self editTime];
}

- (void)subTimeClicks
{
    _editTimeClicks--;
    [self editTime];
}

- (void)addPeopleClicks
{
    [self editPeople:1];
}

- (void)subPeopleClicks
{
    [self editPeople:-1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize array that will store events and event keys.
    self.interests = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [self loadAndUpdateInterests];
    
    printf("%s", "end of didload");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshActivity
{
    uint32_t rnd = arc4random_uniform([self.interests count]);
    NSString* randInterest = [self.interests objectAtIndex:rnd];
    NSString *url = [NSString stringWithFormat:@"http://www.lucy.ws/yelp.php?term=%@%&ll=%f%@%f", randInterest, self.latitude, @",",self.longitude];
    
    NSLog(@"%@", url);
    
    //doing dat json stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSError *jsonParsingError = nil;
    self.jsonItems = [NSJSONSerialization JSONObjectWithData:response
                                                     options:0 error:&jsonParsingError];
    
    
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    //generate random interest
    int numInterests = [interests count];
    
    if (numInterests > 0) {
        self.longitude = newLocation.coordinate.longitude;
        self.latitude = newLocation.coordinate.latitude;
        [self refreshActivity];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Handle error
    printf("%s", "woof");
}



@end
