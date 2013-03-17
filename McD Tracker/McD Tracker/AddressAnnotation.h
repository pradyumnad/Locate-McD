//
//  AddressAnnotation.h
//  McD Tracker
//
//  Created by Pradyumna Doddala on 5/26/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) c;
@end
