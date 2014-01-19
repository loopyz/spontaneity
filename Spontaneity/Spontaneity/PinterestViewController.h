//
//  PinterestViewController.h
//  Spontaneity
//
//  Created by Angela Zhang on 1/18/14.
//
//

#import <UIKit/UIKit.h>
#import <Pinterest/Pinterest.h>
#import <Firebase/Firebase.h>

@interface PinterestViewController : UIViewController

@property (strong, nonatomic) NSDictionary *pin;
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) Pinterest*  pinterest;

@end
