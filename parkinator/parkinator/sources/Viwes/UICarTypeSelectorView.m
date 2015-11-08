//
//  UICarTypeSelectorView.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "UICarTypeSelectorView.h"
#import <PureLayout/PureLayout.h>

@implementation UICarTypeSelectorView

- (instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }

    _carControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"small"],
                                                                                 [UIImage imageNamed:@"middle"],
                                                                                 [UIImage imageNamed:@"big"]]];
    [_carControl setContentMode:UIViewContentModeScaleAspectFill];
    
//    UISegmentedControl *carControl = [[UISegmentedControl alloc] initWithItems:@[@"Маленькая", @"Средняя", @"Большая"]];
    
    [self addSubview:_carControl];
    
    [_carControl autoPinEdgesToSuperviewEdges];
    
    return self;
}

@end
