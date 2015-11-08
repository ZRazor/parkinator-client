//
//  MRInititatorStatusViewController.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "MRInititatorStatusViewController.h"
#import "MRAppDataProvider.h"
#import "MRPlace.h"
#import "MRStatusMapCellView.h"
#import "MRError.h"

@interface MRInititatorStatusViewController ()

@end

@implementation MRInititatorStatusViewController {
    MRPlace *place;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearFields];

    [self loadDataFromServer:YES];

    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadInfo) userInfo:nil repeats:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadInfo {
    [self loadDataFromServer:NO];

}

- (void)loadDataFromServer:(BOOL)showHud {
    if (showHud) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    [[MRAppDataShared placeService] loadPlaceWithId:self.contractId block:^(NSError *error, MRPlace *newPlace) {
        if (showHud) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
        if (!error) {
            place = newPlace;
            [self setPlaceInterface];
            if ([place.status isEqualToString:PLACE_STATUS_FINISHED]) {
                [timer invalidate];
                timer = nil;
                SCLAlertView *newAlert = [[SCLAlertView alloc] init];
                [newAlert alertIsDismissed:^{
                    [MRAppDataShared setInititator:nil appLaunched:NO];
                }];
                [newAlert showSuccess:self.tabBarController title:@"Ура" subTitle:@"Сделка завершена" closeButtonTitle:@"Закрыть" duration:0.0f];
            } else {

            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
            if (showHud) {
                SCLAlertView *newAlert = [[SCLAlertView alloc] init];
                [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
            }
        }
    }];

}

- (void)clearFields {
    [_addressLabel setText:@""];
    [_otherPlaceInfoLabel setText:@""];
    [_carTypeLabel setImage:[UIImage imageNamed:@"xxx"]];
    [self clearAcceptor];
}

- (void)clearAcceptor {
    [_acceptorCarColorLabel setText:@""];
    [_acceptorCarNameLabel setText:@"Вашу заявку еще никто не купил"];
    [_acceptorCarNumberLabel setText:@""];
    [_mapViewCell.mapView setHidden:YES];
}

- (void)setPlaceInterface {
    [_addressLabel setText:place.address];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[place.leaveDt longValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *leaveDtStr = [format stringFromDate:date];
    [_otherPlaceInfoLabel setText:[NSString stringWithFormat:@"в %@ за %@", leaveDtStr, place.price]];
    [_carTypeLabel setImage:[UIImage imageNamed:place.carType]];
    if (place.acceptor.id) {
        [_acceptorCarColorLabel setText:place.acceptor.carColor];
        [_acceptorCarNameLabel setText:place.acceptor.carModel];
        [_acceptorCarNumberLabel setText:place.acceptor.carNumber];
        [_mapViewCell setCoordsWithLat:[place.acceptor.lat doubleValue] andLot:[place.acceptor.lon doubleValue]];
        [_mapViewCell.mapView setHidden:NO];
    } else {
        [self clearAcceptor];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)removePlaceAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[MRAppDataShared placeService] removePlaceWithId:self.contractId block:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (!error) {
            [MRAppDataShared setInititator:nil appLaunched:NO];
        } else {
            SCLAlertView *newAlert = [[SCLAlertView alloc] init];
            [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
        }
    }];
}
@end
