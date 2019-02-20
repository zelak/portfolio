//
//  Card.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject {
    
}
@property NSInteger sectionNumber;

@property (nonatomic, assign) int     userId;
@property (nonatomic, copy) NSString  *alias;
@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSURL     *avatarNSURL;
@property (nonatomic, copy) NSString  *avatarUrl;
@property (nonatomic, retain) NSData  *avatar;
@property (nonatomic, weak) UIImage   *avatarImage;
@property (nonatomic, copy) NSURL     *cardNSURL;
@property (nonatomic, copy) NSString  *cardUrl;
@property (nonatomic, retain) UIImage *cardImage;
@property (nonatomic, copy) NSString  *connectedTo;
@property (nonatomic, copy) NSString  *waitingAnswer;

@property (nonatomic, copy) NSString  *email;
@property (nonatomic, copy) NSString  *fullName;
@property (nonatomic, copy) NSString  *website;
@property (nonatomic, copy) NSString  *workPhone;
@property (nonatomic, copy) NSString  *mobilePhone;
@property (nonatomic, copy) NSString  *address;

@property (nonatomic, assign) NSInteger waitingResponse;

- (void)loadAvatar;
- (void)loadCardImage;

@end
