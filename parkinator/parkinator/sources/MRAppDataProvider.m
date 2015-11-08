//
// Created by Anton Zlotnikov on 06.11.15.
// Copyright (c) 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRAppDataProvider.h"
#import "MRAuthService.h"
#import "MRUserData.h"
#import "MRPlaceService.h"
#import "MRTabBarController.h"
#import "MRInititatorStatusViewController.h"
#import "MRNavigationController.h"
#import "MRAcceptorTableViewController.h"

@interface MRAppDataProvider()

@property (readwrite) MRUserData *userData;
@property (readwrite) MRAuthService *authService;
@property (readwrite) MRPlaceService *placeService;

@end

@implementation MRAppDataProvider

+ (MRAppDataProvider *)shared {
    static dispatch_once_t pred;
    static MRAppDataProvider *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    [self setUserData:[MRUserData loadFromUserDefaults]];
    [self setAuthService:[[MRAuthService alloc] init]];
    [_authService setUserData:_userData];
    [self setPlaceService:[[MRPlaceService alloc] init]];
    [_placeService setUserData:_userData];
    return self;
}

- (void)setInititator:(NSNumber *)placeId appLaunched:(BOOL)appLaunched {
    if (!placeId && !self.userData.initiatedContractId) {
        return;
    }
    [self.userData setInitiatedContractId:placeId];
    [self.userData saveToUserDefaults];
    if (self.tabBarController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (placeId) {
                NSMutableArray *newCntrlers = [self.tabBarController.viewControllers mutableCopy];
                UIStoryboard *statusStoryboard = [UIStoryboard storyboardWithName:@"statusView" bundle:nil];
                MRInititatorStatusViewController *statusViewController = [statusStoryboard instantiateViewControllerWithIdentifier:@"inititatorController"];
                [statusViewController setContractId:placeId];
                MRNavigationController *statusNavigationController = [[MRNavigationController alloc] initWithRootViewController:statusViewController];
                [statusNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Текущий" image:[UIImage imageNamed:@"checkcheck"] selectedImage:[UIImage imageNamed:@"checkcheck"]]];
                newCntrlers[1] = statusNavigationController;
                [self.tabBarController setViewControllers:newCntrlers];
                [self.tabBarController.tabBar.items[1] setEnabled:YES];
                if (!appLaunched) {
                    [self.tabBarController setSelectedIndex:1];
                }
            } else {
                if (self.tabBarController.selectedIndex == 1) {
                    [self.tabBarController setSelectedIndex:0];
                }
                [self.tabBarController.tabBar.items[1] setEnabled:NO];
            }
        });
    }
}

//покупатель

- (void)setAcceptor:(NSNumber *)placeId appLaunched:(BOOL)appLaunched{
    if (!placeId && !self.userData.acceptedContractId) {
        return;
    }
    [self.userData setAcceptedContractId:placeId];
    [self.userData saveToUserDefaults];
    if (self.tabBarController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (placeId && !self.userData.initiatedContractId) {
                NSMutableArray *newCntrlers = [self.tabBarController.viewControllers mutableCopy];
                UIStoryboard *statusStoryboard = [UIStoryboard storyboardWithName:@"statusView" bundle:nil];
                MRAcceptorTableViewController *statusViewController = [statusStoryboard instantiateViewControllerWithIdentifier:@"acceptorController"];
                [statusViewController setContractId:placeId];
                MRNavigationController *statusNavigationController = [[MRNavigationController alloc] initWithRootViewController:statusViewController];
                [statusNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Текущий" image:[UIImage imageNamed:@"checkcheck"] selectedImage:[UIImage imageNamed:@"checkcheck"]]];
                newCntrlers[1] = statusNavigationController;
                [self.tabBarController setViewControllers:newCntrlers];
                [self.tabBarController.tabBar.items[1] setEnabled:YES];
                if (!appLaunched) {
                    [self.tabBarController setSelectedIndex:1];
                }
            } else {
                if (self.tabBarController.selectedIndex == 1) {
                    [self.tabBarController setSelectedIndex:0];
                }
                [self.tabBarController.tabBar.items[1] setEnabled:NO];
            }
        });
    }
}

@end