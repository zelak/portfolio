//
//  CardCell.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import "CardCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Mask.h"
@implementation CardCell

@synthesize background;
@synthesize avatar;
@synthesize name;
//@synthesize imageConnected;
//@synthesize imageWaitingConnected;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAttributedTextName:(NSMutableAttributedString *)attributeString
{
    [self.name setAttributedText:attributeString];
}

- (void)setDetailWithCard:(Card *)card
{
    UIImage *placeholder = [UIImage imageNamed:@"default-user"];
    self.name.text = card.name;
    
    // load default avatar image
    if(card.avatarUrl == nil) {
        self.avatar.image = placeholder;
    }
    else {
        // asynchronously load avatar image
        if (self.avatar.image == nil) {
            [self.avatar setImageWithURL:card.avatarNSURL
                         placeholderImage:placeholder
                         success:^(UIImage *image, BOOL cached)
             {
                 // get image mask
                 UIImage *mask = [UIImage imageNamed:@"header-avatar-mask.png"];
                 // apply image mask in profile avatar image
                 UIImage *maskedImage = [UIImage image:image withMask:mask];
                 // set profile avatar image with masked image
                 [self.avatar setImage:maskedImage];
             }
                                        failure:^(NSError *error)
             {
                 [self.avatar setImage:placeholder];
             }];
        }
    }
    
    /*if([card.connectedTo intValue]) {
        imageConnected.hidden = NO;
        imageWaitingConnected.hidden = YES;
    }
    else {
        [self.background setBackgroundColor: nil];
        imageConnected.hidden = YES;
        
        if ([card.waitingAnswer intValue]) {
            imageWaitingConnected.hidden = NO;
        }
    }*/
    
    // set selection color to gray
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
}

@end
