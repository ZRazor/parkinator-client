//
//  MRPlaceViewController.m
//  parkinator
//
//  Created by Anton Zlotnikov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRPlaceViewController.h"
#import "MRPlace.h"
#import "MRConsts.h"
#import "MRSubmitButton.h"
#import "MRAppDataProvider.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface MRPlaceViewController ()

@end

@implementation MRPlaceViewController {
    UIScrollView *scrollView;
    UILabel *priceLabel;
    UILabel *commentLabel;
    UILabel *addressLabel;
    UILabel *timeLabel;
    MRSubmitButton *buyButton;
    GMSMapView *mapView;
    float screenWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    screenWidth = [[UIScreen mainScreen] bounds].size.width;

    scrollView = [[UIScrollView alloc] initWithFrame:[self.view frame]];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setAlwaysBounceVertical:NO];

    [self setTitle:@"Место"];
//    [self setTitle:[_place address]];

    [self setView:scrollView];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[_place lat] floatValue]
                                                            longitude:[[_place lon] floatValue]
                                                                 zoom:16];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenWidth, 200) camera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setPosition:[camera target]];
    [marker setSnippet:[_place address]];
    [marker setAppearAnimation:kGMSMarkerAnimationPop];
    [marker setIcon:[UIImage imageNamed:@"marker"]];
    [marker setMap:mapView];

    [scrollView addSubview:mapView];

    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, mapView.frame.size.height - 30, screenWidth, 30)];
    [blackView setBackgroundColor:mainColor];
    [scrollView addSubview:blackView];

    addressLabel = [[UILabel alloc] initWithFrame:blackView.frame];
    [addressLabel setTextColor:[UIColor whiteColor]];
    [addressLabel setText:_place.address];
    [addressLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:addressLabel];
    
    UIImageView *priceView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 35, 225, 15, 15)];
    [priceView setImage:[UIImage imageNamed:@"price"]];
    [scrollView addSubview:priceView];

    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 130, 217, 90, 30)];
    [priceLabel setText:[NSString stringWithFormat:@"%@", _place.price]];
    [priceLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    [scrollView addSubview:priceLabel];
    
    
    UIImageView *timeView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 225, 15, 15)];
    [timeView setImage:[UIImage imageNamed:@"clock"]];
    [scrollView addSubview:timeView];

    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 218, screenWidth - 140, 30)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_place.leaveDt longValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *leaveDtStr = [format stringFromDate:date];
    [timeLabel setText:[NSString stringWithFormat:@"%@ (%d минут)", leaveDtStr,
                        MAX(((int)([_place.leaveDt longValue] - [[NSDate date] timeIntervalSince1970])/60),0)]];
    
    [timeLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [scrollView addSubview:timeLabel];

    UILabel *__commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 240, screenWidth - 16, 25)];
    [__commentLabel setText:@"Комментарий"];
//    [scrollView addSubview:__commentLabel];

    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, screenWidth - 40, 25)];
    [commentLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [commentLabel setText:_place.comment];
    [scrollView addSubview:commentLabel];
    [self resizeHeightForLabel:commentLabel];

    float x = (screenWidth - 280) / 2;
    buyButton = [[MRSubmitButton alloc] initWithFrame:CGRectMake(x, 270 + commentLabel.frame.size.height + 30, 280, 40)];
    [buyButton setTitle:@"Купить" forState:UIControlStateNormal];
    [scrollView addSubview:buyButton];
    [buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];

    [scrollView setContentSize:CGSizeMake(screenWidth, buyButton.frame.origin.y + buyButton.frame.size.height + 10)];

//    if ([[MRAppDataShared userData] acceptedContractId] || [[MRAppDataShared userData] initiatedContractId]) {
//        //TODO do some other disign
//        [buyButton setEnabled:NO];
//    }

}

- (void)viewDidAppear:(BOOL)animated {
//    if ([[[MRAppDataShared userData] acceptedContractId] isEqualToNumber:_place.id]) {
//        //TODO do some other disign
//        [buyButton setEnabled:NO];
//        [buyButton setTitle:@"Куплено" forState:UIControlStateNormal];
//
//    } else {
//        [buyButton setEnabled:YES];
//        [buyButton setTitle:@"Купить" forState:UIControlStateNormal];
//    }
}

- (void)buyAction {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MRAppDataShared.placeService buyPlaceWithId:_place.id
                                          andLat:@(MRAppDataShared.locationManager.location.coordinate.latitude)
                                          andLon:@(MRAppDataShared.locationManager.location.coordinate.longitude)
                                           block:
                                                   ^(NSError *error, NSNumber *number) {
                                                       [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            SCLAlertView *newAlert = [[SCLAlertView alloc] init];
            [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
        } else {
            [MRAppDataShared setAcceptor:number appLaunched:NO];
//            [buyButton setTitle:@"Куплено" forState:UIControlStateNormal];
//            [buyButton setEnabled:NO];
        }
                                                       NSLog(@"buy with %@", number);
                                                   }];
}

- (void)resizeHeightForLabel:(UILabel *)label {
    UIView *superview = [label superview];
    [label setNumberOfLines:0];
    [label removeFromSuperview];
    [label removeConstraints:[label constraints]];
    CGRect labelFrame = [label frame];
    CGRect expectedFrame = [[label text] boundingRectWithSize:CGSizeMake([label frame].size.width, 9999)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName : [label font]}
                                                      context:nil];
    labelFrame.size = expectedFrame.size;
    labelFrame.size.height = ceil(labelFrame.size.height); //iOS7 is not rounding up to the nearest whole number
    [label setFrame:labelFrame];
    [superview addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
