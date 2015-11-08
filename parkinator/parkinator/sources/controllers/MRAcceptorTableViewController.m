//
//  MRAcceptorTableViewController.m
//  parkinator
//
//  Created by Anton Zlotnikov on 08.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "MRAcceptorTableViewController.h"
#import "MRStatusMapCellView.h"
#import "MRAppDataProvider.h"
#import "MRPlace.h"
#import "MRError.h"

@interface MRAcceptorTableViewController ()

@end

@implementation MRAcceptorTableViewController {
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
                    [MRAppDataShared setAcceptor:nil];
                }];
                [newAlert showSuccess:self.tabBarController title:@"Ура" subTitle:@"Сделка завершена" closeButtonTitle:@"Закрыть" duration:0.0f];
            } else if ([place.status isEqualToString:PLACE_STATUS_DELETED]) {
                [timer invalidate];
                timer = nil;
                SCLAlertView *newAlert = [[SCLAlertView alloc] init];
                [newAlert alertIsDismissed:^{
                    [MRAppDataShared setAcceptor:nil];
                }];
                [newAlert showError:self.tabBarController title:@"Увы" subTitle:@"Продавец отменил сделку" closeButtonTitle:@"Закрыть" duration:0.0f];
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
    [_carColorLabel setText:@""];
    [_carNameLabel setText:@""];
    [_carNumberLabel setText:@""];
    [_timeLabel setText:@""];
    [_commentLabel setText:@""];
}


- (void)setPlaceInterface {
    [_addressLabel setText:place.address];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[place.leaveDt longValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *leaveDtStr = [format stringFromDate:date];
    [_timeLabel setText:leaveDtStr];
    [_commentLabel setText:place.comment];
    [_mapCell setCoordsWithLat:[place.lat doubleValue] andLot:[place.lon doubleValue]];
    if (place.initiator.id) {
        [_carColorLabel setText:place.initiator.carColor];
        [_carNameLabel setText:place.initiator.carModel];
        [_carNumberLabel setText:place.initiator.carNumber];
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

- (IBAction)cancelAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[MRAppDataShared placeService] declinePlaceWithId:self.contractId block:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (!error) {
            [MRAppDataShared setAcceptor:nil];
        } else {
            SCLAlertView *newAlert = [[SCLAlertView alloc] init];
            [newAlert showError:self.tabBarController title:@"Ошибка" subTitle:[error localizedDescription] closeButtonTitle:@"Закрыть" duration:0.0f];
        }
    }];
}
@end
