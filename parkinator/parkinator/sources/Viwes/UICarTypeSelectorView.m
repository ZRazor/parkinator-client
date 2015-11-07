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

    UISegmentedControl *carControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"small"],
                                                                                 [UIImage imageNamed:@"medium"],
                                                                                 [UIImage imageNamed:@"big"]]];
    [carControl setContentMode:UIViewContentModeScaleAspectFill];
    
//    UISegmentedControl *carControl = [[UISegmentedControl alloc] initWithItems:@[@"Маленькая", @"Средняя", @"Большая"]];
    
    [self addSubview:carControl];
    
    [carControl autoPinEdgesToSuperviewEdges];
    
    return self;
}

@end
