//
//  AppSettings.m
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

#define DB_INITIALIZER_KEY @"isDBInitialized"


+ (id)sharedSettings {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void)initialiseMcDStoresDB {
    if ([self isDBInitialised]) {   //It means the stores data was already in the coredata
        return;
    } else {    //import the data to coredata
        
        
    }
}

- (BOOL)isDBInitialised {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DB_INITIALIZER_KEY];
}

@end
