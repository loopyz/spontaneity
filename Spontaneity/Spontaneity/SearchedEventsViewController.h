//
//  SearchedEventsViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display query of events you've searched for so you can join them :D

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SearchedEventsViewController : UITableViewController

@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) NSMutableArray *eventKeys;
@property (nonatomic, strong) NSMutableDictionary* events;
@property (nonatomic, strong) UIView* exitView;
@property (strong, nonatomic) NSString *interest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInterest:(NSString *)interest;

@end
