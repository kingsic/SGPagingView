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
#import "DefaultVCSix.h"
#import "DefaultVCSeven.h"
#import "DefaultVCEight.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *TitleDataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TitleDataList = @[@"静止样式", @"滚动样式", @"导航栏样式", @"文字渐变效果", @"文字缩放效果", @"微博个人主页", @"滚动结束后加载子视图", @"指示器遮盖样式", @"指示器遮盖样式二", @"内容全屏效果"];
    
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
        NavigationBarVC *VC = [[NavigationBarVC alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:VC];
        // 之前在使用模态的时候并没有遇到这种情况；第一次，因为模态的时候有延迟，而且延迟比较厉害；上网查了一下，网上给出的答案：由于某种原因： presentViewController:animated:completion 里的内容并不会真的马上触发执行，除非有一个主线程事件触发。比如在弹出慢的时候，你随便点击一下屏幕，马上就能弹出来；这个我测试是这种情况
        // 解决方法：将 presentViewController:animated:completion: 添加到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:navC animated:YES completion:^{
            }];
        }];
        
    } else if (indexPath.row == 3) {
        DefaultVCThree *threeVC = [[DefaultVCThree alloc] init];
        [self.navigationController pushViewController:threeVC animated:YES];
        
    } else if (indexPath.row == 4) {
        DefaultVCFour *fourVC = [[DefaultVCFour alloc] init];
        [self.navigationController pushViewController:fourVC animated:YES];
        
    } else if (indexPath.row == 5) {
        PersonalCenterVC *PCVC = [[PersonalCenterVC alloc] init];
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if (indexPath.row == 6) {
        DefaultVCFive *fiveVC = [[DefaultVCFive alloc] init];
        [self.navigationController pushViewController:fiveVC animated:YES];
        
    } else if (indexPath.row == 7) {
        DefaultVCSix *sixVC = [[DefaultVCSix alloc] init];
        [self.navigationController pushViewController:sixVC animated:YES];
        
    } else if (indexPath.row == 8) {
        DefaultVCEight *eightVC = [[DefaultVCEight alloc] init];
        [self.navigationController pushViewController:eightVC animated:YES];
        
    } else {
        DefaultVCSeven *sevenVC = [[DefaultVCSeven alloc] init];
        [self.navigationController pushViewController:sevenVC animated:YES];
    }
}


@end
