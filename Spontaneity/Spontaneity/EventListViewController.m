//
//  EventListViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  List of events you're attending

#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "EventListViewController.h"
#import "CreateViewController.h"
#import "SearchViewController.h"
#import "UIImage+ImageEffects.h"

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface EventListViewController ()

@end

@implementation EventListViewController

@synthesize eventKeys;
@synthesize events;

- (IBAction)logoutButtonTouched:(id)sender
{
    NSLog(@"Logout initiated.");
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.953 green:0.949 blue:0.949 alpha:1.0];
        
        /* Setting up navigation bar items */
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        titleImageView.frame = CGRectMake(30, 10, 124, 30);
        [logoView addSubview:titleImageView];
        
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = CGRectMake(50,0,100,50);
        [logoutButton addTarget:self action:@selector(logoutButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [logoView addSubview:logoutButton];
        
        
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreateView)];
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"red-search-small.png"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
        UIColor *gray = [UIColor colorWithRed:186/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getThingToBake)];
        
        [searchButton setTintColor:gray];
        [createButton setTintColor:gray];
        
        //make rest of UI bar gray. doesnt work :'(
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
//         setTitleTextAttributes:[NSDictionary
//                                 dictionaryWithObjectsAndKeys:gray, NSForegroundColorAttributeName,nil]
//         forState:UIControlStateNormal];
//        
//        [[self.navigationController.navigationBar.subviews lastObject] setTintColor:gray];
//        self.navigationController.navigationBar.tintColor =  gray;



        
        self.navigationItem.titleView = logoView;
        self.navigationItem.rightBarButtonItem = createButton;
        self.navigationItem.leftBarButtonItem = searchButton;
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // Initialize array that will store events and event keys.
    self.events = [[NSMutableDictionary alloc] init];
    self.eventKeys = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor blackColor];

}

// Loads stored user's events from Firebase
- (void)loadAndUpdateEvents {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* eventsRef = [[[self.firebase childByAppendingPath:@"users"] childByAppendingPath:username] childByAppendingPath:@"events"];
    
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
                 
                 // Store needed
                 NSString *description = event[@"description"];
                 NSRegularExpression *regex = [NSRegularExpression
                                               regularExpressionWithPattern:@"People needed: (\\d+)\\." options:0 error:NULL];
                 NSTextCheckingResult *match = [regex firstMatchInString:description options:0 range:NSMakeRange(0, [description length])];
                 if ([match numberOfRanges] > 0)
                 {
                     event[@"needed"] = [description substringWithRange:[match rangeAtIndex:1]];
                 } else
                 {
                     //NSLog(@"Could not find people needed in %@!", event[@"name"]);
                     event[@"needed"] = @"1";
                 }
                 
                 // Store formatted date and time
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 NSString *input = event[@"start_time"];
                 [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"]; //iso 8601 format
                 NSDate *output = [dateFormat dateFromString:input];
                 
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"h:mm a"];
                 if (event[@"start_time"])
                     event[@"time_formatted"] = [@"Time: " stringByAppendingString:[formatter stringFromDate:output]];
                 else
                     event[@"time_formatted"] = @"";
                 [formatter setDateFormat:@"M/d/yy"];
                 
                 if (event[@"start_time"] != Nil)
                     event[@"date_formatted"] = [@"Date: " stringByAppendingString:[formatter stringFromDate:output]];
                 else
                     event[@"date_formatted"] = @"";
                 
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
         }];
        
        // Third request retrieves the cover photo
        NSDictionary* request3Params = [[NSDictionary alloc] initWithObjectsAndKeys: @"cover", @"fields", nil];
        
        FBRequest *request3 =
        [FBRequest requestWithGraphPath: [@"/" stringByAppendingString:eventKey]
                            parameters:request3Params
                            HTTPMethod: @"GET"];
        
        [connection addRequest:request3
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 event[@"coverPhoto"] = [result objectForKey:@"cover"] ? [[result objectForKey:@"cover"] objectForKey:@"source"] : @"";
             }
             
             if (!event || !event[@"name"]) {
                 [[snapshot ref] removeValue];
                 [self.eventKeys removeObject:eventKey];
             } else {
                 // Store event in events array
                 event[@"ref"] = [snapshot ref];
                 [self.events setObject:event forKey:eventKey];
             }
             
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCreateView
{
    CreateViewController *cvc;
    cvc = [[CreateViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)search
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    svc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:svc animated:YES];
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

- (UIImage *)randomBgImg
{
    NSArray* bgs = @[@"adrenaline-bg.png",
      @"clubbing-bg.png",
      @"baking-bg.png",
      @"bars-bg.png",
      @"dining-bg.png",
      @"parties-bg.png",
      @"beauty-bg.png",
      @"exercise-bg.png",
      @"games-bg.png"];
    
    return [UIImage imageNamed:bgs[arc4random() % [bgs count]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    } else
    {
        // Clear old labels
        for (UIView *v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]])
                [v removeFromSuperview];
        }
    }
    
    //blurred images yayyy
//    UIImage *bg = [[UIImage imageNamed:@"adrenaline-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0];
//    UIImage *blurredbg = [bg applyDarkEffect];
    
    
//    cell.backgroundView = [[UIImageView alloc] initWithImage:blurredbg];
//    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage: blurredbg];
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSMutableDictionary* event = self.events[eventKey];
    if (!event)
    {
        NSLog(@"Event not found: %@!", eventKey);
        return cell;
    }
    
    NSLog(@"Updating event: %@", event[@"name"]);
    
    NSURL *url = [NSURL URLWithString:event[@"coverPhoto"]];
    
    if (!url || !url.path)
        NSLog(@"No cover photo for %@", event[@"name"]);
    
    // TODO: pick more generic cover photo
    UIImage *bgImg = url && url.path ? [[UIImage alloc] initWithData:[[NSData alloc]initWithContentsOfURL:url]] : [self randomBgImg];
    UIImage *blurredbg = [bgImg applyDarkEffect];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[blurredbg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[blurredbg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    // Event title
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
    int size = 22;
    int length = [event[@"name"] length];
    if (length > 28)
    {
        size = size*28/length;
    }
    
    [self setupLabel:ttitle forCell:cell withText:event[@"name"] withSize:size];
    

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 320, 40)];
    [self setupLabel:dateLabel forCell:cell withText:event[@"date_formatted"]];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 320, 40)];
    [self setupLabel:timeLabel forCell:cell withText:event[@"time_formatted"]];
    
    // Address 1 label
    NSMutableDictionary *venue = event[@"venue"];
    NSString *street = venue[@"street"];
    
    NSString *cityState = @"";
    
    if (venue[@"name"])
        cityState = [venue[@"name"] stringByAppendingString:@"\n"];
    
    if ([venue[@"city"] length] && [venue[@"state"] length])
        cityState = [NSString stringWithFormat:@"%@%@, %@", cityState, venue[@"city"], venue[@"state"]];
    else if ([venue[@"city"] length])
        cityState = [cityState stringByAppendingString:venue[@"city"]];
    else if ([venue[@"state"] length])
        cityState = [cityState stringByAppendingString:venue[@"state"]];
    
    NSString *lowerLine;
    if ([cityState length] && [venue[@"zip"] length])
        lowerLine = [NSString stringWithFormat:@"%@ %@", cityState, venue[@"zip"]];
    else if ([venue[@"zip"] length])
        lowerLine = venue[@"zip"];
    else if ([cityState length])
        lowerLine = cityState;
    
    
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
    [self setupLabel:numNeededLabel forCell:cell withText:event[@"needed"] withSize:28];
    
    // Attending label
    UILabel *attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 120, 40)];
    [self setupLabel:attendingLabel forCell:cell withText:@"attending      needed" withSize:10];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row >= [self.eventKeys count])
    //    return;
    
    //NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    //NSMutableDictionary *event = self.events[eventKey];
    // TODO: Navigate to event detail controller
}

// Allow deleting of rows by swipe
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    [self.events[eventKey][@"ref"] removeValue];
    [self.events removeObjectForKey:eventKey];
    [self.eventKeys removeObject:eventKey];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end
