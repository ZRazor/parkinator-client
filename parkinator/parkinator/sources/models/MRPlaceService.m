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

- (void)buyPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error))block
{
    [MRRequester doPostRequest:API_BUY_PLACE
                        params:@{
                                @"accessToken": [_userData accessToken],
                                @"id":placeId
                        }
                         block:^(id result, NSError *error) {
                             if (!error) {
                                 NSDictionary *dictionary = (NSDictionary *)result;
                                 if (![dictionary[@"error"] isEqualToString:API_ERROR_SUCCESS]) {
                                     NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
                                     [errorDetails setValue:dictionary[@"msg"] forKey:NSLocalizedDescriptionKey];
                                     error = [NSError errorWithDomain:MRAppDomain code:MRBuyPlaceError userInfo:errorDetails];
                                 }
                             }
                             if (error) {
                                 NSLog(@"Buy place error:\n%@", [error userInfo]);
                             }
                             block(error);
                         }];
}

- (void)loadPlaceWithId:(NSNumber *)placeId block:(void (^)(NSError *error, MRPlace *place))block
{
    [MRRequester doPostRequest:API_BUY_PLACE
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

//    MRPlace *place1 = [[MRPlace alloc] init];
//    [place1 setAddress:@"Хуй"];
//    [place1 setDist:@120];
//    [place1 setPrice:@500];
//    [place1 setLeaveDt:@11356];
//    [place1 setLat:@43.123];
//    [place1 setLon:@131.922];
//
//    MRPlace *place2 = [[MRPlace alloc] init];
//    [place2 setAddress:@"Хуй 2222"];
//    [place2 setDist:@8000];
//    [place2 setPrice:@777];
//    [place2 setLeaveDt:@17043];
//    [place2 setLat:@43.123];
//    [place2 setLon:@131.912];
//    block(nil, @[
//            place1,
//            place2
//    ]);
//    return;
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
@end