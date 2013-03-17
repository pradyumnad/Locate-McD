//
//  SQLiteToCDHelper.m
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "SQLiteToCDHelper.h"
#import <sqlite3.h>
#import "AppDelegate.h"

static sqlite3 *database = nil;

@interface SQLiteToCDHelper ()
- (NSString *)getDBPath;

@end

@implementation SQLiteToCDHelper

@synthesize sqliteFileName;

- (void)dealloc {
    
    [sqliteFileName release];
    
    [super dealloc];
}

- (id)initWithSQLiteFile:(NSString *)sqliteDBName {
    
    self = [super init];
    
    if (self) {
        sqliteFileName = sqliteDBName;
    }
    
    return self;
}

- (void)loadEntity:(NSString *)entity fromTable:(NSString *)table withMapping:(NSDictionary *)attributeMapping {
 
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: [appDelegate persistentStoreCoordinator]];
    NSArray *attributesArray = [attributeMapping allKeys];
//    NSMutableString *attributesString = [[[attributeMapping allKeys] description] mutableCopy];
//    [attributesString replaceOccurrencesOfString:@"(" withString:@"Select " options:NSLiteralSearch range:NSMakeRange(0, [attributesString length])];
//    [attributesString replaceOccurrencesOfString:@")" withString:[NSString stringWithFormat:@" from %@", table] options:NSBackwardsSearch range:NSMakeRange(0, [attributesString length])];
    
//    NSLog(@"%@",attributesString);
    
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        
//        const char *sql = [attributesString UTF8String];
        const char *sql = "select id, latitude, longitude, store, city, address from Store";
        
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);       
                
                NSEntityDescription *entityDescription = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:managedObjectContext];
                
                [entityDescription setValue:[NSNumber numberWithInt:primaryKey] forKey:@"id"];
                [entityDescription setValue:[NSNumber numberWithDouble:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)] doubleValue]] forKey:@"latitude"];
                [entityDescription setValue:[NSNumber numberWithDouble:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)] doubleValue]] forKey:@"longitude"];                
                [entityDescription setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)] forKey:@"store"];
                [entityDescription setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)] forKey:@"city"];
                [entityDescription setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)] forKey:@"address"];
                NSError *error;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@", [error userInfo]);
                }
            }
        }
    } else {
        sqlite3_close(database);
    }
    
}


- (NSString *)getDBPath {
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    documentsDir = [[NSBundle mainBundle] pathForResource:@"McD" ofType:@"sqlite"];
    
    return documentsDir;
}
@end
