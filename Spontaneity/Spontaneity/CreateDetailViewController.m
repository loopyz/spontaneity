//
//  CreateDetailViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  Event Details Screen
//

#import "CreateDetailViewController.h"

@interface CreateDetailViewController ()

@end

@implementation CreateDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    }
    return self;
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
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm a"];
    NSString *newTime = [timeFormatter stringFromDate:[NSDate date]];
    
    label.text = [@"Time: " stringByAppendingString:newTime];
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 170, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //add up and down arrows
    [self addArrowButtons:220 y:170];
    
    //adds event details label
    [self.view addSubview:label];
    
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
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    
    //take number from the invited section
    int people = 6;
    
    label.text = [@"Needed: " stringByAppendingString:[NSString stringWithFormat:@"%d", people]];
    
    
    //creates shadow
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.layer.shadowOpacity = 1.0;
    
    //create frame for text
    label.frame = CGRectMake(20, 310, 400, 100);
    
    //set font style/text
    label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:25.0];
    
    //add up and down arrows
    [self addArrowButtons:220 y:310];
    
    //adds event details label
    [self.view addSubview:label];
}

- (void)addSubmitButton
{
    UIImage *createButtonImage = [UIImage imageNamed:@"submit-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    
    button.frame = CGRectMake(self.view.frame.size.width/2 - 247.95/2, 450, 247.95, 42.75);
    [button setBackgroundImage:createButtonImage forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

- (void)addArrowButtons:(int)x y:(int) y
{
    //creates up button
    UIImage *createUpButtonImage = [UIImage imageNamed:@"up-arrow.png"];
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upButton addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    
    upButton.frame = CGRectMake(x, y+33, 33.6, 17.6);
    [upButton setBackgroundImage:createUpButtonImage forState:UIControlStateNormal];
    
    //creates down button
    UIImage *createDownButtonImage = [UIImage imageNamed:@"down-arrow.png"];
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downButton addTarget:self
                 action:@selector(aMethod:)
       forControlEvents:UIControlEventTouchDown];
    
    downButton.frame = CGRectMake(x, y+53, 33.62, 17.6);
    [downButton setBackgroundImage:createDownButtonImage forState:UIControlStateNormal];
    
    
    [self.view addSubview:upButton];
    [self.view addSubview:downButton];
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
