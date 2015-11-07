//
//  MRTabBarController.m
//  parkinator
//
//  Created by Anton Zlotnikov on 06.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRTabBarController.h"
#import "MRPlacesTableViewController.h"
#import "MRNavigationController.h"
#import "MRSettingsTableViewController.h"
#import "MRAppDataProvider.h"
#import "MRLoginViewController.h"
#import "MRStatusViewController.h"

@interface MRTabBarController ()

@end

@implementation MRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self.tabBar setTranslucent:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];

    UIStoryboard *placesStoryboard = [UIStoryboard storyboardWithName:@"places" bundle:nil];
    MRPlacesTableViewController *placesTableViewController = [placesStoryboard instantiateViewControllerWithIdentifier:@"placesController"];
    MRNavigationController *placesNavigationController = [[MRNavigationController alloc] initWithRootViewController:placesTableViewController];
    [placesNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Места" image:[UIImage imageNamed:@"list_tab"] selectedImage:nil]];

    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"settings" bundle:nil];
    MRSettingsTableViewController *settingsTableViewController = [settingsStoryboard instantiateViewControllerWithIdentifier:@"settingsController"];
    MRNavigationController *settingsNavigationController = [[MRNavigationController alloc] initWithRootViewController:settingsTableViewController];
    [settingsNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Аккаунт" image:[UIImage imageNamed:@"user_tab"] selectedImage:nil]];

    UIStoryboard *statusStoryboard = [UIStoryboard storyboardWithName:@"statusView" bundle:nil];
    MRStatusViewController *statusViewController = [statusStoryboard instantiateViewControllerWithIdentifier:@"inititatorController"];
    MRNavigationController *statusNavigationController = [[MRNavigationController alloc] initWithRootViewController:statusViewController];
    [statusNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Текущий" image:nil selectedImage:nil]];



    [self setViewControllers:@[
            placesNavigationController,
            statusNavigationController,
            settingsNavigationController
    ]];

    [self.tabBar.items[1] setEnabled:NO];

    [[[MRAppDataProvider shared] userData] loadFromServer:^(NSError *error, BOOL invalidToken) {
        if (invalidToken) {
            MRLoginViewController *loginViewController = [[MRLoginViewController alloc] init];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginViewController];
        } else {
            if (MRAppDataShared.userData.initiatedContractId) {
                MRStatusViewController *statusViewController = ((MRNavigationController *)self.viewControllers[1]).visibleViewController;
                [statusViewController setContractId:MRAppDataShared.userData.initiatedContractId];
                [self.tabBar.items[1] setEnabled:YES];
            }
        }
    }];

//    if ()


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
