//
//  MRMapCellView.h
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MRMapCellView : UITableViewCell <GMSMapViewDelegate>

@property GMSMapView *mapView;
@property UILabel *addressLabel;
@property UIImageView *markerImageView;

@end
