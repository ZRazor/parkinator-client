//
//  MRCreatePlaceViewController.h
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRCarTypeSelectorCell;
@class MRMapCellView;
@class MRSubmitButton;

@interface MRCreatePlaceViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MRCarTypeSelectorCell *carTypeCell;
@property (weak, nonatomic) IBOutlet UISlider *minutesSlider;
@property (weak, nonatomic) IBOutlet MRMapCellView *mapCell;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)addPlaceAction:(MRSubmitButton *)sender;

@end
