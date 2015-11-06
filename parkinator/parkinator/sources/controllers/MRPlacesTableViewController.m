//
//  MRPlacesTableViewController.m
//  parkinator
//
//  Created by Anton Zlotnikov on 06.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRPlacesTableViewController.h"
#import "MBProgressHUD.h"
#import "MRClusterRenderer.h"
#import "HSClusterMarker.h"
#import "MRAppDataProvider.h"
#import "MRPlaceService.h"
#import "MRUserData.h"
#import "MRPlace.h"
#import "MRPlaceMarker.h"
#import "MRPlaceTableViewCell.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface MRPlacesTableViewController ()

@end

@implementation MRPlacesTableViewController {
    UIRefreshControl* refreshControl;
    CLLocationManager *locationManager;
    CGFloat prevZoom;
    BOOL mapShown;
    NSMutableArray *items;
    NSMutableArray *itemsCopy;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearItems];

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self hideNavBarUnderLine:YES];
    [self.toolBar setDelegate:self];
    prevZoom = 12;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.1
                                                            longitude:131.9
                                                                 zoom:prevZoom];
    mapShown = NO;
    MRClusterRenderer *clusterRenderer = [MRClusterRenderer new];
    self.mapView = [[HSClusterMapView alloc] initWithFrame:self.view.frame renderer:clusterRenderer];
    [self.mapView setHidden:YES];
    [self.mapView setCamera:camera];
    [self.mapView setDelegate:self];
    [self.mapView setClusterSize:0.11];
    [self.mapView setMinimumMarkerCountPerCluster:2];
    [self.mapView setClusteringEnabled:YES];
    [self.view addSubview:self.mapView];
//    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.toolBar];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@""]];
    [refreshControl addTarget:self action: @selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];

    [self loadItemsFromServer];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideNavBarUnderLine:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self hideNavBarUnderLine:NO];
    if (self.isMovingFromParentViewController) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return  UIBarPositionTop; //or UIBarPositionTopAttached
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNavBarUnderLine:(BOOL)hide {
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 2) {
                [view2 setHidden:hide];
            }
        }
    }
}

- (void)showAlertForError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    SCLAlertView *newAlert = [[SCLAlertView alloc] init];
    [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
}


- (void)clearItems {
    items = [NSMutableArray new];
    [self.tableView reloadData];
}

- (void)refreshTable {
    [self loadItemsFromServer];
    [refreshControl endRefreshing];
}

- (void)loadItemsFromServer {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MRAppDataShared.placeService loadPlacesWithLat:@(locationManager.location.coordinate.latitude)
                                             andLon:@(locationManager.location.coordinate.longitude)
                                         andCarType:MRAppDataShared.userData.carType
                                              block:^(NSError *error, NSArray *newItems) {
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  if (!error) {
                                                      items = [newItems mutableCopy];
                                                      [self.tableView reloadData];
                                                      for (MRPlace *place in items) {
                                                          MRPlaceMarker *marker = [MRPlaceMarker markerWithPosition:CLLocationCoordinate2DMake([place.lat doubleValue], [place.lon doubleValue])];
                                                          [marker setAppearAnimation:kGMSMarkerAnimationPop];
                                                          [marker setPlace:place];
//                                                              [marker setIcon:[UIImage imageNamed:@"map_marker"]];
                                                          [self.mapView addMarker:marker];
                                                      }
                                                      [self.mapView cluster];
                                                  } else {
                                                      [self showAlertForError:error];
                                                  }

                                              }];

}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRPlaceTableViewCell *cell = (MRPlaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];
    
    MRPlace *place = items[indexPath.row];
    [cell.addressLabel setText:place.address];
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%@м", place.dist]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"%@Р", place.price]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[place.leaveDt longValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *leaveDtStr = [format stringFromDate:date];

    [cell.timeLabel setText:[NSString stringWithFormat:@"в %@", leaveDtStr]];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)mapView:(GMSMapView *)mV didChangeCameraPosition:(GMSCameraPosition *)position {
    if (position.zoom != prevZoom) {
        prevZoom = position.zoom;
        [self.mapView cluster];
    }
}

- (BOOL)mapView:(GMSMapView *)mV didTapMarker:(GMSMarker *)marker {
    if ([marker isKindOfClass:[HSClusterMarker class]]) {
        items = [NSMutableArray new];
        for (MRPlaceMarker *placeMarker in ((HSClusterMarker *)marker).markersInCluster) {
            [items addObject:placeMarker.place];
        }
    } else if ([marker isKindOfClass:[MRPlaceMarker class]]) {
        items = [@[((MRPlaceMarker *)marker).place] mutableCopy];
    }
    [self.tableView reloadData];
    if (self.tableView.hidden) {
        [self.tableView setHidden:NO];
        [UIView animateWithDuration:1 //this is the length of time the animation will take
                         animations:^{
                             self.mapView.frame = CGRectMake(
                                     self.mapView.frame.origin.x,
                                     self.toolBar.frame.origin.y + self.toolBar.frame.size.height,
                                     self.mapView.frame.size.width,
                                     200
                             );

                         }
                         completion:^(BOOL finished) {

                         }];
    }
    return NO;
}

- (void)mapView:(GMSMapView *)mV didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [UIView animateWithDuration:1 //this is the length of time the animation will take
                     animations:^{
                         self.mapView.frame = self.view.frame;
                     }
                     completion:^(BOOL finished){
                         [self.tableView setHidden:YES];
                         items = itemsCopy;
                     }];

}

- (IBAction)viewTypeSegmentChange:(UISegmentedControl *)sender {
    mapShown = !mapShown;
    [self.mapView setHidden:!mapShown];
    [self.tableView setHidden:mapShown];

    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    if (!mapShown) {
        items = itemsCopy;
        self.tableViewTopConstaint.constant = 44.0f;
    } else {
        itemsCopy = items;
        self.tableViewTopConstaint.constant = 200.0f + 44.0f;
    }
    self.mapView.frame = self.view.frame;
    [self.tableView setNeedsLayout];
    [self.tableView reloadData];
}
@end
