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
#import <QRCodeReaderViewController/QRCodeReader.h>
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface OrderViewController () <WelcomeViewControllerDelegate, QRCodeReaderDelegate>

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    // Step1 check if logged in
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(ValetModel *valetModel) {
        [hud hideAnimated:YES];
        [self loginSuccessfully:valetModel];
    }
                                                     fail:^(NSError *error) {
                                                         [hud hideAnimated:YES];
                                                         [self popUpWelcomeView];
                                                     }];
    
    // Step 1 get all the orders
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
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
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
                                                              NSLog(@"%@", orderModel.carColor);
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


#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(ValetModel *)valetModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // TODO get all orders
    
}

#pragma mark - View

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
