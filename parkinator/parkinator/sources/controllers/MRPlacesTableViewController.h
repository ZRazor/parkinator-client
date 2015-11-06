//
//  MRPlacesTableViewController.h
//  parkinator
//
//  Created by Anton Zlotnikov on 06.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HSClusterMapView.h"


@interface MRPlacesTableViewController : UIViewController <UITableViewDelegate,
        UITableViewDataSource, UIToolbarDelegate, GMSMapViewDelegate, UIBarPositioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeSegment;
@property HSClusterMapView *mapView;

- (IBAction)viewTypeSegmentChange:(UISegmentedControl *)sender;

@end
