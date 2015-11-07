//
// Created by Anton Zlotnikov on 12.10.15.
// Copyright (c) 2015 MAYAK. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <SCLAlertView-Objective-C/SCLMacros.h>
#import "MRClusterRenderer.h"
#import "MRConsts.h"

@implementation MRClusterRenderer {

}

- (UIImage *)imageForClusterWithCount:(NSUInteger)count {
    // Get the number of digits in the count
    NSString *countString = [NSString stringWithFormat:@"%d", (int)count];

    // Set up the cluster view
    CGFloat widthAndHeight = (30 + 5 * countString.length) * sqrt(MIN(count, 32)) / 2;
    UIView *clusterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthAndHeight, widthAndHeight)];
    clusterView.backgroundColor = [mainColor colorWithAlphaComponent:0.8];
    clusterView.layer.masksToBounds = YES;
    clusterView.layer.borderColor = [mainColor CGColor];
    clusterView.layer.borderWidth = 1;
    clusterView.layer.cornerRadius = clusterView.bounds.size.width / 2.0;

    // Add the number label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:clusterView.frame];
    numberLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:18];
    numberLabel.textColor = TEXT_COLOR;
    numberLabel.text = countString;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [clusterView addSubview:numberLabel];

    // Generate an image from the view
    UIGraphicsBeginImageContextWithOptions(clusterView.bounds.size, NO, 0.0);
    [clusterView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return icon;
}

@end