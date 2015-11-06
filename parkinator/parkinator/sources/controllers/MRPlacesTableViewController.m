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

@interface MRPlacesTableViewController ()

@end

@implementation MRPlacesTableViewController {
    CGFloat prevZoom;
    BOOL mapShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self hideNavBarUnderLine:YES];
    [self.toolBar setDelegate:self];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.1
                                                            longitude:131.9
                                                                 zoom:12];
    prevZoom = 12;
    mapShown = NO;
    MRClusterRenderer *clusterRenderer = [MRClusterRenderer new];
    self.mapView = [[HSClusterMapView alloc] initWithFrame:self.tableView.frame renderer:clusterRenderer];
    [self.mapView setCamera:camera];
    [self.mapView setDelegate:self];
    [self.mapView setClusterSize:0.11];
    [self.mapView setMinimumMarkerCountPerCluster:2];
    [self.mapView setClusteringEnabled:YES];
    [self.view addSubview:self.mapView];
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.toolBar];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (BOOL)mapView:(GMSMapView *)mV didTapMarker:(GMSMarker *)marker {
//    if ([marker isKindOfClass:[HSClusterMarker class]]) {
//        clusterItems = [NSMutableArray new];
//        for (MRItemMarker *itemMarker in ((HSClusterMarker *)marker).markersInCluster) {
//            [clusterItems addObject:itemMarker.item];
//        }
//    } else if ([marker isKindOfClass:[MRItemMarker class]]) {
//        clusterItems = [@[((MRItemMarker *)marker).item] mutableCopy];
//    }
    if (self.tableView.hidden) {
        [self.tableView setHidden:NO];
        [UIView animateWithDuration:1 //this is the length of time the animation will take
                         animations:^{
                             self.mapView.frame = CGRectMake(
                                     self.mapView.frame.origin.x,
                                     self.toolBar.frame.origin.y + self.toolBar.frame.size.height,
                                     self. mapView.frame.size.width,
                                     self.tableView.frame.origin.y - (self.toolBar.frame.origin.y + self.toolBar.frame.size.height))
                                     ;
                         }
                         completion:^(BOOL finished) {

                         }];
    }
    return NO;
}

- (void)mapView:(GMSMapView *)mV didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [UIView animateWithDuration:1 //this is the length of time the animation will take
                     animations:^{
                         self.mapView.frame = self.tableView.frame;
                     }
                     completion:^(BOOL finished){
                         [self.tableView setHidden:YES];
                     }];

//    MRItemMarker *marker = [MRItemMarker markerWithPosition:coordinate];
//    [marker setAppearAnimation:kGMSMarkerAnimationPop];
//    [mapView addMarker:marker];
//    [mapView cluster];
}

- (IBAction)viewTypeSegmentChange:(UISegmentedControl *)sender {
    mapShown = !mapShown;
    [self.mapView setHidden:!mapShown];
    [self.tableView setHidden:mapShown];

    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    if (!mapShown) {
        self.mapView.frame = self.tableView.frame;
    } else {

    }
}
@end
