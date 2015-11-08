//
//  MRInititatorStatusViewController.h
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRStatusMapCellView;

@interface MRInititatorStatusViewController : UITableViewController

@property NSNumber *contractId;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherPlaceInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptorCarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptorCarColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptorCarNumberLabel;
@property (weak, nonatomic) IBOutlet MRStatusMapCellView *mapViewCell;
- (IBAction)removePlaceAction:(id)sender;

@end
