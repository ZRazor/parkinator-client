//
//  MRSettingsTableViewController.h
//  parkinator
//
//  Created by Anton Zlotnikov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRSubmitButton;

@interface MRSettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *carColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carTypeImageView;
- (IBAction)logoutAction:(MRSubmitButton *)sender;
@end
