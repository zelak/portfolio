//
//  CardCell.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardCell : UITableViewCell {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
//@property (weak, nonatomic) IBOutlet UIImageView *imageConnected;
//@property (weak, nonatomic) IBOutlet UIImageView *imageWaitingConnected;

- (void)setDetailWithCard:(Card*)card;
- (void)setAttributedTextName:(NSMutableAttributedString *)attributeString;

@end
