//
// Created by ZRazor on 09.04.15.
// Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRUserData : NSObject

@property NSString *accessToken;
@property NSString *phone;
@property NSString *carColor;
@property NSString *carModel;
@property NSString *carNumber;
@property NSNumber *balance;
@property NSString *carType;
@property NSNumber *userId;
@property NSNumber *curPlace;

@property NSNumber *initiatedContractId;
@property NSNumber *acceptedContractId;

+ (MRUserData *)loadFromUserDefaults;
- (void)saveToUserDefaults;
- (BOOL)isAuthed;
- (void)clearData;
- (void)setFromData:(NSDictionary *)data;
- (void)updateOnServer:(void (^)(NSError *error))block;
- (void)changePassOnServer:(NSString *)pass oldPass:(NSString *)oldPass block:(void (^)(NSError *error))block;
- (void)loadFromServer:(void (^)(NSError *error, BOOL invalidToken))block;

@end