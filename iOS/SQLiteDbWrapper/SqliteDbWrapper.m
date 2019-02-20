//
//  SqliteDbWrapper.m
//  equal
//
//  Created by Andre Mauricio Zelak on 13/02/14.
//  Copyright (c) 2014 politeapp. All rights reserved.
//

#import "SqliteDbWrapper.h"
#import "SqliteHelper.h"

// +++++++++++++++++++++++++
//      interface
// +++++++++++++++++++++++++
@interface SqliteDbWrapper ()

@property (nonatomic, retain) SqliteHelper* sqlite;

@end


// +++++++++++++++++++++++++
//      implementation
// +++++++++++++++++++++++++
@implementation SqliteDbWrapper

// ++++++++++++++++++++++++++
//      private properties
// ++++++++++++++++++++++++++
@synthesize sqlite;

// ++++++++++++++++++++++++++
//      public methods
// ++++++++++++++++++++++++++

// +++ object initializer +++
- (id)init
{
    self = [super init];
    if (self) {
        self.sqlite = [[SqliteHelper alloc] init];
    }
    return self;
}

// +++ open database +++
- (BOOL)open
{
    return [sqlite open:@"main_db.sqlite"];
}

// +++ close database +++
- (BOOL)close
{
    [sqlite close];
    return TRUE;
}

// +++ create contacts table +++
- (void)createContactsTable
{
    NSString *createStr = @"CREATE TABLE IF NOT EXISTS CONTACTS(USER_ID INTEGER PRIMARY KEY AUTOINCREMENT, FIRST_NAME TEXT, LAST_NAME TEXT, NICKNAME TEXT, EMAIL TEXT);";
    [sqlite create:createStr];
}

// +++ create avatars table +++
- (void)createPicturesTable
{
    NSString *createStr = @"CREATE TABLE IF NOT EXISTS PICTURES(PICTURE_ID INTEGER PRIMARY KEY AUTOINCREMENT, USER_ID INTEGER, IMAGE TEXT);";
    [sqlite create:createStr];
}

// +++ create contact db +++
- (BOOL)createContactDb
{
    [self open];

    [self createContactsTable];
    [self createPicturesTable];
    
    [self close];
    return TRUE;
}

// +++ addUpdatePicture +++
- (BOOL)addUpdatePicture:(Contact *)contact
{
    NSString *updStr = @"INSERT OR REPLACE INTO PICTURES(PICTURE_ID, IMAGE) VALUES(?,?);";
    NSArray  *fields = [[NSArray alloc] initWithObjects:contact.userId, contact.pictureUrl, nil];
    [sqlite write:updStr :fields];
    return TRUE;
}

// +++ add or update a contact +++
- (BOOL)addUpdateContact:(Contact *)contact
{
    [self open];
    // add or update picture
    //[self addUpdatePicture:contact];
    // add or update contact
    NSString *updStr = @"INSERT OR REPLACE INTO CONTACTS(FIRST_NAME, LAST_NAME, NICKNAME, EMAIL, PICTURE_ID) VALUES(?,?,?,?,?);";
    NSArray  *fields = [[NSArray alloc] initWithObjects:contact.firstName, contact.lastName, contact.nickname, contact.email, contact.pictureUrl, nil];
    [sqlite write:updStr :fields];
    [self close];
    return TRUE;
}

// +++ read contact list +++
- (BOOL)readContactList:(ContactList*)contactList
{
    [self open];
    NSString       *select = @"SELECT * FROM CONTACTS";
    NSMutableArray *response = [[NSMutableArray alloc]init];
    [sqlite read:select :response];
    for (NSArray* row in response) {
        Contact *contact   = [[Contact alloc]init];
        contact.userId     = [row objectAtIndex:0];
        contact.firstName  = [row objectAtIndex:1];
        contact.lastName   = [row objectAtIndex:2];
        contact.nickname   = [row objectAtIndex:3];
        contact.email      = [row objectAtIndex:4];
        
        [contactList addContact:contact];
    }

    [self close];
    return TRUE;
}

// +++ create chat db +++
- (BOOL)createChatDb;
{
    return TRUE;
}

@end
