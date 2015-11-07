//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRUserData;
@class MRPlace;


@interface MRPlaceService : NSObject

@property MRUserData *userData;

- (void)createPlaceWithLat:(NSNumber *)lat andLon:(NSNumber *)lon andCarType:(NSString *)carType andPrice:(NSNumber *)price andComment:(NSString *)comment andTimeToLeave:(NSNumber *)timeToLeave block:(void (^)(NSError *error))block;

- (void)buyPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error))block;

- (void)loadPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error, MRPlace *place))block;

- (void)loadPlacesWithLat:(NSNumber *)lat andLon:(NSNumber *)lon andCarType:(NSString *)carType block:(void (^)(NSError *error, NSArray *items))block;
@end