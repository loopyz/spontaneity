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

- (id)initWithCallback:(void (^)(void))handler;
- (void)addEventsDetailLabel:(NSString*)interest;

@property (nonatomic) NSInteger editTimeClicks;
@property (nonatomic) NSInteger neededPeople;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *placeLabel;
@property (strong, nonatomic) UILabel *addressLabel;

@property (strong, nonatomic) UILabel *neededLabel;
@property (nonatomic, strong) NSArray *interests;
@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic, strong) NSDictionary *jsonItems;
@property (nonatomic, strong) NSString *randInterest;


@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) BOOL acceptLocation;


@end
