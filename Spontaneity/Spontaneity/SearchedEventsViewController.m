//
//  SearchedEventsViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display query of events you've searched for so you can join them :D

#import "SearchedEventsViewController.h"
#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface SearchedEventsViewController ()

@end

@implementation SearchedEventsViewController

@synthesize firebase;
@synthesize eventKeys;
@synthesize events;
@synthesize interest;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInterest:(NSString *)_interest
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        self.interest = _interest;
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        [[UIImage imageNamed:nibNameOrNil] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize array that will store events and event keys.
    self.events = [[NSMutableDictionary alloc] init];
    self.eventKeys = [[NSMutableArray alloc] init];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    self.tableView.rowHeight = 120;
    
    [self loadAndUpdateEvents];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text {
    [self setupLabel:label forCell:cell withText:text withSize: 12];
}


- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text
          withSize:(int)size {
    [self setupLabel:label forCell:cell withText:text withSize: size
       withAlignment:NSTextAlignmentLeft];
}

- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text
          withSize:(int)size withAlignment:(NSTextAlignment)textAlignment {
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    label.layer.shadowOpacity = 1.0 * pow(22.0 / (double)size, 3.0); // too much work?
    [label setText:text];
    [cell.contentView addSubview:label];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    // TODO: this doesn't seem to work...
    cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSMutableDictionary* event = self.events[eventKey];
    NSLog(@"Updating event: %@", event[@"name"]);
    
    // Event title
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
    int size = 22;
    int length = [event[@"name"] length];
    if (length > 28)
    {
        size = size*28/length;
    }
    
    [self setupLabel:ttitle forCell:cell withText:event[@"name"] withSize:size];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *input = event[@"start_time"];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"]; //iso 8601 format
    NSDate *output = [dateFormat dateFromString:input];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:output];
    [formatter setDateFormat:@"M/d/yy"];
    NSString *date = [formatter stringFromDate:output];
    
    // Date label
    if ([date length]) {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 320, 40)];
        [self setupLabel:dateLabel forCell:cell withText:[@"Date: " stringByAppendingString:date]];
    }
    
    // Time label
    if ([time length]) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 320, 40)];
        [self setupLabel:timeLabel forCell:cell withText:[@"Time: " stringByAppendingString:time]];
    }
    
    // Address 1 label
    NSMutableDictionary *venue = event[@"venue"];
    NSString *street = venue[@"street"];
    NSString *lowerLine = [NSString stringWithFormat:@"%@, %@ %@", venue[@"city"], venue[@"state"], venue[@"zip"]];
    if (!venue[@"city"] || !venue[@"state"] || !venue[@"zip"])
        lowerLine = @"";
    
    if ([street length]) {
        UILabel *addrUpperLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, 320, 40)];
        [self setupLabel:addrUpperLabel forCell:cell withText:street];
    }
    
    // Address 2 label
    if ([lowerLine length]) {
        UILabel *addrLowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320, 40)];
        [self setupLabel:addrLowerLabel forCell:cell withText:lowerLine];
    }
    
    // Number attending label
    NSString *attendees = event[@"attendees"];
    
    UILabel *numAttendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 50, 100, 40)];
    [self setupLabel:numAttendingLabel forCell:cell withText:attendees withSize:28 withAlignment:NSTextAlignmentRight];
    
    UILabel *numAttendingBar = [[UILabel alloc] initWithFrame:CGRectMake(250, 50, 20, 40)];
    [self setupLabel:numAttendingBar forCell:cell withText:@"|" withSize:28];
    
    UILabel *numNeededLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 50, 100, 40)];
    [self setupLabel:numNeededLabel forCell:cell withText:@"10" withSize:28];
    // TODO: un-hardcode later
    
    // Attending label
    UILabel *attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 120, 40)];
    [self setupLabel:attendingLabel forCell:cell withText:@"attending      needed" withSize:10];
    
    return cell;
}

//- (void)populateCell:(int) margin
//{
//    
//    /* Start displaying info */
//    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, margin, self.view.frame.size.width, 45)];
//    name.textAlignment =  NSTextAlignmentLeft;
//    name.textColor = [UIColor whiteColor];
//    name.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
//    name.text = @"Phi Bar"; //TODO: hardcoded
//    [self.view addSubview:name];
//    
//    NSString *dateString = @"01-18-2013 21:30"; //TODO: hardcoded for now!
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM-DD-yyyy HH:mm"];
//    NSDate *tmpDate = [dateFormatter dateFromString:dateString];
//    [dateFormatter setDateFormat:@"MM/DD/yyyy"];
//    NSString *date = [dateFormatter stringFromDate:tmpDate];
//    [dateFormatter setDateFormat:@"HH:mm a"];
//    NSString *time = [dateFormatter stringFromDate:tmpDate];
//    
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, margin+45, self.view.frame.size.width, 15)];
//    dateLabel.textAlignment =  NSTextAlignmentLeft;
//    dateLabel.textColor = [UIColor whiteColor];
//    dateLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
//    dateLabel.text = [NSString stringWithFormat:@"date: %@", date];
//    [self.view addSubview:dateLabel];
//    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, margin+60, self.view.frame.size.width, 15)];
//    timeLabel.textAlignment =  NSTextAlignmentLeft;
//    timeLabel.textColor = [UIColor whiteColor];
//    timeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
//    timeLabel.text = [NSString stringWithFormat:@"time: %@", time];
//    [self.view addSubview:timeLabel];
//    
//    /* People Attending */
//    UILabel *attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120, margin+45, 80, 15)];
//    attendingLabel.textAlignment =  NSTextAlignmentCenter;
//    attendingLabel.textColor = [UIColor whiteColor];
//    attendingLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
//    attendingLabel.text = @"attending";
//    [self.view addSubview:attendingLabel];
//    
//    int numAttending = 5; //TODO: hardcoded
//    UILabel *numAttendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, margin, 40, 45)];
//    numAttendingLabel.textAlignment =  NSTextAlignmentCenter;
//    numAttendingLabel.textColor = [UIColor whiteColor];
//    numAttendingLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
//    numAttendingLabel.text = [NSString stringWithFormat:@"%d", numAttending];
//    [self.view addSubview:numAttendingLabel];
//    
//    /* Dividing bar */
//    /*UIImage *barImg = [UIImage imageNamed:@"vertical-separator.png"];
//     UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 20, 50, 50)];
//     [iv setImage:barImg];
//     [self.view addSubview:iv];*/
//    
//    /* People needed for event to occur */
//    UILabel *requiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, margin+45, 50, 15)];
//    requiredLabel.textAlignment =  NSTextAlignmentCenter;
//    requiredLabel.textColor = [UIColor whiteColor];
//    requiredLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
//    requiredLabel.text = @"required";
//    [self.view addSubview:requiredLabel];
//    
//    int numRequired = 2; //TODO: hardcoded
//    UILabel *numRequiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, margin, 50, 45)];
//    numRequiredLabel.textAlignment =  NSTextAlignmentCenter;
//    numRequiredLabel.textColor = [UIColor whiteColor];
//    numRequiredLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
//    numRequiredLabel.text = [NSString stringWithFormat:@"%d", numRequired];
//    [self.view addSubview:numRequiredLabel];
//}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Loads stored interest events from Firebase
- (void)loadAndUpdateEvents {
    
    Firebase* eventsRef = [[self.firebase childByAppendingPath:@"events"]
                            childByAppendingPath:self.interest];
    
    [eventsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString* eventKey = snapshot.value;
        NSLog(@"Event ID added: %@", eventKey);
        [self.eventKeys addObject:eventKey];
        
        __block NSMutableDictionary* event = [[NSMutableDictionary alloc] init];
        
        // Retrieve event from Facebook
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        
        // First request gets event info
        FBRequest *request1 =
        [FBRequest requestWithGraphPath:[@"/" stringByAppendingString:eventKey]
                             parameters:nil
                             HTTPMethod:@"GET"];
        [connection addRequest:request1
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 event = result;
             }
         }];
        
        // Second request retrieves the attendees count
        NSDictionary* request2Params = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"summary", @"0", @"limit", nil];
        
        FBRequest *request2 =
        [FBRequest requestWithGraphPath: [[@"/" stringByAppendingString:eventKey] stringByAppendingString:@"/attending"]
                             parameters:request2Params
                             HTTPMethod: @"GET"];
        
        [connection addRequest:request2
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 event[@"attendees"] = [[[result objectForKey:@"summary"] objectForKey:@"count"] stringValue];
             }
             
             // Store event in events array
             [self.events setObject:event forKey:eventKey];
             [self.tableView reloadData];
         }];
        
        [connection start];
    }];
    
    // TODO: implement changed
    //    [eventsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
    //        NSLog(@"Event changed: %@", snapshot.name);
    //
    //        NSInteger newVal = [snapshot.value[@"status"] intValue];
    //        if (newVal == 1)
    //        {
    //            [orderKeys removeObject:snapshot.name];
    //        } else if (newVal == 0)
    //        {
    //            NSInteger oldVal = [orders[snapshot.name][@"status"] intValue];
    //            if (oldVal == 1) {
    //                [orderKeys addObject:snapshot.name];
    //            }
    //        }
    //
    //        [self.tableView reloadData];
    //    }];
    
    [eventsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Event deleted: %@", snapshot.value);
        
        [self.events removeObjectForKey:snapshot.value];
        [self.eventKeys removeObject:snapshot.value];
        
        [self.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.eventKeys count])
        return;
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    NSLog(@"Selected event: %@", eventKey);
    NSMutableDictionary *event = self.events[eventKey];
    // TODO: Navigate to event detail controller
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
