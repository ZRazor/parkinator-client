//
//  MRCreatePlaceViewController.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRCreatePlaceViewController.h"

@implementation MRCreatePlaceViewController
{
    float leftTime;
}

- (IBAction)changeTimeValue:(UISlider *)sender {
    leftTime = sender.value;
    [_timeLabel setText: [NSString stringWithFormat:@"%2.0f", floorf(leftTime)]];
}

- (instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    leftTime = 15.0f;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setTitle:@"Добавить место"];
}

@end
