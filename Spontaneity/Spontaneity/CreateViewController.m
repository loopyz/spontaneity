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
        [self.view setBackgroundColor:[UIColor grayColor]];
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
//    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    playButton.frame = CGRectMake(110.0, 360.0, 100.0, 30.0);
//    [playButton setTitle:@"Play" forState:UIControlStateNormal];
//    playButton.backgroundColor = [UIColor clearColor];
//    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
//    UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
//    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//    [playButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
//    UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
//    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//    [playButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
//    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:playButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
