//
//  SearchViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  For selecting what interest you want to pick events for

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SearchViewController : UITableViewController 

@property (nonatomic, strong) NSMutableArray* interests;
@property (nonatomic, strong) UIView* exitView;
@property (nonatomic, strong) Firebase* firebase;

@property (nonatomic) bool done;

@end
