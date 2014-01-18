//
//  SearchedEventsViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display query of events you've searched for so you can join them :D

#import "SearchedEventsViewController.h"

@interface SearchedEventsViewController ()

@end

@implementation SearchedEventsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        [[UIImage imageNamed:nibNameOrNil] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        
        [self populateCell:60];
        /* Horizontal Divider Bar */ /*
        UIImageView *barImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontal-separator@2x.png"]];
        barImgView.frame = CGRectMake(40, 10, 124, 30);
        [self.view addSubview:barImgView];*/
        
        [self populateCell:150];
        
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

- (void)populateCell:(int) margin
{
    
    /* Start displaying info */
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, margin, self.view.frame.size.width, 45)];
    name.textAlignment =  NSTextAlignmentLeft;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
    name.text = @"Phi Bar"; //TODO: hardcoded
    [self.view addSubview:name];
    
    NSString *dateString = @"01-18-2013 21:30"; //TODO: hardcoded for now!
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-DD-yyyy HH:mm"];
    NSDate *tmpDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM/DD/yyyy"];
    NSString *date = [dateFormatter stringFromDate:tmpDate];
    [dateFormatter setDateFormat:@"HH:mm a"];
    NSString *time = [dateFormatter stringFromDate:tmpDate];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, margin+45, self.view.frame.size.width, 15)];
    dateLabel.textAlignment =  NSTextAlignmentLeft;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
    dateLabel.text = [NSString stringWithFormat:@"date: %@", date];
    [self.view addSubview:dateLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, margin+60, self.view.frame.size.width, 15)];
    timeLabel.textAlignment =  NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
    timeLabel.text = [NSString stringWithFormat:@"time: %@", time];
    [self.view addSubview:timeLabel];
    
    /* People Attending */
    UILabel *attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120, margin+45, 80, 15)];
    attendingLabel.textAlignment =  NSTextAlignmentCenter;
    attendingLabel.textColor = [UIColor whiteColor];
    attendingLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
    attendingLabel.text = @"attending";
    [self.view addSubview:attendingLabel];
    
    int numAttending = 5; //TODO: hardcoded
    UILabel *numAttendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, margin, 40, 45)];
    numAttendingLabel.textAlignment =  NSTextAlignmentCenter;
    numAttendingLabel.textColor = [UIColor whiteColor];
    numAttendingLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
    numAttendingLabel.text = [NSString stringWithFormat:@"%d", numAttending];
    [self.view addSubview:numAttendingLabel];
    
    /* Dividing bar */
    /*UIImage *barImg = [UIImage imageNamed:@"vertical-separator.png"];
     UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 20, 50, 50)];
     [iv setImage:barImg];
     [self.view addSubview:iv];*/
    
    /* People needed for event to occur */
    UILabel *requiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, margin+45, 50, 15)];
    requiredLabel.textAlignment =  NSTextAlignmentCenter;
    requiredLabel.textColor = [UIColor whiteColor];
    requiredLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(12)];
    requiredLabel.text = @"required";
    [self.view addSubview:requiredLabel];
    
    int numRequired = 2; //TODO: hardcoded
    UILabel *numRequiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, margin, 50, 45)];
    numRequiredLabel.textAlignment =  NSTextAlignmentCenter;
    numRequiredLabel.textColor = [UIColor whiteColor];
    numRequiredLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:(36)];
    numRequiredLabel.text = [NSString stringWithFormat:@"%d", numRequired];
    [self.view addSubview:numRequiredLabel];
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
