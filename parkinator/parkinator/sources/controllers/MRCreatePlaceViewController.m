//
//  MRCreatePlaceViewController.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "MRCreatePlaceViewController.h"
#import "MRCarTypeSelectorCell.h"
#import "MRAppDataProvider.h"
#import "MRPlace.h"
#import "MRMapCellView.h"
#import "MRSubmitButton.h"
#import "SCLAlertView.h"
#import "MRNavigationController.h"
#import "MRInititatorStatusViewController.h"
#import "MRTabBarController.h"

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

    NSString *carType = MRAppDataShared.userData.carType;
    NSInteger selIndex = 0;
    if ([carType isEqualToString:CAR_TYPE_MIDDLE]) {
        selIndex = 1;
    } else if ([carType isEqualToString:CAR_TYPE_BIG]) {
        selIndex = 2;
    }

    [self.carTypeCell.carSegment.carControl setSelectedSegmentIndex:selIndex];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)addPlaceAction:(MRSubmitButton *)sender {
    NSString *carType = CAR_TYPE_SMALL;
    if (self.carTypeCell.carSegment.carControl.selectedSegmentIndex == 1) {
        carType = CAR_TYPE_MIDDLE;
    } else if (self.carTypeCell.carSegment.carControl.selectedSegmentIndex == 2) {
        carType = CAR_TYPE_BIG;
    }
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MRAppDataShared.placeService createPlaceWithLat:self.mapCell.lat
    andLon:self.mapCell.lon
    andCarType:carType
    andPrice:[f numberFromString:self.priceLabel.text]
                                          andAddress:self.mapCell.addressLabel.text
    andComment:self.commentTextView.text
    andTimeToLeave:@((int)self.minutesSlider.value)
    block:
            ^(NSError *error, NSNumber *newPlaceId) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if (error) {
                    NSLog(@"%@", [error localizedDescription]);
                    SCLAlertView *newAlert = [[SCLAlertView alloc] init];
                    [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
                } else {
                    [MRAppDataShared.authService.userData setInitiatedContractId:newPlaceId];
                    [MRAppDataShared.authService.userData saveToUserDefaults];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [MRAppDataShared setInititator:newPlaceId];
                    }];
                }
            }];

}
@end
