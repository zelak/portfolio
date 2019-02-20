//
//  SidePanelViewController.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 29/06/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import "SidePanelViewController.h"
#import "ThemeManager.h"
#import <QuartzCore/QuartzCore.h>

// config variables
#define DEF_PAN_LEFT_POSITION         -260
#define DEF_PAN_RIGHT_POSITION         260
#define DEF_PAN_LEFT_TRESHOLD         -160
#define DEF_PAN_RIGHT_TRESHOLD         160

@interface SidePanelViewController ()

// private members
@property NSInteger      pan_left_position;
@property NSInteger      pan_right_position;
@property NSInteger      pan_left_treshold;
@property NSInteger      pan_right_treshold;

@end

@implementation SidePanelViewController

@synthesize leftLayer;
@synthesize centerLayer;
@synthesize rightLayer;
@synthesize leftButton;
@synthesize rightButton;

@synthesize pan_left_position;
@synthesize pan_right_position;
@synthesize pan_animated_pan_duration;
@synthesize pan_animated_pan_delay;
@synthesize pan_left_treshold;
@synthesize pan_right_treshold;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)customizeRightLayerAppearance
{
    ThemeManager *themeMngr = [ThemeManager sharedManager];
    
    UIColor      *color     = [themeMngr color:@"RightLayerBackground"];
    if (color) {
        rightLayer.backgroundColor = color;
    }
}

- (void)customizeRightButtonAppearance
{
    ThemeManager *themeMngr = [ThemeManager sharedManager];
    
    UIColor      *color     = [themeMngr color:@"RightButtonBackground"];
    if (color) {
        rightButton.backgroundColor = color;
    }
    
    UIImage      *image     = [themeMngr image:@"RightButton"];
    if (image) {
        [rightButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)customizeCenterLayerAppearance
{
    ThemeManager *themeMngr = [ThemeManager sharedManager];
    
    UIColor      *color     = [themeMngr color:@"CenterLayerBackground"];
    if (color) {
        centerLayer.backgroundColor = color;
    }
}

- (void)customizeLeftButtonAppearance
{
    ThemeManager *themeMngr = [ThemeManager sharedManager];
    
    UIColor      *color     = [themeMngr color:@"LeftButtonBackground"];
    if (color) {
        leftButton.backgroundColor = color;
    }
    
    UIImage      *image     = [themeMngr image:@"LeftButton"];
    if (image) {
        [leftButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)customizeLeftLayerAppearance
{
    ThemeManager *themeMngr = [ThemeManager sharedManager];
    
    UIColor      *color     = [themeMngr color:@"LeftLayerBackground"];
    if (color) {
        leftLayer.backgroundColor = color;
    }
}

- (void)readPanParameters
{
    pan_left_position         = DEF_PAN_LEFT_POSITION;
    pan_right_position        = DEF_PAN_RIGHT_POSITION;
    pan_left_treshold         = DEF_PAN_LEFT_TRESHOLD;
    pan_right_treshold        = DEF_PAN_RIGHT_TRESHOLD;
    
    ThemeManager *themeMngr   = [ThemeManager sharedManager];
    
    pan_left_position         = [themeMngr integerValue:@"PanLeftPosition"];
    pan_right_position        = [themeMngr integerValue:@"PanRightPosition"];
    pan_animated_pan_duration = [themeMngr floatValue:@"PanDuration"];
    pan_animated_pan_delay    = [themeMngr floatValue:@"PanDelay"];
    pan_left_treshold         = [themeMngr integerValue:@"PanLeftTreshold"];
    pan_right_treshold        = [themeMngr integerValue:@"PanRightTreshold"];
}

- (void)customizeAppearance
{
    [self readPanParameters];
    [self customizeRightLayerAppearance];
    [self customizeRightButtonAppearance];
    [self customizeCenterLayerAppearance];
    [self customizeLeftButtonAppearance];
    [self customizeLeftLayerAppearance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)moveCenterLayerRight
{
    CGPoint origin = centerLayer.frame.origin;
    origin.x = pan_right_position;
    [self animateLayerToPoint:origin layer:centerLayer];
}

- (void)moveCenterLayerCenter
{
    CGPoint origin = centerLayer.frame.origin;
    origin.x = 0;
    [self animateLayerToPoint:origin layer:centerLayer];
}

- (void)moveCenterLayerLeft
{
    CGPoint origin = centerLayer.frame.origin;
    origin.x = pan_left_position;
    [self animateLayerToPoint:origin layer:centerLayer];
}

- (void)moveCenterLayerToX:(CGPoint)point
{
    CGPoint origin = centerLayer.frame.origin;
    origin.x = point.x;
    [self animateLayerToPoint:origin layer:centerLayer];
}

- (void)showLeftLayer
{
    [rightLayer setHidden:YES];
    [self moveCenterLayerRight];
}

- (void)hideLeftLayer
{
    [self moveCenterLayerCenter];
}

- (void)showRightLayer
{
    [rightLayer setHidden:NO];
    [self moveCenterLayerLeft];
}

- (void)hideRightLayer
{
    [self moveCenterLayerCenter];
}

- (IBAction)actionLeftButton:(id)sender
{
    if (centerLayer.frame.origin.x == 0) {
        [self showLeftLayer];
    } else {
        [self hideLeftLayer];
    }
}

- (IBAction)actionRightButton:(id)sender
{
    if (centerLayer.frame.origin.x == 0) {
        [self showRightLayer];
    } else {
        [self hideRightLayer];
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    static CGPoint centerStartPoint;
    
    /* save center layer position in swipe movement start */
    if (sender.state == UIGestureRecognizerStateBegan) {
        centerStartPoint = centerLayer.frame.origin;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        /* move center layer according to swipe movement */
        CGPoint translation = [sender translationInView:centerLayer];
        translation.x      += centerStartPoint.x;
        
        if (translation.x > 0) {
            [self.rightLayer setHidden:YES];
        } else {
            [self.rightLayer setHidden:NO];
        }
        [self moveCenterLayerToX:translation];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        /* complete movement depending on center layer position */
        if (centerLayer.frame.origin.x < pan_left_treshold)
        {
            [self showRightLayer];
        }
        else if (centerLayer.frame.origin.x > pan_right_treshold)
        {
            [self showLeftLayer];
        }
        else /* between LEFT and RIGHT treshold */
        {
            [self hideRightLayer];
        }
    }
}
@end
