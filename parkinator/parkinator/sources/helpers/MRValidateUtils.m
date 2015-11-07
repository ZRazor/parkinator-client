//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRValidateUtils.h"


@implementation MRValidateUtils {

}

+ (id)getSchemaWithData:(NSDictionary *)data {
    id schema = [[SVType object]
            properties:@{
                    @"error" : [SVType string],
                    @"msg" : [SVType string],
                    @"data" : [[SVType object] properties:data]
            }];
    return schema;
}


@end