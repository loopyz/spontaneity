//
//  CreateViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//

#import <UIKit/UIKit.h>

@interface CreateViewController : UIViewController

@property (nonatomic) NSInteger editTimeClicks;
@property (nonatomic) NSInteger neededPeople;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *neededLabel;

@end
