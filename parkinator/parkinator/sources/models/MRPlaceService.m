//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRPlaceService.h"
#import "MRRequester.h"
#import "MRValidateUtils.h"
#import "MRPlace.h"
#import "MRUserData.h"
#import "MRError.h"


@implementation MRPlaceService {

}

- (void)createPlaceWithLat:(NSNumber *)lat
                    andLon:(NSNumber *)lon
                andCarType:(NSString *)carType
                  andPrice:(NSNumber *)price
                andAddress:(NSString *)address
                andComment:(NSString *)comment
            andTimeToLeave:(NSNumber *)timeToLeave
        block:(void (^)(NSError *error))block
{
    [MRRequester doPostRequest:API_CREATE_PLACE
                       params:@{
                               @"accessToken": [_userData accessToken],
                               @"lat":lat,
                               @"lon":lon,
                               @"carType":carType,
                               @"price":price,
                               @"address":address,
                               @"comment":comment,
                               @"timeToLeave":timeToLeave
                       }
                        block:^(id result, NSError *error) {
                            if (!error) {
                                NSDictionary *dictionary = (NSDictionary *)result;
                                if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                                    NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                                    [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                                    error = [NSError errorWithDomain:MRAppDomain code:MRCreatePlaceError userInfo:errorDetails];
                                }
                            }
                            if (error) {
                                NSLog(@"Create place error:\n%@", [error userInfo]);
                            }
                            block(error);
                        }];
}

- (void)buyPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error, NSNumber *newPlaceId))block
{
    [MRRequester doPostRequest:API_BUY_PLACE
                        params:@{
                                @"accessToken": [_userData accessToken],
                                @"id":placeId
                        }
                         block:^(id result, NSError *error) {
                             NSNumber *newPlaceId = nil;
                             if (!error) {
                                 NSDictionary *dictionary = (NSDictionary *) result;
                                 if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                                     NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                                     [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                                     error = [NSError errorWithDomain:MRAppDomain code:MRBuyPlaceError userInfo:errorDetails];
                                 } else {
                                     newPlaceId = result[@"data"][@"id"];
                                 }
                             }
                             if (error) {
                                 NSLog(@"Buy place error:\n%@", [error userInfo]);
                             }
                             block(error, newPlaceId);
                         }];
}

- (void)loadPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error, MRPlace *place))block
{
    [MRRequester doGetRequest:API_LOAD_PLACE
                        params:@{
                                @"accessToken": [_userData accessToken],
                                @"id":placeId
                        }
                         block:^(id result, NSError *error) {
                             MRPlace *place = nil;
                             if (!error) {
                                 id schema = [[SVType object]
                                         properties:@{
                                                 @"error" : [SVType string],
                                                 @"msg" : [SVType string],
                                                 @"data" : [MRPlace jsonSchema]
                                         }];

                                 id validatedJson = [schema validateJson:result error:&error];
                                 if (!error) {
                                     NSDictionary *dictionary = [schema instantiateValidatedJson:validatedJson];
                                     if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                                         NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                                         [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                                         error = [NSError errorWithDomain:MRAppDomain code:MRLoadPlaceError userInfo:errorDetails];
                                     } else {

                                     }
                                 }
                             }
                             if (error) {
                                 NSLog(@"Load place error:\n%@", [error userInfo]);
                             }
                             block(error, place);
                         }];
}

- (void)loadPlacesWithLat:(NSNumber *)lat
                   andLon:(NSNumber *)lon
               andCarType:(NSString *)carType
                    block:(void (^)(NSError *error, NSArray *items))block
{
//    [MRRequester doGetRequest:[NSString stringWithFormat:API_GET_ITEM_LIST, @"offer"]
    if (!carType) {
        carType = CAR_TYPE_BIG;
    }
    [MRRequester doGetRequest:API_GET_ITEM_LIST
                       params:@{
                               @"accessToken": [_userData accessToken],
                               @"carType":carType,
                               @"lat":lat,
                               @"lon":lon
                       }
                        block:^(id result, NSError *error) {
                            NSArray *items = nil;
                            if (!error) {
                                id schema = [MRValidateUtils getSchemaWithData:@{
                                        [MRPlace getOrmKey] : [[SVType array] items:[MRPlace jsonSchema]]
                                }];

                                id validatedJson = [schema validateJson:result error:&error];
                                if (!error) {
                                    NSDictionary *dictionary = [schema instantiateValidatedJson:validatedJson];
                                    if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                                        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                                        [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                                        error = [NSError errorWithDomain:MRAppDomain code:MRItemListError userInfo:errorDetails];
                                    } else {
                                        items = [NSMutableArray arrayWithArray:dictionary[@"data"][[MRPlace getOrmKey]]];
                                    }
                                }
                            }
                            if (error) {
                                NSLog(@"Loading items from server error:\n%@", [error userInfo]);
                            }
                            block(error, items);
                        }];

}

//- (void)sendLocationData



@end