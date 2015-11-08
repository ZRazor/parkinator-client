//
//  MRSettingsTableViewController.m
//  parkinator
//
//  Created by Anton Zlotnikov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRSettingsTableViewController.h"
#import "MRAppDataProvider.h"
#import "MRSubmitButton.h"
#import "MRLoginViewController.h"

@interface MRSettingsTableViewController ()

@end

@implementation MRSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_phoneLabel setText:MRAppDataShared.userData.phone];
    [_balanceLabel setText:[NSString stringWithFormat:@"%@", MRAppDataShared.userData.balance]];
    [_carModelLabel setText:MRAppDataShared.userData.carModel];
    [_carColorLabel setText:MRAppDataShared.userData.carColor];
    [_carNumberLabel setText:MRAppDataShared.userData.carNumber];
    [_carTypeImageView setImage:[UIImage imageNamed:MRAppDataShared.userData.carType]];
    [self.tableView reloadData];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (IBAction)logoutAction:(MRSubmitButton *)sender {
    [[[MRAppDataProvider shared] userData] clearData];
    [[[MRAppDataProvider shared] userData] saveToUserDefaults];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:[[MRLoginViewController alloc] init]];
}
@end
