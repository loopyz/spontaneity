//
//  CreateViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface CreateViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (nonatomic) NSInteger editTimeClicks;
@property (nonatomic) NSInteger neededPeople;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *neededLabel;
@property (nonatomic, strong) NSMutableArray* interests;
@property (nonatomic, strong) Firebase* firebase;



@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSString *location;

@end
