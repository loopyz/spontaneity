//
//  CreateDetailViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//

#import <UIKit/UIKit.h>

@interface CreateDetailViewController : UIViewController

@property (nonatomic) NSInteger editTimeClicks;
@property (nonatomic) NSInteger neededPeople;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *neededLabel;

@end
