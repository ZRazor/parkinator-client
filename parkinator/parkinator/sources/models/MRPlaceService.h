//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRUserData;


@interface MRPlaceService : NSObject

@property MRUserData *userData;

- (void)loadPlacesWithLat:(NSNumber *)lat andLon:(NSNumber *)lon andCarType:(NSString *)carType block:(void (^)(NSError *error, NSArray *items))block;
@end