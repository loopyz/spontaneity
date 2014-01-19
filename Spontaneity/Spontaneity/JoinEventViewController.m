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
    [self addLabels];
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

- (void)setupLabel:(UILabel *)label forView:(UIView *)view withText:(NSString*)text {
    [self setupLabel:label forView:view withText:text withSize: 12];
}


- (void)setupLabel:(UILabel *)label forView:(UIView *)view withText:(NSString*)text
          withSize:(int)size {
    [self setupLabel:label forView:view withText:text withSize: size
       withAlignment:NSTextAlignmentLeft];
}

- (void)setupLabel:(UILabel *)label forView:(UIView *)view withText:(NSString*)text
          withSize:(int)size withAlignment:(NSTextAlignment)textAlignment {
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    label.layer.shadowOpacity = 1.0 * pow(22.0 / (double)size, 3.0); // too much work?
    [label setText:text];
    [view addSubview:label];
}

- (void)addLabels
{
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320, 40)];
    int size = 30;
    int length = [event[@"name"] length];
    if (length > 32)
    {
        size = size*32/length;
    }
    
    [self setupLabel:ttitle forView:self.view withText:self.event[@"name"] withSize:size];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 320, 40)];
    [self setupLabel:dateLabel forView:self.view withText:self.event[@"date_formatted"] withSize:20];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 320, 40)];
    [self setupLabel:timeLabel forView:self.view withText:self.event[@"time_formatted"] withSize:20];
    
    // Address 1 label
    NSMutableDictionary *venue = self.event[@"venue"];
    NSString *street = venue[@"street"];
    NSString *lowerLine = [NSString stringWithFormat:@"%@, %@ %@", venue[@"city"], venue[@"state"], venue[@"zip"]];
    if (!venue[@"city"] || !venue[@"state"] || !venue[@"zip"])
        lowerLine = @"";
    
    if ([street length]) {
        UILabel *addrUpperLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 320, 40)];
        [self setupLabel:addrUpperLabel forView:self.view withText:street withSize:18];
    }
    
    // Address 2 label
    if ([lowerLine length]) {
        UILabel *addrLowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 320, 40)];
        [self setupLabel:addrLowerLabel forView:self.view withText:lowerLine withSize:16];
    }
    
    // Number attending label
    NSString *attendees = [[@"Attending: " stringByAppendingString:event[@"attendees"]] stringByAppendingString:@" people"];
    
    UILabel *numAttendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320, 40)];
    [self setupLabel:numAttendingLabel forView:self.view withText:attendees withSize:20];

}


//    NSMutableString *s = [[NSMutableString alloc] init];
//    for (id obj in address) {
//        
//        NSString *final = [obj stringByAppendingString:s];
//        [s appendString:[obj stringByAppendingString:@"\n"]];
//    }
//    addressLabel.numberOfLines = 0;
//    addressLabel.textColor = [UIColor whiteColor];
//    addressLabel.text = s;
//    
//    addressLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
//    addressLabel.layer.shadowOffset = CGSizeMake(0.0, 0.4);
//    addressLabel.layer.shadowOpacity = 1.0;
//    
//    addressLabel.frame = CGRectMake(80, 126, 400, 100);
//    addressLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:11.0];


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
