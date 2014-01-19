//
//  HomeViewController.m
//  Spontaneity
//
//  Created by Lucy Guo on 1/19/14.
//
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //creates background image
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        [[UIImage imageNamed:@"create-bg.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
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
    UIImage *createButtonImage = [UIImage imageNamed:@"home-button.png"];
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