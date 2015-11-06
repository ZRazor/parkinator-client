//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRAppDataProvider.h"

@interface MRAppDataProvider()

//@property (readwrite) MRAuthService *authService;

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
    return self;
}


@end