//
//  OrderViewController.m
//  Valet_Parking_ValetSide
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 Chester. All rights reserved.
//

#import "OrderViewController.h"
#import "WelcomeViewController.h"
#import "LibraryAPI.h"
#import "APIMessage.h"
#import "OrderModel.h"
#import "CarStatusViewController.h"
#import <CBStoreHouseRefreshControl/CBStoreHouseRefreshControl.h>
#import <QRCodeReaderViewController/QRCodeReader.h>
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const OrderCellIdentifier = @"OrderCell";

@interface OrderViewController () <WelcomeViewControllerDelegate, QRCodeReaderDelegate, UITableViewDelegate, UITableViewDataSource, CarStatusViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableArray *newlyCreatedOrders;
@property (strong, nonatomic) NSMutableArray *requestingOrders;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setPullToRefresh];
    [self setRefreshTimer];
    
    // Step1 check if logged in
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![[LibraryAPI sharedInstance] isUserLogin]) {
        [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(ValetModel *valetModel) {
            [self loginSuccessfully:valetModel];
        }
                                                         fail:^(NSError *error) {
                                                             [self.hud hideAnimated:YES];
                                                             [self popUpWelcomeView];
                                                         }];

    } else {
        [self loadOrders];
    }
}

- (IBAction)addOrder:(id)sender {
    // Step 1 - try scan the qr code
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)loadOrders {
    NSLog(@"start load orders");
    [self.timer setFireDate:[NSDate distantFuture]];
    // get all the orders
    [[LibraryAPI sharedInstance] getAllOpeningOrders:[[LibraryAPI sharedInstance] getCurrentValetModel]
                                             success:^(NSArray *orders) {
                                                 [self.hud hideAnimated:YES];
                                                 [self finishRefreshControl];
                                                 [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:60.0f]];
                                                 [self assignOrders:orders];
                                             }
                                                fail:^(NSError *error) {
                                                    self.hud.mode = MBProgressHUDModeText;
                                                    self.hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                                    [self.hud hideAnimated:YES afterDelay:2];
                                                    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:60.0f]];
                                                }];
}

- (void)stopTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)restartTimer {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:60.0f]];
}

#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self loadOrders];
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
}

#pragma mark - CarStatusViewControllerDelegate

- (void)endOrderSuccessfully {
    [self loadOrders];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    

    [self dismissViewControllerAnimated:YES completion:^{
        NSError *err;
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        if (err) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"Fail to create order";
            [hud hideAnimated:YES afterDelay:1];
        } else {
            [[LibraryAPI sharedInstance] addOrderWithParkingPlace:dic[@"parkingPlace"]
                                                        userPhone:dic[@"userPhone"]
                                                         carPlate:dic[@"carPlate"]
                                                          success:^(OrderModel *orderModel) {
                                                              hud.mode = MBProgressHUDModeText;
                                                              hud.label.text = @"Done";
                                                              [hud hideAnimated:YES afterDelay:2];
                                                              
                                                              [self loadOrders];
                                                          }
                                                             fail:^(NSError *error) {
                                                                 hud.mode = MBProgressHUDModeText;
                                                                 hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                                                 [hud hideAnimated:YES afterDelay:2];
                                                             }];
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section?@"New Orders":@"Requesting Orders";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?self.newlyCreatedOrders.count:self.requestingOrders.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 0) {
//        
//    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CarStatusViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CarStatusViewController"];
    vc.delegate = self;
    
    OrderModel *order;
    if (indexPath.section) {
        order = self.newlyCreatedOrders[indexPath.row];
    } else {
        order = self.requestingOrders[indexPath.row];
    }
    
    [vc setAnOrder:order];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderCellIdentifier];
    }
    
    OrderModel *order;
    if (indexPath.section == 0) {
        order = self.requestingOrders[indexPath.row];
    } else {
        order = self.newlyCreatedOrders[indexPath.row];
    }
    
    cell.textLabel.text = [[order.carPlate stringByAppendingString:@"-"] stringByAppendingString:order.carBrand];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(ValetModel *)valetModel
{
    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self loadOrders];
}

- (void)assignOrders:(NSArray *)orders {
    [self.requestingOrders removeAllObjects];
    [self.newlyCreatedOrders removeAllObjects];
    for (OrderModel *order in orders) {
        if (order.userRequestAt) {
            [self.requestingOrders addObject:order];
        } else {
            [self.newlyCreatedOrders addObject:order];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - View

- (void)setPullToRefresh {
    self.tableView.alwaysBounceVertical = YES;
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView
                                                                            target:self
                                                                     refreshAction:@selector(refreshTriggered:)
                                                                             plist:@"lkf"
                                                                             color:[UIColor colorWithRed:153.0f / 255.0f
                                                                                                   green:102.0f / 255.0f
                                                                                                    blue:51.0f / 255.0f
                                                                                                   alpha:1]
                                                                         lineWidth:5
                                                                        dropHeight:40
                                                                             scale:1
                                                              horizontalRandomness:150
                                                           reverseLoadingAnimation:YES
                                                           internalAnimationFactor:0.5];
}

- (void)setRefreshTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                  target:self
                                                selector:@selector(loadOrders)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (NSMutableArray *)newlyCreatedOrders {
    if (!_newlyCreatedOrders) {
        _newlyCreatedOrders = [[NSMutableArray alloc] init];
    }
    
    return _newlyCreatedOrders;
}

- (NSMutableArray *)requestingOrders {
    if (!_requestingOrders) {
        _requestingOrders = [[NSMutableArray alloc]  init];
    }
    
    return _requestingOrders;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
