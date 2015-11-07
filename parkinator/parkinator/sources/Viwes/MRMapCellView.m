//
//  MRMapCellView.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRMapCellView.h"
#import "MRConsts.h"
#import "GCGeocodingService.h"
#import "MRAppDataProvider.h"

@implementation MRMapCellView {
    BOOL locationDragged;
    GCGeocodingService *gs;
}

- (void)awakeFromNib {

    locationDragged = NO;
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CLLocationDegrees lat = MRAppDataShared.locationManager.location.coordinate.latitude;
    CLLocationDegrees lon = MRAppDataShared.locationManager.location.coordinate.longitude;

    if (lat == 0)
        lat = 43.1;
    if (lon == 0)
        lon = 131.9;

    [self setLat:@(lat)];
    [self setLon:@(lon)];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:14];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,0,screenWidth,self.frame.size.height) camera:camera];
    [self addSubview:_mapView];

    [_mapView setDelegate:self];

    _markerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_mapView.frame.size.width / 2 - 13, _mapView.frame.size.height / 2 - 20, 23.5, 40)];
    [_markerImageView setImage:[UIImage imageNamed:@"marker"]];
    [self addSubview:_markerImageView];

    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,0,screenWidth - 16,25)];
    [_addressLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_addressLabel setTextColor:[UIColor whiteColor]];

    UIView *backForAddress = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth,25)];
    [backForAddress setBackgroundColor:[mainColor colorWithAlphaComponent:0.9]];

    [self addSubview:backForAddress];
    [self addSubview:_addressLabel];

    gs = [[GCGeocodingService alloc] init];
    [gs geocodeCoordinate:camera.target withCallback:@selector(setAddress) withDelegate:self];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    locationDragged = YES;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if (locationDragged) {
        locationDragged = NO;
        [self setLat:@(position.target.latitude)];
        [self setLon:@(position.target.longitude)];
        [gs geocodeCoordinate:position.target withCallback:@selector(setAddress) withDelegate:self];
    }
}

- (void)setAddress {
    if (gs.geocode[@"error"]) {
        return;
    }
    [_addressLabel setText:gs.geocode[@"address"]];

}
@end
