//
//  SearchViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  For selecting what interest you want to pick events for

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "CreateViewController.h"
#import "SearchedEventsViewController.h"

#import <Firebase/Firebase.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface SearchViewController ()

@end

@implementation SearchViewController
{
    UIButton *bars;
    UIButton *clubbing;
    UIButton *exercise;
    UIButton *sports;
}

@synthesize interests;
@synthesize interestFiles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        /* Setting up navigation bar items */
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-gray"]];
        titleImageView.frame = CGRectMake(40, 10, 124, 30);
        [logoView addSubview:titleImageView];
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreateView)];
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"red-search.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationItem.titleView = logoView;
        self.navigationItem.rightBarButtonItem = createButton;
        self.navigationItem.leftBarButtonItem = searchButton;
        
        /* Some controls */
//        UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
//        swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//        [self.view addGestureRecognizer:swipeUpGestureRecognizer];
//        
//        UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
//        swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
//        [self.view addGestureRecognizer:swipeDownGestureRecognizer];
        
        
        /* Interest Selections */
//        bars = [UIButton buttonWithType:UIButtonTypeCustom];
//        [bars addTarget:self
//                 action:@selector(interestSelected:)
//       forControlEvents:UIControlEventTouchDown];
//        [bars setImage:[UIImage imageNamed:@"bar-cat.png"]
//              forState: UIControlStateNormal];
//        bars.frame = CGRectMake(-2, 20, self.view.frame.size.width+4, 141);
//        [self.view addSubview:bars];
//        
//        clubbing = [UIButton buttonWithType:UIButtonTypeCustom];
//        [clubbing addTarget:self
//                 action:@selector(interestSelected:)
//       forControlEvents:UIControlEventTouchDown];
//        [clubbing setImage:[UIImage imageNamed:@"clubbing-cat.png"]
//              forState: UIControlStateNormal];
//        clubbing.frame = CGRectMake(-2, 156, self.view.frame.size.width+4, 141);
//        [self.view addSubview:clubbing];
//        
//        exercise = [UIButton buttonWithType:UIButtonTypeCustom];
//        [exercise addTarget:self
//                     action:@selector(interestSelected:)
//           forControlEvents:UIControlEventTouchDown];
//        [exercise setImage:[UIImage imageNamed:@"exercise-cat.png"]
//                  forState: UIControlStateNormal];
//        exercise.frame = CGRectMake(-2, 292, self.view.frame.size.width+4, 141);
//        [self.view addSubview:exercise];
//        
//        sports = [UIButton buttonWithType:UIButtonTypeCustom];
//        [sports addTarget:self
//                     action:@selector(interestSelected:)
//           forControlEvents:UIControlEventTouchUpInside];
//        [sports setImage:[UIImage imageNamed:@"sports-cat.png"]
//                  forState: UIControlStateNormal];
//        sports.frame = CGRectMake(-2, 429, self.view.frame.size.width+4, 143);
//        [self.view addSubview:sports];
        
        /* Exit button */
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton addTarget:self
                       action:@selector(exit)
             forControlEvents:UIControlEventTouchDown];
        [exitButton setImage:[UIImage imageNamed:@"close-button-2.png"]
                    forState: UIControlStateNormal];
        exitButton.frame = CGRectMake(self.view.bounds.size.width-40, 30, 30, 30);
        [self.view addSubview:exitButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor blackColor];
    
    // Initialize array that will store events and event keys.
    self.interests = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [self loadAndUpdateInterests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCreateView
{
    CreateViewController *cvc = [[CreateViewController alloc] init];
    [self presentViewController:cvc animated:YES completion:nil];
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
        [self.tableView reloadData];
    }];
    
    [interestsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Interest deleted: %@", snapshot.name);
        
        [self.interests removeObject:snapshot.name];
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.interests count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
    
    NSString* interest = [self.interests objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSLog(@"Updating interest: %@", interest);
    
    UIImage *bgImg =[UIImage imageNamed:[interest stringByAppendingString:@"-cat.png"]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.interests count])
        return;
    
    NSString* interest = [self.interests objectAtIndex:indexPath.row];
    NSLog(@"Selected interest: %@", interest);
    
    NSString *imgName = @"bars-bg-2.png";
    if ([interest isEqual: @"clubbing"]) {
        imgName = @"clubbing-bg-2.png";
    } else if ([interest isEqual: @"bars"]) {
        imgName = @"bars-bg.png";
    } else if ([interest isEqual: @"exercise"]) {
        imgName = @"create-bg-2.png";
    }
    SearchedEventsViewController *svc = [[SearchedEventsViewController alloc] initWithNibName:imgName bundle:nil];
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)interestSelected:(id)sender
{
    
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    NSLog(@"up swipe!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    NSLog(@"down swipe!");
    //TODO: load other interest thingies
}

@end
