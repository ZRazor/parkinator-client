//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRUserData;

@interface MRAuthService : NSObject

@property MRUserData* userData;

- (void)authWithPhone:(NSString *)phone andPassword:(NSString *)password block:(void (^)(NSError *error))block;

- (void)registerWithPhone:(NSString *)phone andCarType:(NSString *)carType andCarModel:(NSString *)carModel andCarColor:(NSString *)carColor andCarNumber:(NSString *)carNumber block:(void (^)(NSError *error))block;


@end