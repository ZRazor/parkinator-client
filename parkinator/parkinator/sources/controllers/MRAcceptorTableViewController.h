//
//  MRAcceptorTableViewController.h
//  parkinator
//
//  Created by Anton Zlotnikov on 08.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRStatusMapCellView;

@interface MRAcceptorTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet MRStatusMapCellView *mapCell;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)cancelAction:(id)sender;

@property NSNumber *contractId;

@end
