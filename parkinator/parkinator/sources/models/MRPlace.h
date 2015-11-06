//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRPlace : NSObject

@property NSNumber *id;
@property NSString *phone;
@property NSString *comment;
@property NSNumber *price;
@property NSString *carType;
@property NSString *carModel;
@property NSString *carNumber;
@property NSString *carColor;
@property NSString *address;
@property NSNumber *lat;
@property NSNumber *lon;
@property NSNumber *dist;
@property NSNumber *leaveDt;

+ (NSString *)getOrmKey;

@end