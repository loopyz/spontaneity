//
//  JoinEventViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display details about a selected event and option to join

#import <UIKit/UIKit.h>

@interface JoinEventViewController : UIViewController

@property (strong, nonatomic) NSDictionary *event;

- (id)initWithEvent:(NSDictionary *)event;

@end
