//
//  JoinEventViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display details about a selected event and option to join

#import "JoinEventViewController.h"

@interface JoinEventViewController ()

@end

@implementation JoinEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        //This image isn't here yet but will be soon (Lucy's making it)
        [[UIImage imageNamed:@"bars-bg-2.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
