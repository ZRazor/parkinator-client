#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@class MRPlace;

@interface MRPlaceMarker : GMSMarker

@property MRPlace *place;

@end