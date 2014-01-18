//
//  CreateViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  Create Button!

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"create-bg-2.png"]]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addButton];

	// Do any additional setup after loading the view.
}


- (void)addButton
{
    UIImage *createButtonImage = [UIImage imageNamed:@"create-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];

    button.frame = CGRectMake(self.view.frame.size.width/2 - 250/2, self.view.frame.size.height/2 - 250/2, 250.0, 250.0);
    [button setBackgroundImage:createButtonImage forState:UIControlStateNormal];
    [self.view addSubview:button];



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
