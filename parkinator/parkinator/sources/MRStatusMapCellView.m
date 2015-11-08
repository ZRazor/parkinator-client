//
//  MRMapCellView.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRStatusMapCellView.h"
#import "MRConsts.h"
#import "MRAppDataProvider.h"

@implementation MRStatusMapCellView {
    float prevZoom;
    GMSMarker *marker;
}

- (void)awakeFromNib {

    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CLLocationDegrees lat = 43.1;
    CLLocationDegrees lon = 131.9;

    prevZoom = 16;


    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:prevZoom];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,0,screenWidth,self.frame.size.height) camera:camera];
    [self addSubview:_mapView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoordsWithLat:(CLLocationDegrees)lat andLot:(CLLocationDegrees)lon {
    if (marker.position.latitude == lat && marker.position.longitude == lon) {
        return;
    }
    [_mapView clear];
    marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(lat, lon)];
    [marker setAppearAnimation:kGMSMarkerAnimationPop];
    //TODO new icon for user
    [marker setIcon:[UIImage imageNamed:@"marker"]];
    [marker setMap:_mapView];
    GMSCameraPosition *newPos = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:_mapView.camera.zoom];
    [_mapView animateToCameraPosition:newPos];
}
@end
