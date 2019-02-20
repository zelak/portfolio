//
//  SqliteHelper.m
//  equal
//
//  Created by Andre Mauricio Zelak on 12/02/14.
//  Copyright (c) 2014 politeapp. All rights reserved.
//

#import "sqlite3.h"
#import "SqliteHelper.h"

@implementation SqliteHelper

// ++++++++++++++++++++++++++
//     private members
// ++++++++++++++++++++++++++
sqlite3  *database;

// ++++++++++++++++++++++++++
//      private methods
// ++++++++++++++++++++++++++
- (NSString*)getFilePath:(NSString*)filename
{
    // get list of user domain paths
    NSArray  *userDomainPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    // get 1st directory path
    NSString *documentDir     = [userDomainPaths objectAtIndex:0];
    // compose uid filepath by appending file name to directory path and return
    return [documentDir stringByAppendingPathComponent:filename];
}

- (BOOL)doesDbFileExist:(NSString*)filename
{
    BOOL      ret      = FALSE;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getFilePath:filename]]) {
        ret = TRUE;
    }
    
    return ret;
}

- (BOOL)createDbFile:(NSString*)filename
{
    BOOL      ret      = FALSE;
    NSError  *error;
    // get empty db file path
    NSString *emptyDB  = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    // copy empty db to a writable path
    ret = [[NSFileManager defaultManager] copyItemAtPath:emptyDB toPath:[self getFilePath:filename] error:&error];
    return ret;
}

- (BOOL)openDb:(NSString*)filename
{
    BOOL      ret      = FALSE;
    int       resp     = SQLITE_ERROR;
    
    resp = sqlite3_open([[self getFilePath:filename] UTF8String], &database);
    if (resp != SQLITE_OK)
    {
        NSLog(@"Open DB failed! error %d", resp);
    } else {
        ret = TRUE;
    }
    
    return ret;
}

// ++++++++++++++++++++++++++
//      public methods
// ++++++++++++++++++++++++++

// +++ Open DB connection +++
- (BOOL)open:(NSString*)filename
{
    BOOL      ret      = FALSE;
    
    // create DB file if doesn't exist
    if (![self doesDbFileExist:filename]) {
        if (![self createDbFile:filename]) {
            return ret;
        }
    }
    
    // open DB
    [self openDb:filename];

    return ret;
}

// +++ Close DB connection +++
- (void)close
{
    sqlite3_close(database);
}

// +++ Create SQL Table +++
- (BOOL)create:(NSString*)sql
{
    char *errorMsg  = NULL;
    BOOL  ret       = FALSE;
    int   resp      = SQLITE_ERROR;
    
    // execute create SQL command
    resp = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
    if (resp == SQLITE_OK)
    {
        ret = TRUE;
    } else {
        NSLog(@"Error creating DB table: %@: (%d) %s", sql, resp, errorMsg);
        [self close];
    }
    
    return ret;
}

// +++ Insert or Update DB +++
- (BOOL)write:(NSString*)sql :(NSArray*)fields
{
    sqlite3_stmt *statement;
    BOOL          ret        = FALSE;
    int           resp       = SQLITE_ERROR;
    
    // prepare statement with update SQL command
    resp = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil);
    if (resp == SQLITE_OK)
    {
        // replace ? signs in SQL command string with respective field's value
        for (int row = 0; row < fields.count; ++row) {
            sqlite3_bind_text(statement, row + 1, [[fields objectAtIndex:row] UTF8String], -1, NULL);
        }
        
        ret = TRUE;
    }
    // execute
    if (sqlite3_step(statement) != SQLITE_DONE)
    {
        NSLog(@"DB error: (%d) %s", resp, sqlite3_errmsg(database));
        ret = FALSE;
    }
    // finalize statement
    sqlite3_finalize(statement);
    
    return ret;
}

// +++ Read DB +++
- (BOOL)read:(NSString*)query :(NSMutableArray*)answer
{
    sqlite3_stmt   *statement;
    BOOL            ret        = FALSE;
    int             resp       = SQLITE_ERROR;
    
    // prepare statement with read SQL command
    resp = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    if (resp == SQLITE_OK)
    {
        int row = 0;
        
        // for each row
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableArray *rowValues = [[NSMutableArray alloc]init];
            
            int index = sqlite3_column_int(statement, 0);
            [rowValues insertObject:[NSString stringWithFormat:@"%d",index] atIndex:0];
            
            // for each row's column
            for(int column = 1; column < sqlite3_data_count(statement); ++column)
            {
                NSString *element;
                // get column's value and store it into an array
                const unsigned char *clmnData = sqlite3_column_text(statement, column);
                if (clmnData) {
                    element = [[NSString alloc] initWithUTF8String:(const char*)clmnData];
                } else {
                    element = @"invalid field";
                }
                [rowValues insertObject:element atIndex:column];
            }
            
            // store row values array into answer array
            [answer insertObject:rowValues atIndex:row++];
        }
        
        // finalize statement
        sqlite3_finalize(statement);
        
        ret = TRUE;
    }
    
    return ret;
}

@end
