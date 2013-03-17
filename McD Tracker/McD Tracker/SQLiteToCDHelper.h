//
//  SQLiteToCDHelper.h
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteToCDHelper : NSObject {
    NSString *sqliteFileName;
    
}

@property (nonatomic, retain) NSString *sqliteFileName;

- (id)initWithSQLiteFile:(NSString *)sqliteDBName;

- (void)loadEntity:(NSString *)entity fromTable:(NSString *)table withMapping:(NSDictionary *)attributeMapping;

@end
