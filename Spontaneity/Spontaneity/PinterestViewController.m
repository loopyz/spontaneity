//
//  PinterestViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//

#import "PinterestViewController.h"

@interface PinterestViewController ()

@end

@implementation PinterestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.pinterest.com/v3/pidgets/boards/pinterest/delicious-eats/pins/"]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        
        [request setHTTPMethod: @"GET"];
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        NSError *jsonParsingError = nil;
        NSDictionary *jsonPins = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0 error:&jsonParsingError];
        int randomNum = 0 + arc4random() % (20);
        
        NSDictionary *pin = [[[jsonPins objectForKey:@"data"] objectForKey:@"pins"] objectAtIndex:randomNum];
        NSString *link = [pin objectForKey:@"link"];
        NSString *tmpLink = [@"https://api.pinterest.com/v3/rich_pins/validate/?link=" stringByAppendingString:link];
        NSString *validateLink = [tmpLink stringByAppendingString:@"&access_token=MTQzNTUzOTo0NDgzMTk0NzUzMTQzNDEyMzY6MXwxMzkwMDc5OTU1OjAtLTAxZTFiMjIwZThkNTNlYzRlNmU2MjBlMmVkYjExZmI5YjdlMzhkZGU="];
        
        NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:validateLink]
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:10];
        [req2 setHTTPMethod:@"GET"];
        NSURLResponse *linkResponse = nil;
        NSData *response2 = [NSURLConnection sendSynchronousRequest:req2 returningResponse:&linkResponse error:&requestError];
        NSDictionary *richPin = [NSJSONSerialization JSONObjectWithData:response2 options:0 error:&jsonParsingError];
        NSLog(@"%@", richPin);
        

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
