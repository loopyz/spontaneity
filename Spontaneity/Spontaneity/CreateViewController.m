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

#import <FacebookSDK/FacebookSDK.h>
#import <Firebase/Firebase.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface CreateViewController ()
- (void)addEventsDetailLabel:(NSString*)interest;
@end

@implementation CreateViewController


@synthesize timeLabel;
@synthesize neededLabel;
@synthesize interests;
@synthesize randInterest;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Initialize array that will store events and event keys.
        self.interests = [[NSMutableArray alloc] init];
        
        // Initialize the root of our Firebase namespace.
        self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
        
        self.acceptLocation = false;
        [self loadAndUpdateInterests];
        
        _editTimeClicks = 0;
        _neededPeople = 5;
        _dateTime = [self dateToNearest15Minutes];
        
        locationManager = [[CLLocationManager alloc] init];
        //[self startStandardUpdates];
        
        //creates background image
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        //TODO: randomly generate bg image based off event
        //[self addPlaceLabel];
        [self addTimeLabel];
        [self addInvitedLabel];
        [self addNeededLabel];
        [self addSubmitButton];
        [self addTitle];
        
        
    }
    return self;
}

- (void)startStandardUpdates
{
    self.acceptLocation = true;
    // Create the location manager if this object does not
    // already have one.
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}


- (void)addTitle
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    titleImageView.frame = CGRectMake(30, 10, 124, 30);
    [logoView addSubview:titleImageView];
    self.navigationItem.titleView = logoView;
}

// Loads stored user's interests from Firebase
- (void)loadAndUpdateInterests {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* interestsRef = [[[self.firebase childByAppendingPath:@"users"]
                               childByAppendingPath:username] childByAppendingPath:@"interests"];
    
    [interestsRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // do some stuff once
        
        NSDictionary *interestsDict = snapshot.value;
        
        self.interests = [interestsDict allKeys];
        [self startStandardUpdates];
    }];
}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pinterest
{
    PinterestViewController *pvc = [[PinterestViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)addBackgroundImage:(NSString *)interest
{
    NSString *imageS = [interest stringByAppendingString:@"-bg.png"];
    NSLog(@"Setting background to: %@", imageS);
    [[UIImage imageNamed:imageS] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)addEventsDetailLabel:(NSString*)interest
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    if ([interest isEqualToString:@"adrenaline"]) {
        label.text=@"Be daring!";
    }
    else if ([interest isEqualToString:@"clubbing"]) {
        label.text=@"Go clubbing!";
    }
    else if ([interest isEqualToString:@"baking"]) {
        label.text=@"Go baking!";
    }
    else if ([interest isEqualToString:@"bars"]) {
        label.text=@"Time to drink!";
    }
    else if ([interest isEqualToString:@"dining"]) {
        label.text=@"Grab a bite!";
    }
    else if ([interest isEqualToString:@"parties"]) {
        label.text=@"Can't stop Won't Stop";
    }
    else if ([interest isEqualToString:@"beauty"]) {
        label.text=@"Smile. You're beautiful.";
    }
    else if ([interest isEqualToString:@"exercise"]) {
        label.text=@"Work out time!";
    }
    else if ([interest isEqualToString:@"games"]) {
        label.text=@"You're not too old to play games";
    }
    
    //label.text = @"Event Details";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 50, 1000, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-Oblique" size:30.0];
    
    //adds event details label
    [self.view addSubview:label];
    
}

- (void)addPlaceLabel:(NSString*)place address:(NSArray*)address
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    if ([place length]) {
        label.text = [@"Place: " stringByAppendingString:place];
    }
    
    UILabel *addressLabel = [[UILabel alloc] init];
    
    NSMutableString *s = [[NSMutableString alloc] init];
    for (id obj in address) {
        
        NSString *final = [obj stringByAppendingString:s];
        [s appendString:[obj stringByAppendingString:@"\n"]];
    }
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.text = s;
    
    addressLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    addressLabel.layer.shadowOffset = CGSizeMake(0.0, 0.4);
    addressLabel.layer.shadowOpacity = 1.0;
    
    addressLabel.frame = CGRectMake(80, 116, 400, 100);
    addressLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:11.0];
    
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 80, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:20.0];
    
    //adds event details label
    [self.view addSubview:label];
    [self.view addSubview:addressLabel];
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
    timeLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:20.0];
    
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
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:20.0];
    
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
    neededLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:20.0];
    
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
    NSString *description = [NSString stringWithFormat:@"People needed: %ld. Created by Spontaneity", (long)_neededPeople];
    
    [self createFacebookEvent:_eventName withStartTime:_dateTime andLocation:_location
        andDescription:description];
}

- (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    return [formatter stringFromDate:date];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    [dateFormatter setLocale:enUSPOSIXLocale];
//    [dateFormatter setDateFormat:@"MM-dd'T'HH:mm:ssZZZZZ"];
//    return @"2014-01-25T19:00:00-0700";
//    return [dateFormatter stringFromDate:date];
}

- (void)createFacebookEvent:(NSString *)name withStartTime:(NSDate*)date
                andLocation:(NSString *)location andDescription:(NSString *)description
{
    // NOTE: privacy type defaults to open
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"name",
                            [self dateToString:date], @"start_time",
                            location, @"location",
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
                                  
                                  Firebase* interestRef = [[self.firebase childByAppendingPath:@"events"] childByAppendingPath:self.randInterest];
                                  
                                  [[eventsRef childByAutoId] setValue:result[@"id"]];
                                  [[interestRef childByAutoId] setValue:result[@"id"]];
                                  NSLog(@"Created event %@", result[@"id"]);
                                  
                                  // TODO: test if people like the message
                                  //[appDelegate showMessage:@"Event created!" withTitle:@"Success"];
                                  [self exit];
                                  
                              } else {
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
    // rightmost 15 -> 30 to round up cuz we're spontaneous, but not that spontaneous (let's meet up in 2 min!!?!?)
    [comps setMinute:((([comps minute] - 8 ) / 15 ) * 15 ) + 30];
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
    
    // TODO: fix clubbing photo
    self.view.backgroundColor = [UIColor darkGrayColor];

    _eventName = @"An Adventure";
    _location = @"The Great Unkonwn";
    
	// Do any additional setup after loading the view.
    [self loadAndUpdateInterests];
    
    _editTimeClicks = 0;
    _neededPeople = 5;
    _dateTime = [self dateToNearest15Minutes];
    
    //creates background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    //TODO: randomly generate bg image based off event
    //TODO: What to do with this?
    //[self addEventsDetailLabel:@"beauty"];
    //[self addPlaceLabel];
    [self addTimeLabel];
    [self addInvitedLabel];
    [self addNeededLabel];
    [self addSubmitButton];
    [self addTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshActivity
{
    uint32_t rnd = arc4random_uniform([self.interests count]);
    self.randInterest = [self.interests objectAtIndex:rnd];
    NSLog(@"Random interest: %@", self.randInterest);
    
    [self addBackgroundImage:self.randInterest];
    [self addEventsDetailLabel:self.randInterest];
    
    NSString *url = [NSString stringWithFormat:@"http://www.lucy.ws/yelp.php?term=%@%&ll=%f%@%f", self.randInterest, self.latitude, @",", self.longitude];
    
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
    
    NSArray *businesses = self.jsonItems[@"businesses"];
    id randomObj = businesses[arc4random_uniform([businesses count])];
    NSString *name = randomObj[@"name"];
    NSArray *address = randomObj[@"location"][@"display_address"];
    
    [self addPlaceLabel:name address:address];
    
    _eventName = name;
    _location = [address componentsJoinedByString:@", "];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    
    if (!self.acceptLocation)
    {
        NSLog(@"Die silly race condition!");
        return;
    }
    
    self.acceptLocation = false;

    [locationManager stopUpdatingLocation];
    NSLog(@"Got location!");
    
    self.longitude = newLocation.coordinate.longitude;
    self.latitude = newLocation.coordinate.latitude;
    [self refreshActivity];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Handle error
    NSLog(@"Location error: %@; %@", error.debugDescription, error.description);
}



@end
