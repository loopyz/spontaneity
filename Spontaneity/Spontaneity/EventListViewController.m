//
//  EventListViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  For listing events you've found so you can join them

#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>

#import "EventListViewController.h"
#import "CreateViewController.h"

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
    
    // TODO: implement changed/deleted
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
    
//    [openOrdersRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"Order deleted: %@", snapshot.value);
//        
//        [orders removeObjectForKey:snapshot.name];
//        [orderKeys removeObject:snapshot.name];
//        
//        [self.tableView reloadData];
//    }];
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
    NSLog(@"Search!");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Updating cell");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"adrenaline-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"adrenaline-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSMutableDictionary* event = self.events[eventKey];
    NSLog(@"Updating event: %@", event[@"name"]);
    
    cell.textLabel.text = event[@"name"];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    [[cell detailTextLabel] setText:event[@"description"]];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
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
