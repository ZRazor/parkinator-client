#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MRStatusMapCellView : UITableViewCell

@property GMSMapView *mapView;

- (void)setCoordsWithLat:(CLLocationDegrees)lat andLot:(CLLocationDegrees)lon;
@end