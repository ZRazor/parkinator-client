//
//  MRCarTypeSelectorCell.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRCarTypeSelectorCell.h"
#import <PureLayout/PureLayout.h>
#import "MRConsts.h"

@implementation MRCarTypeSelectorCell

- (void)awakeFromNib {
    _carSegment = [[UICarTypeSelectorView alloc] init];
    [self.contentView addSubview:_carSegment];
    [_carSegment autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_carSegment autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_carSegment autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_carSegment autoSetDimension:ALDimensionWidth toSize:200];
    
    [_carSegment setTintColor:mainColor];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    _carSegment = [[UICarTypeSelectorView alloc] init];
    [self.contentView addSubview:_carSegment];
    [_carSegment autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_carSegment autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_carSegment autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_carSegment autoSetDimension:ALDimensionWidth toSize:160];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
