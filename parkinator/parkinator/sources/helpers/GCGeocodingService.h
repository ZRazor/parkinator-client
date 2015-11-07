//
//  GCGeocodingService.h
//  GeocodingAPISample
//
//  Created by Mano Marks on 4/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GCGeocodingService : NSObject

- (id)init;
- (void)geocodeAddress:(NSString *)address
          withCallback:(SEL)callback
          withDelegate:(id)delegate;

- (void)geocodeCoordinate:(CLLocationCoordinate2D)coordinate withCallback:(SEL)sel withDelegate:(id)delegate;

@property (nonatomic, strong) NSDictionary *geocode;

@end
