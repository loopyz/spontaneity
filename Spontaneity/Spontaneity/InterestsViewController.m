//
//  InterestsViewController.m
//  Spontaneity
//
//  Created by Angela Zhang on 1/17/14.
//
//  View Controller for Tap Your Interests Selection Screen
//

#import "AppDelegate.h"
#import "InterestsViewController.h"
#import <Firebase/Firebase.h>

@interface InterestsViewController ()

@end

@implementation InterestsViewController
{
    UIButton *dining;
    UIButton *bars;
    UIButton *clubbing;
    UIButton *parties;
    UIButton *adrenaline;
    UIButton *baking;
    UIButton *exercise;
    UIButton *games;
    UIButton *beauty;
    NSMutableArray *selections;
}

@synthesize finishButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selections = [[NSMutableArray alloc] init];
        
        self.view.backgroundColor = [UIColor colorWithRed:0.953 green:0.949 blue:0.949 alpha:1.0];
        
        //Tap Interests View
        UILabel *interests = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 45)];
        interests.textAlignment =  NSTextAlignmentCenter;
        interests.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        interests.backgroundColor = [UIColor clearColor];
        interests.font = [UIFont fontWithName:@"Helvetica-Oblique" size:(36)];
        [self.view addSubview:interests];
        interests.text = @"Tap Your Interests";
        
        //creates shadow
        interests.layer.shadowColor = [[UIColor whiteColor] CGColor];
        interests.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        interests.layer.shadowOpacity = 1.0;

        
        
        
        //1st Row
        dining = [UIButton buttonWithType:UIButtonTypeCustom];
        [dining addTarget:self
                   action:@selector(interestSelected:)
         forControlEvents:UIControlEventTouchDown];
        [dining setImage:[UIImage imageNamed:@"dining.png"]
                forState: UIControlStateNormal];
        dining.frame = CGRectMake(10, 100, 90, 90);
        [self.view addSubview:dining];
        UILabel *diningLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 100, 100) ];
        diningLabel.textAlignment =  NSTextAlignmentCenter;
        diningLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        diningLabel.backgroundColor = [UIColor clearColor];
        diningLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:diningLabel];
        diningLabel.text = @"dining";
        dining.alpha = .5;
        
        bars = [UIButton buttonWithType:UIButtonTypeCustom];
        [bars addTarget:self
                 action:@selector(interestSelected:)
       forControlEvents:UIControlEventTouchDown];
        [bars setImage:[UIImage imageNamed:@"bars.png"]
              forState: UIControlStateNormal];
        bars.frame = CGRectMake(115, 100, 90, 90);
        [self.view addSubview:bars];
        UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 100, 100.0) ];
        barLabel.textAlignment =  NSTextAlignmentCenter;
        barLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        barLabel.backgroundColor = [UIColor clearColor];
        barLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:barLabel];
        barLabel.text = @"bars";
        bars.alpha = .5;
        
        
        clubbing = [UIButton buttonWithType:UIButtonTypeCustom];
        [clubbing addTarget:self
                     action:@selector(interestSelected:)
           forControlEvents:UIControlEventTouchDown];
        [clubbing setImage:[UIImage imageNamed:@"clubbing.png"]
                  forState: UIControlStateNormal];
        clubbing.frame = CGRectMake(220, 100, 90, 90);
        [self.view addSubview:clubbing];
        UILabel *clubbingLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 160, 100, 100.0) ];
        clubbingLabel.textAlignment =  NSTextAlignmentCenter;
        clubbingLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        clubbingLabel.backgroundColor = [UIColor clearColor];
        clubbingLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:clubbingLabel];
        clubbingLabel.text = @"clubbing";
        clubbing.alpha = .5;
        
        //2nd Row
        parties = [UIButton buttonWithType:UIButtonTypeCustom];
        [parties addTarget:self
                   action:@selector(interestSelected:)
         forControlEvents:UIControlEventTouchDown];
        [parties setImage:[UIImage imageNamed:@"sports.png"]
                forState: UIControlStateNormal];
        parties.frame = CGRectMake(10, 230, 90, 90);
        [self.view addSubview:parties];
        UILabel *partiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 290, 100, 100.0) ];
        partiesLabel.textAlignment =  NSTextAlignmentCenter;
        partiesLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        partiesLabel.backgroundColor = [UIColor clearColor];
        partiesLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:partiesLabel];
        partiesLabel.text = @"sports";
        parties.alpha = .5;
        
        adrenaline = [UIButton buttonWithType:UIButtonTypeCustom];
        [adrenaline addTarget:self
                       action:@selector(interestSelected:)
             forControlEvents:UIControlEventTouchDown];
        [adrenaline setImage:[UIImage imageNamed:@"adrenaline.png"]
                    forState: UIControlStateNormal];
        adrenaline.frame = CGRectMake(115, 230, 90, 90);
        [self.view addSubview:adrenaline];
        UILabel *adrLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 290, 100, 100.0) ];
        adrLabel.textAlignment =  NSTextAlignmentCenter;
        adrLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        adrLabel.backgroundColor = [UIColor clearColor];
        adrLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:adrLabel];
        adrLabel.text = @"adrenaline";
        adrenaline.alpha = .5;
        
        baking = [UIButton buttonWithType:UIButtonTypeCustom];
        [baking addTarget:self
                 action:@selector(interestSelected:)
       forControlEvents:UIControlEventTouchDown];
        [baking setImage:[UIImage imageNamed:@"baking.png"]
              forState: UIControlStateNormal];
        baking.frame = CGRectMake(220, 230, 90, 90);
        [self.view addSubview:baking];
        UILabel *bakingLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 290, 100, 100.0) ];
        bakingLabel.textAlignment =  NSTextAlignmentCenter;
        bakingLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        bakingLabel.backgroundColor = [UIColor clearColor];
        bakingLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:bakingLabel];
        bakingLabel.text = @"baking";
        baking.alpha = .5;
        
        //3rd row
        exercise = [UIButton buttonWithType:UIButtonTypeCustom];
        [exercise addTarget:self
                     action:@selector(interestSelected:)
           forControlEvents:UIControlEventTouchDown];
        [exercise setImage:[UIImage imageNamed:@"exercise.png"]
                  forState: UIControlStateNormal];
        exercise.frame = CGRectMake(10, 360, 90, 90);
        [self.view addSubview:exercise];
        
        UILabel *exLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 420, 100, 100.0) ];
        exLabel.textAlignment =  NSTextAlignmentCenter;
        exLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        exLabel.backgroundColor = [UIColor clearColor];
        exLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:exLabel];
        exLabel.text = @"exercise";
        exercise.alpha = .5;
        
        games = [UIButton buttonWithType:UIButtonTypeCustom];
        [games addTarget:self
                  action:@selector(interestSelected:)
        forControlEvents:UIControlEventTouchDown];
        [games setImage:[UIImage imageNamed:@"games.png"]
               forState: UIControlStateNormal];
        games.frame = CGRectMake(115, 360, 90, 90);
        [self.view addSubview:games];
        
        UILabel *gamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 420, 100, 100.0) ];
        gamesLabel.textAlignment =  NSTextAlignmentCenter;
        gamesLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        gamesLabel.backgroundColor = [UIColor clearColor];
        gamesLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:gamesLabel];
        gamesLabel.text = @"video games";
        games.alpha = .5;
        
        
        beauty = [UIButton buttonWithType:UIButtonTypeCustom];
        [beauty addTarget:self
                   action:@selector(interestSelected:)
         forControlEvents:UIControlEventTouchDown];
        [beauty setImage:[UIImage imageNamed:@"beauty.png"]
                forState: UIControlStateNormal];
        beauty.frame = CGRectMake(220, 360, 90, 90);
        [self.view addSubview:beauty];
        
        UILabel *beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 420, 100, 100.0) ];
        beautyLabel.textAlignment =  NSTextAlignmentCenter;
        beautyLabel.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.592 alpha:1.0];
        beautyLabel.backgroundColor = [UIColor clearColor];
        beautyLabel.font = [UIFont fontWithName:@"Helvetica" size:(14)];
        [self.view addSubview:beautyLabel];
        beautyLabel.text = @"beauty";
        beauty.alpha = .5;
        
        
        // Finish button
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.finishButton addTarget:self
                   action:@selector(didFinishSelecting)
         forControlEvents:UIControlEventTouchDown];
        [self.finishButton setImage:[UIImage imageNamed:@"Finish-Button.png"]
                forState: UIControlStateNormal];
        self.finishButton.frame = CGRectMake(30, 500, 260.0, 39.468);
        [self.finishButton setEnabled:NO];
        [self.view addSubview:finishButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//User selected an interest
- (void)interestSelected:(id)sender
{
    //UIImage *checkMark = [UIImage imageNamed:@"checkmark-interest.png"];
    
    if (sender == dining) {
        if ([selections indexOfObject:@"dining"] != NSNotFound) {
            [selections removeObject:@"dining"];
            dining.alpha = .5;
        } else {
            [selections addObject:@"dining"];
            dining.alpha = 1;
        }
    } else if (sender == bars) {
        if ([selections indexOfObject:@"bars"] != NSNotFound) {
            [selections removeObject:@"bars"];
            bars.alpha = .5;
        } else {
            [selections addObject:@"bars"];
            bars.alpha = 1;
        }
    }else if (sender == clubbing) {
        if ([selections indexOfObject:@"clubbing"] != NSNotFound) {
            [selections removeObject:@"clubbing"];
            clubbing.alpha = .5;
        } else {
            [selections addObject:@"clubbing"];
            clubbing.alpha = 1;
        }
    } else if (sender == parties) {
        if ([selections indexOfObject:@"parties"] != NSNotFound) {
            [selections removeObject:@"parties"];
            parties.alpha = .5;
        } else {
            [selections addObject:@"parties"];
            parties.alpha = 1;
        }
    } else if (sender == adrenaline) {
        if ([selections indexOfObject:@"adrenaline"] != NSNotFound) {
            [selections removeObject:@"adrenaline"];
            adrenaline.alpha = .5;
        } else {
            [selections addObject:@"adrenaline"];
            adrenaline.alpha = 1;
        }
    } else if (sender == baking) {
        if ([selections indexOfObject:@"baking"] != NSNotFound) {
            [selections removeObject:@"baking"];
            baking.alpha = .5;
        } else {
            [selections addObject:@"baking"];
            baking.alpha = 1;
        }
    } else if (sender == exercise) {
        if ([selections indexOfObject:@"exercise"] != NSNotFound) {
            [selections removeObject:@"exercise"];
            exercise.alpha = .5;
        } else {
            [selections addObject:@"exercise"];
            exercise.alpha = 1;
        }
    } else if (sender == games) {
        if ([selections indexOfObject:@"games"] != NSNotFound) {
            [selections removeObject:@"games"];
            games.alpha = .5;
        } else {
            [selections addObject:@"games"];
            games.alpha = 1;
        }
    } else if (sender == beauty) {
        if ([selections indexOfObject:@"beauty"] != NSNotFound) {
            [selections removeObject:@"beauty"];
            beauty.alpha = .5;
        } else {
            [selections addObject:@"beauty"];
            beauty.alpha = 1;
        }
    }
    
    if ([selections count])
        [self.finishButton setEnabled:YES];
    else
        [self.finishButton setEnabled:NO];
}


//Finish Button
- (void)didFinishSelecting
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* username = appDelegate.username;
    
    Firebase* usersRef = [[Firebase alloc] initWithUrl:@"https://spontaneity.firebaseio.com/users"];
    Firebase* interestsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"interests"];
    
    NSMutableDictionary *newInterests = [[NSMutableDictionary alloc] init];
    for (NSString *s in selections)
        newInterests[s] = @true;
                                         
    [interestsRef setValue:newInterests];
    
    [self dismissViewControllerAnimated:YES completion:^() {

    }];
}

@end