//
// Created by ZRazor on 09.04.15.
// Copyright (c) 2015 MAYAK. All rights reserved.
//

#import <CocoaSecurity/CocoaSecurity.h>
#import <SVJsonSchemaValidator/SVType.h>
#import "MRUserData.h"
#import "MRRequester.h"
#import "MRValidateUtils.h"
#import "MRError.h"

@implementation MRUserData {

}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_accessToken forKey:@"accessToken"];
    [coder encodeObject:_phone forKey:@"phone"];
    [coder encodeObject:_carColor forKey:@"carColor"];
    [coder encodeObject:_carModel forKey:@"carModel"];
    [coder encodeObject:_carType forKey:@"carType"];
    [coder encodeObject:_carNumber forKey:@"carNumber"];
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_curPlace forKey:@"curPlace"];
    [coder encodeObject:_balance forKey:@"balance"];
    [coder encodeObject:_initiatedContractId forKey:@"initiatedContractId"];
    [coder encodeObject:_acceptedContractId forKey:@"acceptedContractId"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        _accessToken = [coder decodeObjectForKey:@"accessToken"];
        _phone = [coder decodeObjectForKey:@"phone"];
        _carType = [coder decodeObjectForKey:@"carType"];
        _carModel = [coder decodeObjectForKey:@"carModel"];
        _carColor = [coder decodeObjectForKey:@"carColor"];
        _carNumber = [coder decodeObjectForKey:@"carNumber"];
        _userId = [coder decodeObjectForKey:@"userId"];
        _curPlace = [coder decodeObjectForKey:@"curPlace"];
        _balance = [coder decodeObjectForKey:@"balance"];
        _initiatedContractId = [coder decodeObjectForKey:@"initiatedContractId"];
        _acceptedContractId = [coder decodeObjectForKey:@"acceptedContractId"];
    }

    return self;
}

+ (MRUserData *)loadFromUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:USER_DATA_KEY]) {
        NSData *encodedObject = [defaults objectForKey:USER_DATA_KEY];
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return [[MRUserData alloc] init];
}

- (BOOL)isAuthed
{
    return (_accessToken && ![_accessToken isEqualToString:@""]);
}

- (void)clearData
{
    _phone = nil;
    _accessToken = nil;
    _carColor = nil;
    _carType = nil;
    _carModel = nil;
    _carNumber = nil;
    _userId = nil;
    _curPlace = nil;
    _balance = nil;
    _initiatedContractId = nil;
    _acceptedContractId = nil;
}

- (void)setFromData:(NSDictionary *)data
{
    if (data[@"accessToken"]) {
        [self setAccessToken:data[@"accessToken"]];
    }
    if (data[@"user"]) {
        data = data[@"user"];
        [self setUserId:data[@"id"]];
        [self setCarColor:data[@"carColor"]];
        [self setCarModel:data[@"carModel"]];
        [self setCarNumber:data[@"carNumber"]];
        [self setCarType:data[@"carType"]];
        [self setPhone:data[@"phone"]];
        [self setCurPlace:data[@"curPlace"]];
        [self setBalance:data[@"balance"]];
        [self setInitiatedContractId:data[@"initiatedContractId"]];
        [self setAcceptedContractId:data[@"acceptedContractId"]];
    }
}

- (void)saveToUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:encodedObject forKey:USER_DATA_KEY];
    [defaults synchronize];
}

- (void)loadFromServer:(void (^)(NSError *error, BOOL invalidToken))block
{
    [MRRequester doGetRequest:API_GET_USER_DATA params:@{
            @"accessToken" : _accessToken
    }                   block:^(id result, NSError *error) {
        BOOL invalidToken = NO;
        id schema = [MRValidateUtils getSchemaWithData:@{}];
        id validatedJson = [schema validateJson:result error:&error];
        if (!error) {
            NSDictionary *dictionary = (NSDictionary *) result;
            NSString *strError = dictionary[@"error"];
            if (![strError isEqualToString:API_ERROR_SUCCESS]) {
                if ([strError isEqualToString:API_ERROR_INVALID_TOKEN]) {
                    invalidToken = YES;
                    [self clearData];
                    [self saveToUserDefaults];
                }
                NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:MRAppDomain code:MRGetUserDataError userInfo:errorDetails];
            } else {
                [self setFromData:dictionary[@"data"]];
                [self saveToUserDefaults];
            }
        }
        block(error,invalidToken);
    }];
}

- (void)updateOnServer:(void (^)(NSError *error))block
{
    [MRRequester doPostRequest:[NSString stringWithFormat:API_SET_USER_DATA, _accessToken] params:@{
            @"сarType" : _carType,
            @"carModel" : _carModel,
            @"carColor" : _carColor,
            @"carNumber" : _carNumber,
    } block:^(id result, NSError *error) {
        id schema = [MRValidateUtils getSchemaWithData:@{}];
        id validatedJson = [schema validateJson:result error:&error];
        if (!error) {
            NSDictionary *dictionary = (NSDictionary *)result;
            if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:MRAppDomain code:MRUpdateUserDataError userInfo:errorDetails];
            } else {
                [self setFromData:dictionary[@"data"]];
                [self saveToUserDefaults];
            }
        }
        block(error);
    }];
}

- (void)changePassOnServer:(NSString *)pass oldPass:(NSString *)oldPass block:(void (^)(NSError *error))block
{
    CocoaSecurityResult *md5 = [CocoaSecurity md5:[oldPass stringByAppendingString:HARDWARE_SALT]];
    NSString *hashedPass = [md5 hexLower];
    [MRRequester doPostRequest:[NSString stringWithFormat:API_CHANGE_USER_PASS, _accessToken] params:@{
            @"old" : hashedPass,
            @"new" : pass
    } block:^(id result, NSError *error) {
        id schema = [MRValidateUtils getSchemaWithData:@{}];
        id validatedJson = [schema validateJson:result error:&error];
        if (!error) {
            NSDictionary *dictionary = (NSDictionary *)result;
            if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:MRAppDomain code:MRChangeUserPassError userInfo:errorDetails];
            }
        }
        block(error);
    }];
}




@end