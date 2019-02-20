//
//  SidePanelViewController.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 29/06/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAnimation.h"

@interface SidePanelViewController : BaseAnimation

// layers
@property (weak, nonatomic) IBOutlet UIView *leftLayer;
@property (weak, nonatomic) IBOutlet UIView *centerLayer;
@property (weak, nonatomic) IBOutlet UIView *rightLayer;

// buttons
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

// swipe
- (IBAction)pan:(UIPanGestureRecognizer *)sender;

// buttons
- (IBAction)actionLeftButton:(id)sender;
- (IBAction)actionRightButton:(id)sender;

// appearance
- (void)customizeAppearance;

@end
