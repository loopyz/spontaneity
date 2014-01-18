//
//  EventListViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface EventListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* eventKeys;
@property (nonatomic, strong) NSMutableDictionary* events;
@property (nonatomic, strong) Firebase* firebase;

@end
