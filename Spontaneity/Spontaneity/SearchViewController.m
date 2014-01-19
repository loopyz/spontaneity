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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.953 green:0.949 blue:0.949 alpha:1.0];
        
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self initNavBarItems];
    }
    return self;
}

- (void)initNavBarItems
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    titleImageView.frame = CGRectMake(30, 10, 124, 30);
    [logoView addSubview:titleImageView];
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreateView)];
    
    self.navigationItem.titleView = logoView;
    self.navigationItem.rightBarButtonItem = createButton;
    
    //make rest of UI bar gray. doesnt work :'(
    UIColor *gray = [UIColor colorWithRed:186/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem.tintColor = gray;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Initialize array that will store events and event keys.
    self.interests = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor clearColor];
    
    [self loadAndUpdateInterests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)openCreateView
{
    CreateViewController *cvc = [[CreateViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

// Loads stored user's interests from Firebase
- (void)loadAndUpdateInterests {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* interestsRef = [[[self.firebase childByAppendingPath:@"users"]
                               childByAppendingPath:username] childByAppendingPath:@"interests"];
    
    [interestsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString* interest = snapshot.name;
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DiningCellIdentifier = @"DiningCell";
    static NSString *BarsCellIdentifier = @"BarsCell";
    static NSString *ClubbingCellIdentifier = @"ClubbingCell";
    static NSString *BakingCellIdentifier = @"BakingCell";
    static NSString *AdrenalineCellIdentifier = @"AdrenalineCell";
    static NSString *BeautyCellIdentifier = @"BeautyCell";
    static NSString *GamesCellIdentifier = @"GamesCell";
    static NSString *ExerciseCellIdentifier = @"ExerciseCell";
    static NSString *PartyCellIdentifier = @"PartyCell";
    
    NSString* interest = [self.interests objectAtIndex:indexPath.row];

    UITableViewCell *cell;
    
    if ([interest isEqual:@"clubbing"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:ClubbingCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ClubbingCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"clubbing-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"beauty"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:BeautyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BarsCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"beauty-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"baking"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:BakingCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BakingCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"baking-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"adrenaline"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:AdrenalineCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AdrenalineCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"adrenaline-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"games"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:GamesCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GamesCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"games-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"parties"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:PartyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PartyCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"parties-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"bars"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:BarsCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BarsCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"bars-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else if ([interest isEqual:@"exercise"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ExerciseCellIdentifier];
            UIImage *bgImg =[UIImage imageNamed:@"exercise-cat-2.png"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
    } else {
        /* Default Cell is Dining */
        cell = [tableView dequeueReusableCellWithIdentifier:DiningCellIdentifier];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DiningCellIdentifier];
        UIImage *bgImg =[UIImage imageNamed:@"dining-cat-2.png"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[bgImg stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.interests count])
        return;
    
    NSString* interest = [self.interests objectAtIndex:indexPath.row];
    NSLog(@"Selected interest: %@", interest);
    
    NSString *imgName = [interest stringByAppendingString:@"-bg.png"];

    SearchedEventsViewController *svc = [[SearchedEventsViewController alloc] initWithNibName:imgName bundle:nil withInterest:interest];
    [self.navigationController pushViewController:svc animated:YES];
    
}

@end
