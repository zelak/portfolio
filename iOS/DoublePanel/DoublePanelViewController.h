//
//  DoublePanelViewController.h
//  equal
//
//  Created by Andre Mauricio Zelak on 19/08/13.
//  Copyright (c) 2013 politeapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoublePanelViewController : UIViewController

// panels
@property (weak, nonatomic) IBOutlet UIView *backPanel;
@property (weak, nonatomic) IBOutlet UIView *frontPanel;

// swipe
- (IBAction)pan:(UIPanGestureRecognizer *)sender;
- (IBAction)hideButton:(id)sender;
- (IBAction)shoButton:(id)sender;

@end
