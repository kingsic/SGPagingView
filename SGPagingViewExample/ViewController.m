//
//  ViewController.m
//  SGPagingViewExample
//
//  Created by apple on 2017/7/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "DefaultVCOne.h"
#import "DefaultVCTwo.h"
#import "DefaultVCThree.h"
#import "DefaultVCFour.h"
#import "NavigationBarVC.h"
#import "PersonalCenterVC.h"
#import "DefaultVCFive.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *TitleDataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TitleDataList = @[@"静止样式", @"滚动样式", @"导航栏样式", @"文字渐变效果", @"文字缩放效果", @"微博个人主页", @"滚动结束后加载子视图"];
    
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
    if (indexPath.row == 0) {
        DefaultVCOne *oneVC = [[DefaultVCOne alloc] init];
        [self.navigationController pushViewController:oneVC animated:YES];
        
    } else if (indexPath.row == 1) {
        DefaultVCTwo *twoVC = [[DefaultVCTwo alloc] init];
        [self.navigationController pushViewController:twoVC animated:YES];
        
    } else if (indexPath.row == 2) {
        NavigationBarVC *navVC = [[NavigationBarVC alloc] init];
        [self.navigationController pushViewController:navVC animated:YES];
        
    } else if (indexPath.row == 3) {
        DefaultVCThree *threeVC = [[DefaultVCThree alloc] init];
        [self.navigationController pushViewController:threeVC animated:YES];
        
    } else if (indexPath.row == 4) {
        DefaultVCFour *fourVC = [[DefaultVCFour alloc] init];
        [self.navigationController pushViewController:fourVC animated:YES];
        
    } else if (indexPath.row == 5) {
        PersonalCenterVC *PCVC = [[PersonalCenterVC alloc] init];
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else {
        
        DefaultVCFive *fiveVC = [[DefaultVCFive alloc] init];
        [self.navigationController pushViewController:fiveVC animated:YES];
    }
}


@end
