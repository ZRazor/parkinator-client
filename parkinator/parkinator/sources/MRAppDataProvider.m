//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRAppDataProvider.h"
#import "MRAuthService.h"
#import "MRUserData.h"
#import "MRPlaceService.h"

@interface MRAppDataProvider()

@property (readwrite) MRUserData *userData;
@property (readwrite) MRAuthService *authService;
@property (readwrite) MRPlaceService *placeService;

@end

@implementation MRAppDataProvider

+ (MRAppDataProvider *)shared {
    static dispatch_once_t pred;
    static MRAppDataProvider *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    [self setUserData:[MRUserData loadFromUserDefaults]];
    [self setAuthService:[[MRAuthService alloc] init]];
    [_authService setUserData:_userData];
    [self setPlaceService:[[MRPlaceService alloc] init]];
    [_placeService setUserData:_userData];
    return self;
}


@end