//
//  CreateViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  Event Details Screen
//

#import "CreateViewController.h"
#import "PinterestViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

@synthesize timeLabel;
@synthesize neededLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _editTimeClicks = 0;
        _neededPeople = 5;
        
        //creates background image
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        //TODO: randomly generate bg image based off event
        [self addBackgroundImage];
        [self addEventsDetailLabel];
        [self addPlaceLabel];
        [self addTimeLabel];
        [self addInvitedLabel];
        [self addNeededLabel];
        [self addSubmitButton];
        
        /* Exit button */
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton addTarget:self
                       action:@selector(exit)
             forControlEvents:UIControlEventTouchDown];
        [exitButton setImage:[UIImage imageNamed:@"close-button-2.png"]
                    forState: UIControlStateNormal];
        exitButton.frame = CGRectMake(self.view.bounds.size.width-40, 30, 30, 30);
        [self.view addSubview:exitButton];
        
        /* Test Button for Pinterest */
        UIButton *pinterest = [UIButton buttonWithType:UIButtonTypeCustom];
        [pinterest addTarget:self
                       action:@selector(pinterest)
             forControlEvents:UIControlEventTouchDown];
        [pinterest setImage:[UIImage imageNamed:@"close-button-2.png"]
                    forState: UIControlStateNormal];
        pinterest.frame = CGRectMake(self.view.bounds.size.width-40, 70, 30, 30);
        [self.view addSubview:pinterest];
        
    }
    return self;
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinterest
{
    PinterestViewController *pvc = [[PinterestViewController alloc] init];
    [self presentViewController:pvc animated:YES completion:nil];

}

- (void)addBackgroundImage
{
    [[UIImage imageNamed:@"clubbing-bg-2.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)addEventsDetailLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    label.text = @"Event Details";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 50, 1000, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-Oblique" size:35.0];
    
    //adds event details label
    [self.view addSubview:label];
    
}

- (void)addPlaceLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    label.text = @"Place: ";
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 100, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //adds event details label
    [self.view addSubview:label];
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
    timeLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
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
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
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
    neededLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
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
    //TODO: implement
    NSLog(@"Submitted a new event!");
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
    [comps setMinute:((([comps minute] - 8 ) / 15 ) * 15 ) + 15];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
