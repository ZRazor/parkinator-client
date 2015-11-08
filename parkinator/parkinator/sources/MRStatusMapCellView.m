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

}

- (void)awakeFromNib {

    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CLLocationDegrees lat = 43.1;
    CLLocationDegrees lon = 131.9;


    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:14];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,0,screenWidth,self.frame.size.height) camera:camera];
    [self addSubview:_mapView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoordsWithLat:(CLLocationDegrees)lat andLot:(CLLocationDegrees)lon {
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(lat, lon)];
    [marker setAppearAnimation:kGMSMarkerAnimationPop];
    //TODO new icon for user
    [marker setIcon:[UIImage imageNamed:@"marker"]];
    [marker setMap:_mapView];
}
@end
