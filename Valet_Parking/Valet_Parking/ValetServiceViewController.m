//
//  ValetServiceViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ValetServiceViewController.h"
#import "WelcomeViewController.h"
#import "ParkNowViewController.h"
#import "CurrentOrderViewController.h"
#import "TopScroller.h"
#import "TopImageView.h"

#define DEVICE_FRAME [UIScreen mainScreen].bounds.size
#define TOPIMAGE_HEIGHT 213.0f

static NSString * const SimpleTableViewCellIdentifier = @"SimpleTableViewCellIdentifier";

@interface ValetServiceViewController () <WelcomeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, TopScrollerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TopScroller *topScroller;
@property (strong, nonatomic) NSMutableArray *topImageViews;
@property (strong, nonatomic) NSMutableArray *topImages;
@end

@implementation ValetServiceViewController
{
    NSInteger _numOfUserOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    // temp code
    [self.topImages addObjectsFromArray:@[[UIImage imageNamed:@"scroller1"], [UIImage imageNamed:@"scroller2"], [UIImage imageNamed:@"scroller3"]]];
    
    self.topScroller.delegate = self;
    [self.topScroller setupScroller];
    [self.topScroller reload];
    
    // [self setNeedsStatusBarAppearanceUpdate];
    
    // Step0 delete all cars in local database
    [[LibraryAPI sharedInstance] deleteAllCarsInCoreData];
    
    // Step1 check if logged in
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(UserModel *userModel) {
        [hud hideAnimated:YES];
        [self loginSuccessfully:userModel];
    }
                                                     fail:^(NSError *error) {
                                                         [hud hideAnimated:YES];
                                                         [self popUpWelcomeView];
                                                     }];
    
    [self.tableView reloadData];
}



//- (UIStatusBarStyle) preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - TopScrollerDelegate

- (NSInteger)numberOfViewsForTopScroller:(TopScroller *)scroller
{
    return self.topImageViews.count;
}

- (UIView *)topScroller:(TopScroller *)scroller viewAtIndex:(int)index
{
    UIImageView *topImageView = self.topImageViews[index];
    
    if ([topImageView isEqual:[NSNull null]]) {
//        XYTopImage *topImage = self.topImages[index];
//        topImageView = [[TopImageView alloc] initWithImageUrl:topImage.pic title:topImage.title articleID:topImage.id];
        topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_FRAME.width, TOPIMAGE_HEIGHT)];
        [topImageView setImage:self.topImages[index]];
        [self.topImageViews replaceObjectAtIndex:index withObject:topImageView];
    }
    
    return topImageView;
}

- (UIView *)topScroller:(TopScroller *)scroller viewAtFirstOfLast:(BOOL)isFirst
{
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_FRAME.width, TOPIMAGE_HEIGHT)];
    
    if (isFirst) {
        [topImageView setImage:self.topImages[0]];
    } else {
        [topImageView setImage:[self.topImages lastObject]];
    }
    
    return topImageView;
}

- (void)topScroller:(TopScroller *)scroller clickedViewAtIndex:(int)index
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ArticleDetailViewController *articleDetailViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ArticleDetailViewController"];
//    
//    XYTopImage *topImage = self.topImages[index];
//    NSString *articleID = topImage.id;
//    [articleDetailViewController setArticleID:[articleID integerValue]
//                                    thumbnail:@""
//                                  isFirstPage:YES];
//    
//    //    [articleDetailViewController setThumbnail:article.imageUrl];
//    
//    [self.navigationController pushViewController:articleDetailViewController animated:YES];
    NSLog(@"click on scroller");
}

# pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == 0) {
        // park now
        ParkNowViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ParkNowViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row== 1) {
        // current orders view controller
        CurrentOrderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentOrderViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"CellForService"];
    }
    
    cell.textLabel.text = [ValetServiceViewController textForTableView][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

+ (NSArray *)textForTableView {
    return @[@"Parking Now", @"Current Orders"];
}

# pragma mark - Some settings

- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (NSMutableArray *)topImageViews
{
    if (!_topImageViews)
    {
        _topImageViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            [_topImageViews addObject:[NSNull null]];
        }
    }
    return _topImageViews;
}

- (NSMutableArray *)topImages {
    if (!_topImages) {
        _topImages = [[NSMutableArray alloc] init];
    }
    
    return _topImages;
}

#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(UserModel *)userModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO some instruction
    
    // get user's car
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[LibraryAPI sharedInstance] getCarsForUser:userModel
                                        success:^(NSArray *cars) {
                                            NSLog(@"Get %lu cars from server", (unsigned long)[cars count]);
                                            [hud hideAnimated:YES];
                                        }
                                           fail:^(NSError *error) {
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = @"fail to fetch cars";
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
