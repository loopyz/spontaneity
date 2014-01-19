//
//  JoinEventViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display details about a selected event and option to join

#import "AppDelegate.h"
#import "JoinEventViewController.h"

#import <Firebase/Firebase.h>

#define firebaseURL @"https://spontaneity.firebaseio.com/"

@interface JoinEventViewController ()

@end

@implementation JoinEventViewController

@synthesize event;

- (id)initWithEvent:(NSDictionary *)event
{
    self.event = event;
    return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize the root of our Firebase namespace.
        self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
        
        [self addBackgroundImage:self.event[@"interest"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addJoinButton];
}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addBackgroundImage:(NSString *)interest
{
    NSString *imageS = [interest stringByAppendingString:@"-bg.png"];
    NSLog(@"Setting background to: %@", imageS);
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageS] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)joinEvent:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* eventsRef = [[[self.firebase childByAppendingPath:@"users"]
                               childByAppendingPath:username] childByAppendingPath:@"events"];
    [[eventsRef childByAutoId] setValue:self.event[@"id"]];
    
    [self exit];
}

- (void)addJoinButton
{
    UIImage *createButtonImage = [UIImage imageNamed:@"join-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(joinEvent:)
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = CGRectMake(self.view.frame.size.width/2 - 247.95/2, 450, 247.95, 42.75);
    [button setBackgroundImage:createButtonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
