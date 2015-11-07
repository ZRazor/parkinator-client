//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MRUserData.h"
#import "MRAuthService.h"
#import "MRPlaceService.h"
#import <GoogleMaps/GoogleMaps.h>

#define MRAppDataShared [MRAppDataProvider shared]

@interface MRAppDataProvider : NSObject

@property CLLocationManager *locationManager;

@property (nonatomic, strong, readonly) MRUserData *userData;
@property (nonatomic, strong, readonly) MRAuthService *authService;
@property (nonatomic, strong, readonly) MRPlaceService *placeService;

+ (MRAppDataProvider *)shared;

// clue for improper use (produces compile time error)
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call shared instead")));
- (instancetype)init __attribute__((unavailable("init not available, call shared instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call shared instead")));

@end