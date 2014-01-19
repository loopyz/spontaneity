//
//  JoinEventViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//  Display details about a selected event and option to join

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface JoinEventViewController : UIViewController

@property (strong, nonatomic) NSDictionary* event;
@property (strong, nonatomic) Firebase* firebase;

- (id)initWithEvent:(NSDictionary *)event;

@end
