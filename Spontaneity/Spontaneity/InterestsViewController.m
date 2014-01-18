//
//  InterestsViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  View Controller for Tap Your Interests Selection Screen
//

#import "InterestsViewController.h"

@interface InterestsViewController ()

@end

@implementation InterestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        //1st Row
        UIImageView *dining = [[UIImageView alloc] initWithFrame:CGRectMake(5, 110, 100, 100)];
        dining.image = [UIImage imageNamed:@"dining.png"];
        [self.view addSubview:dining];
        
        UIImageView *bars = [[UIImageView alloc] initWithFrame:CGRectMake(110, 110, 100, 100)];
        bars.image = [UIImage imageNamed:@"bars.png"];
        [self.view addSubview:bars];
        
        UIImageView *clubbing = [[UIImageView alloc] initWithFrame:CGRectMake(215, 110, 100, 100)];
        clubbing.image = [UIImage imageNamed:@"clubbing.png"];
        [self.view addSubview:clubbing];
        
        //2nd Row
        UIImageView *sports = [[UIImageView alloc] initWithFrame:CGRectMake(5, 240, 100, 100)];
        sports.image = [UIImage imageNamed:@"sports.png"];
        [self.view addSubview:sports];
        
        UIImageView *adrenaline = [[UIImageView alloc] initWithFrame:CGRectMake(110, 240, 100, 100)];
        adrenaline.image = [UIImage imageNamed:@"adrenaline.png"];
        [self.view addSubview:adrenaline];
        
        UIImageView *tech = [[UIImageView alloc] initWithFrame:CGRectMake(215, 240, 100, 100)];
        tech.image = [UIImage imageNamed:@"Tech.png"];
        [self.view addSubview:tech];
        
        //3rd row
        UIImageView *exercise = [[UIImageView alloc] initWithFrame:CGRectMake(5, 370, 100, 100)];
        exercise.image = [UIImage imageNamed:@"exercise.png"];
        [self.view addSubview:exercise];
        
        UIImageView *games = [[UIImageView alloc] initWithFrame:CGRectMake(110, 370, 100, 100)];
        games.image = [UIImage imageNamed:@"games.png"];
        [self.view addSubview:games];
        
        UIImageView *beauty = [[UIImageView alloc] initWithFrame:CGRectMake(215, 370, 100, 100)];
        beauty.image = [UIImage imageNamed:@"beauty.png"];
        [self.view addSubview:beauty];
        
        //Finish button
        UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
        [finish addTarget:self
                   action:@selector(didFinishSelecting)
         forControlEvents:UIControlEventTouchDown];
        [finish setImage:[UIImage imageNamed:@"Finish-Button.png"]
                  forState: UIControlStateNormal];
        finish.frame = CGRectMake(30, 500, 260.0, 50.0);
        [self.view addSubview:finish];
    
    }
    return self;
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

// Button Method
- (void)didFinishSelecting
{
    NSLog(@"Hit finish button!");
}

@end
