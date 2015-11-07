//
//  GCGeocodingService.m
//  GeocodingAPISample
//
//  Created by Mano Marks on 4/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

//#define kBgQueue dispatch_get_main_queue()(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "GCGeocodingService.h"

@implementation GCGeocodingService {
}

@synthesize geocode;

- (id)init {
    self = [super init];
    geocode = @{@"lat" : @"0.0", @"lng" : @"0.0", @"address" : @"Null Island", @"error" : @"Место не найдено"};
    return self;
}

- (void)geocodeAddress:(NSString *)address withCallback:(SEL)sel withDelegate:(id)delegate {

    NSString *city = @"Владивосток";
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&components=administrative_area:%@&sensor=false", geocodingBaseUrl, address, city];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        
        [self fetchedData:data withCallback:sel withDelegate:delegate];
        
    });
    
}

- (void)geocodeCoordinate:(CLLocationCoordinate2D)coordinate withCallback:(SEL)sel withDelegate:(id)delegate
{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@latlng=%f,%f&sensor=false", geocodingBaseUrl,coordinate.latitude, coordinate.longitude];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];

        [self fetchedData:data withCallback:sel withDelegate:delegate];

    });
}

- (void)fetchedData:(NSData *)data withCallback:(SEL)sel withDelegate:(id)delegate{

    if (!data) {
        [delegate performSelector:sel];
        return;
    }
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
             JSONObjectWithData:data
             options:kNilOptions
             error:&error];

    if (error) {
        NSLog(@"Fetch map error:\n %@", [error localizedDescription]);
        [delegate performSelector:sel];
        return;
    }
    NSArray* results = json[@"results"];
    if (!results || [results count] == 0) {
        [delegate performSelector:sel];
        return;
    }
    NSDictionary *result = results[0];
    NSString *address = result[@"formatted_address"];
    NSDictionary *geometry = result[@"geometry"];
    NSDictionary *location = geometry[@"location"];
    NSString *lat = location[@"lat"];
    NSString *lng = location[@"lng"];

    NSDictionary *gc = @{@"lat" : lat, @"lng" : lng, @"address" : address};
    
    geocode = gc;
    [delegate performSelector:sel];
}


@end

