//
//  EventListViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  For listing events you've found so you can join them

#import "EventListViewController.h"
#import <Firebase/Firebase.h>

@interface EventListViewController ()

@end

@implementation EventListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-gray"]];
        titleImageView.frame = CGRectMake(40, 10, 124, 30);
        [logoView addSubview:titleImageView];
        
        self.navigationItem.titleView = logoView;
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

@end
