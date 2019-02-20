//
//  Card.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize sectionNumber;
@synthesize userId;
@synthesize alias;
@synthesize name;

@synthesize email;
@synthesize fullName;
@synthesize website;
@synthesize mobilePhone;
@synthesize workPhone;

@synthesize avatarUrl;
@synthesize avatar;
@synthesize cardUrl;
@synthesize cardImage;
@synthesize connectedTo;

@synthesize waitingAnswer;

- (void)loadAvatar
{
    self.avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatarUrl]];
}

- (void)loadCardImage
{
    self.cardImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardUrl]];
}

@end
