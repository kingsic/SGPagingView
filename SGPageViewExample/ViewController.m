//
//  ViewController.m
//  SGPageViewExample
//
//  Created by apple on 17/4/12.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "DefaultVCOne.h"
#import "DefaultVCTwo.h"
#import "DefaultVCThree.h"
#import "DefaultVCFour.h"
#import "NavigationBarVC.h"
#import "PersonalCenterVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *TitleDataList;
@property (nonatomic, strong) NSArray *VCDataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TitleDataList = @[@"静止样式", @"滚动样式", @"导航栏样式", @"文字渐变效果", @"文字缩放效果", @"微博个人主页"];
    
    DefaultVCOne *oneVC = [[DefaultVCOne alloc] init];
    DefaultVCTwo *twoVC = [[DefaultVCTwo alloc] init];
    NavigationBarVC *navVC = [[NavigationBarVC alloc] init];
    DefaultVCThree *threeVC = [[DefaultVCThree alloc] init];
    DefaultVCFour *fourVC = [[DefaultVCFour alloc] init];
    PersonalCenterVC *PCVC = [[PersonalCenterVC alloc] init];

    self.VCDataList = @[oneVC, twoVC, navVC, threeVC, fourVC, PCVC];
    
    [self foundTableView];
}

- (void)foundTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.TitleDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.TitleDataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:self.VCDataList[indexPath.row] animated:YES];
}


@end

