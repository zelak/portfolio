//
//  SqliteHelper.h
//  equal
//
//  Created by Andre Mauricio Zelak on 12/02/14.
//  Copyright (c) 2014 politeapp. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SqliteHelper : NSObject

// ++++++++++++++++++++++++++
//      public methods
// ++++++++++++++++++++++++++
- (BOOL)open:(NSString*)filename;
- (void)close;
- (BOOL)create:(NSString*)sql;
- (BOOL)write:(NSString*)sql :(NSArray*)fields;
- (BOOL)read:(NSString*)query :(NSMutableArray*)answer;

@end
