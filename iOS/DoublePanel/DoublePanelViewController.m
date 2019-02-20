//
//  DoublePanelViewController.m
//  equal
//
//  Created by Andre Mauricio Zelak on 19/08/13.
//  Copyright (c) 2013 politeapp. All rights reserved.
//

#import "DoublePanelViewController.h"
#import "ContactMatrix.h"

// config variables
#define DEF_PAN_ANIMATED_PAN_DURATION  0.3
#define DEF_PAN_ANIMATED_PAN_DELAY     0
#define DEF_PAN_LEFT_OFFSET            76
#define DEF_PAN_RIGHT_OFFSET           0
#define DEF_PAN_SNAP_GRID_X            44
#define DEF_PAN_SNAP_GRID_Y            44
#define DEF_PAN_GRID_OFFSET_X          0
#define DEF_INERTIAL_SPEED             0.2
#define DEF_ELASTIC_MULTIPLIER         4

#define DEF_DODGE_OUT_DURATION         0.3
#define DEF_DODGE_OUT_DELAY            0
#define DEF_DODGE_IN_DURATION          0.1
#define DEF_DODGE_IN_DELAY             2.5
#define DEF_FRONT_LEFT_POSITION        76
#define DEF_FRONT_RIGHT_POSITION       166


@interface DoublePanelViewController ()

// private members
@property NSTimeInterval pan_animated_pan_duration;
@property NSTimeInterval pan_animated_pan_delay;
@property NSInteger      pan_left_offset;
@property NSInteger      pan_right_offset;
@property NSInteger      pan_snap_grid_x;
@property NSInteger      pan_snap_grid_y;
@property NSInteger      pan_grid_offset_x;
@property float          inertial_speed;
@property NSInteger      elastic_multiplier;

@property NSTimeInterval dodge_out_duration;
@property NSTimeInterval dodge_out_delay;
@property NSTimeInterval dodge_in_duration;
@property NSTimeInterval dodge_in_delay;
@property NSInteger      front_left_position;
@property NSInteger      front_right_position;
@property NSTimer        *dodge_timer;

@end

@implementation DoublePanelViewController

@synthesize frontPanel;
@synthesize backPanel;

@synthesize pan_animated_pan_duration;
@synthesize pan_animated_pan_delay;
@synthesize pan_left_offset;
@synthesize pan_right_offset;
@synthesize pan_snap_grid_x;
@synthesize pan_snap_grid_y;
@synthesize pan_grid_offset_x;
@synthesize inertial_speed;
@synthesize elastic_multiplier;

@synthesize dodge_out_duration;
@synthesize dodge_out_delay;
@synthesize dodge_in_duration;
@synthesize dodge_in_delay;
@synthesize front_left_position;
@synthesize front_right_position;
@synthesize dodge_timer;

- (void)readPanParameters
{
    pan_animated_pan_duration = DEF_PAN_ANIMATED_PAN_DURATION;
    pan_animated_pan_delay    = DEF_PAN_ANIMATED_PAN_DELAY;
    pan_left_offset           = DEF_PAN_LEFT_OFFSET;
    pan_right_offset          = DEF_PAN_RIGHT_OFFSET;
    pan_snap_grid_x           = DEF_PAN_SNAP_GRID_X;
    pan_snap_grid_y           = DEF_PAN_SNAP_GRID_Y;
    pan_grid_offset_x         = DEF_PAN_GRID_OFFSET_X;
    inertial_speed            = DEF_INERTIAL_SPEED;
    elastic_multiplier        = DEF_ELASTIC_MULTIPLIER;
    
    dodge_out_duration        = DEF_DODGE_OUT_DURATION;
    dodge_out_delay           = DEF_DODGE_OUT_DELAY;
    dodge_in_duration         = DEF_DODGE_IN_DURATION;
    dodge_in_delay            = DEF_DODGE_IN_DELAY;
    front_left_position       = DEF_FRONT_LEFT_POSITION;
    front_right_position      = DEF_FRONT_RIGHT_POSITION;
    dodge_timer               = nil;
}

- (void)contactMatrixTest
{
    ContactList   *lst = [[ContactList alloc] init];

    Contact *john = [[Contact alloc] init];
    john.nickname = @"Johnny";
    [lst addContact:john];

    Contact *mary = [[Contact alloc] init];
    mary.nickname = @"Mary";
    [lst addContact:mary];

    Contact *aaron = [[Contact alloc] init];
    aaron.nickname = @"Aaron";
    [lst addContact:aaron];

    Contact *Joao = [[Contact alloc] init];
    Joao.nickname = @"Joao";
    [lst addContact:Joao];

    Contact *jeve = [[Contact alloc] init];
    jeve.nickname = @"Jeve";
    [lst addContact:jeve];

    Contact *joao = [[Contact alloc] init];
    joao.nickname = @"joao";
    [lst addContact:joao];

    Contact *tor  = [[Contact alloc] init];
    tor.nickname  = @"Tor";
    [lst addContact:tor];

    Contact *eu   = [[Contact alloc] init];
    eu.nickname   = @"Eu mesmo";
    [lst addContact:eu];

    Contact *vai  = [[Contact alloc] init];
    vai.nickname  = @"Vai que cola &ˆ&%$%$&ˆ";
    [lst addContact:vai];

    ContactMatrix *mtx = [[ContactMatrix alloc] initWithContactList:lst];

    [mtx show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readPanParameters];
    //[self contactMatrixTest];
}

- (void)animateLayerToPoint:(CGPoint)point layer:(UIView*)layer
{
    [UIView animateWithDuration:pan_animated_pan_duration delay:pan_animated_pan_delay options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = layer.frame;
                         frame.origin.x = point.x;
                         frame.origin.y = point.y;
                         layer.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)moveBackPanelToX:(CGPoint)point
{
    CGPoint origin = backPanel.frame.origin;
    origin.x = point.x;
    //NSLog(@"point:%f", point.x);
    [self animateLayerToPoint:origin layer:backPanel];
}

- (void)moveFrontPanelToX:(CGPoint)point
{
    CGPoint origin = frontPanel.frame.origin;
    origin.x       = point.x;
    [self animateLayerToPoint:origin layer:frontPanel];
}

- (NSInteger)getNextGridRightX:(CGPoint)point
{
    NSInteger grid = ceil(((double)(point.x - pan_grid_offset_x))/pan_snap_grid_x);
    return grid * pan_snap_grid_x + pan_grid_offset_x;
}

- (NSInteger)getNextGridLeftX:(CGPoint)point
{
    NSInteger grid = floor(((double)(point.x - pan_grid_offset_x))/pan_snap_grid_x);
    return grid * pan_snap_grid_x + pan_grid_offset_x;
}

- (void)dodgeOutFrontPanel
{
    [self moveFrontPanelToX:CGPointMake(front_right_position, 0)];
}

- (void)dodgeInFrontPanel
{
    [self moveFrontPanelToX:CGPointMake(front_left_position, 0)];
}

- (void)showRecentContacts
{
    [self moveBackPanelToX:CGPointMake(pan_right_offset, 0)];
}

- (void)startDodgeTimer
{
    [self stopDodgeTimer];
    dodge_timer = [NSTimer scheduledTimerWithTimeInterval:dodge_in_delay
                                                   target:self
                                                 selector:@selector(dodgeTimerExpired:)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)stopDodgeTimer
{
    if (dodge_timer) {
        [dodge_timer invalidate];
        dodge_timer = nil;
    }
}

- (void)dodgeTimerExpired:(NSTimer*)theTimer
{
    [self dodgeInFrontPanel];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    static CGPoint startPoint;
    
    /* save back panel position in swipe movement start */
    if (sender.state == UIGestureRecognizerStateBegan) {
        startPoint = backPanel.frame.origin;
        /* at begin of pan move front panel to right */
        [self dodgeOutFrontPanel];
        /* stop timer to avoid front panel to return */
        [self stopDodgeTimer];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        /* move back panel according to swipe movement */
        CGPoint translation = [sender translationInView:backPanel];
        CGPoint currentPoint = startPoint;
        currentPoint.x += translation.x;
        
        /* simulate elastic behavior if right end reached */
        if (currentPoint.x > pan_right_offset) {
            /* movement must be proportional to user's pull */
            //NSLog(@"elastic right - current:%f", currentPoint.x);
            NSInteger overLimitPull = currentPoint.x - pan_right_offset + 1;
            NSInteger proportional  = elastic_multiplier*floor(log(overLimitPull));
            currentPoint.x          = pan_right_offset + proportional;
            //NSLog(@"elastic right - to:%f", currentPoint.x);
        }
        
        /* simulate elastic behavior if left end reached */
        else if (currentPoint.x < pan_left_offset - backPanel.frame.size.width) {
            /* movement must be proportional to user's pull */
            //NSLog(@"elastic left - start:%f translation:%f current:%f", startPoint.x, translation.x, currentPoint.x);
            NSInteger overLimitPull = pan_left_offset - backPanel.frame.size.width - currentPoint.x + 1;
            NSInteger proportional  = elastic_multiplier*floor(log(abs(overLimitPull)));
            currentPoint.x          = pan_left_offset - backPanel.frame.size.width - proportional;
            //NSLog(@"elastic left - to:%f", currentPoint.x);
        }

        [self moveBackPanelToX:currentPoint];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        /* move back panel according to swipe movement */
        CGPoint translation = [sender translationInView:backPanel];
        CGPoint currentPoint = startPoint;
        currentPoint.x += translation.x;
        /* inertial component */
        CGPoint velocity = [sender velocityInView:backPanel];
        currentPoint.x += inertial_speed * velocity.x;
        
        //NSLog(@"current: %f | translation: %f | inertial: %f", currentPoint.x, translation.x, (inertial_speed * velocity.x));
        
        /* Check which grid should appear based on movement direction */
        if (velocity.x >= 0) {
            currentPoint.x = [self getNextGridRightX:currentPoint];
        } else {
            currentPoint.x = [self getNextGridLeftX:currentPoint];
        }        
        
        if (currentPoint.x > pan_right_offset) {
            currentPoint.x = pan_right_offset;
        }
        
        if (currentPoint.x < pan_left_offset - backPanel.frame.size.width) {
            currentPoint.x = pan_left_offset - backPanel.frame.size.width;
        }
        //NSLog(@"current:%f", currentPoint.x);
                
        [self moveBackPanelToX:currentPoint];
        
        /* at end of pan start dodge timer */
        [self startDodgeTimer];
    }
}

- (IBAction)hideButton:(id)sender
{
    //[frontPanel setHidden:YES];
    [self dodgeOutFrontPanel];
    [self startDodgeTimer];
}

- (IBAction)shoButton:(id)sender
{
    //[frontPanel setHidden:NO];
    [self dodgeInFrontPanel];
    [self stopDodgeTimer];
    
}

@end
