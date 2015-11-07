//
//  MRAuthTextField.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRAuthTextField.h"

@implementation MRAuthTextField

- (instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 12);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 12);
}



@end
