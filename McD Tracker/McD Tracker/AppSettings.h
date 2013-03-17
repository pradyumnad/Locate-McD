//
//  AppSettings.h
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (id)sharedSettings;

- (void)initialiseMcDStoresDB;
- (BOOL)isDBInitialised;

@end
