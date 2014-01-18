//
//  EventListViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  List of events you're attending

#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>

#import "EventListViewController.h"
#import "CreateViewController.h"
#import "SearchViewController.h"

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface EventListViewController ()

@end

@implementation EventListViewController
{
    NSMutableArray* eventKeys;
    NSMutableDictionary* events;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.953 green:0.949 blue:0.949 alpha:1.0];
        
        /* Setting up navigation bar items */
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-gray"]];
        titleImageView.frame = CGRectMake(40, 10, 124, 30);
        [logoView addSubview:titleImageView];
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreateView)];
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"red-search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
        
        self.navigationItem.titleView = logoView;
        self.navigationItem.rightBarButtonItem = createButton;
        self.navigationItem.leftBarButtonItem = searchButton;
        
        /* Set Table Data Source */
        //self.tableView.dataSource = events;//Result of firebase query!
        
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
    
    [self loadAndUpdateEvents:@"ivanw100"];
}

// Loads stored user's events from Firebase
- (void)loadAndUpdateEvents:(NSString *)username {
    NSLog(@"Username: %@", username);
    
    Firebase* eventsRef = [[[self.firebase childByAppendingPath:@"users"] childByAppendingPath:username] childByAppendingPath:@"events"];
    
    [eventsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString* eventKey = snapshot.value;
        NSLog(@"Event ID added: %@", eventKey);
        [self.eventKeys addObject:eventKey];
        
        // Retrieve event from Facebook
        // TODO: retrieve cover photo: ?fields=cover -- "cover" "source"
        [FBRequestConnection startWithGraphPath:[@"/" stringByAppendingString:eventKey]
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  // Store event in events array
                                  [self.events setObject:result forKey:eventKey];
                                  [self.tableView reloadData];
                              }];
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
    CreateViewController *cvc = [[CreateViewController alloc] init];
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)search
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    [self presentViewController:svc animated:YES completion:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Updating cell");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"adrenaline-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"adrenaline-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSMutableDictionary* event = self.events[eventKey];
    NSLog(@"Updating event: %@", event[@"name"]);
    
    //cell.textLabel.text = event[@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.center = CGPointMake(cell.textLabel.center.x - 50, cell.textLabel.center.y);
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
//    [[cell detailTextLabel] setText:event[@"description"]];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [cell detailTextLabel].textColor = [UIColor whiteColor];
    
    // Event title
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
    ttitle.font = [UIFont systemFontOfSize:22];
    ttitle.textColor    = [UIColor whiteColor];
    ttitle.textAlignment = UITextAlignmentLeft;
    [ttitle setText:@"Jogging @ Park"];
    [cell.contentView addSubview:ttitle];
    
    // Date label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 320, 40)];
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textColor    = [UIColor whiteColor];
    dateLabel.textAlignment = UITextAlignmentLeft;
    [dateLabel setText:@"date: 1/14/19"];
    [cell.contentView addSubview:dateLabel];
    
    // Time label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 320, 40)];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor    = [UIColor whiteColor];
    timeLabel.textAlignment = UITextAlignmentLeft;
    [timeLabel setText:@"time: 10:30pm"];
    [cell.contentView addSubview:timeLabel];
    
    // Address 1 label
    UILabel *addrUpperLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 320, 40)];
    addrUpperLabel.font = [UIFont systemFontOfSize:10];
    addrUpperLabel.textColor    = [UIColor whiteColor];
    addrUpperLabel.textAlignment = UITextAlignmentLeft;
    [addrUpperLabel setText:@"3923 Morrison Ave: 10:30pm"];
    [cell.contentView addSubview:addrUpperLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    NSLog(@"Selected event: %@", eventKey);
    // TODO: Navigate to event detail controller
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
