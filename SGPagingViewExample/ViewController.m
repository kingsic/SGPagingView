//
//  ViewController.m
//  SGPagingViewExample
//
//  Created by apple on 2017/7/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "DefaultStaticVC.h"
#import "DefaultScrollVC.h"
#import "DefaultGradientEffectVC.h"
#import "DefaultZoomVC.h"
#import "NavigationBarVC.h"
#import "PersonalCenterVC.h"
#import "DefaultScrollEndVC.h"
#import "DefaultCoverVC.h"
#import "DefaultTwoCoverVC.h"
#import "DefaultThreeCoverVC.h"
#import "DefaultFixedVC.h"
#import "DefaultDynamicVC.h"
#import "DefaultPopGestureVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *TitleDataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TitleDataList = @[@"静止样式", @"滚动样式", @"导航栏样式", @"文字渐变效果", @"文字缩放效果", @"微博个人主页", @"滚动结束后加载子视图", @"指示器遮盖样式一", @"指示器遮盖样式二", @"指示器遮盖样式三 + 内容全屏效果", @"指示器固定样式", @"指示器动态样式", @"返回手势处理"];
    
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
        DefaultStaticVC *staticVC = [[DefaultStaticVC alloc] init];
        [self.navigationController pushViewController:staticVC animated:YES];
        
    } else if (indexPath.row == 1) {
        DefaultScrollVC *scrollVC = [[DefaultScrollVC alloc] init];
        [self.navigationController pushViewController:scrollVC animated:YES];
        
    } else if (indexPath.row == 2) {
        NavigationBarVC *VC = [[NavigationBarVC alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:VC];
        // 问题：模态的时候有延迟，而且延迟比较厉害。第一次遇到这种问题；上网查了一下，网上给出的答案：由于某种原因： presentViewController:animated:completion 里的内容并不会真的马上触发执行，除非有一个主线程事件触发。比如在弹出慢的时候，你随便点击一下屏幕，马上就能弹出来；这个我亲自测试了是这种情况
        // 解决方法：将 presentViewController:animated:completion: 添加到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:navC animated:YES completion:^{
            }];
        }];
        
    } else if (indexPath.row == 3) {
        DefaultGradientEffectVC *gradientEffectVC = [[DefaultGradientEffectVC alloc] init];
        [self.navigationController pushViewController:gradientEffectVC animated:YES];
        
    } else if (indexPath.row == 4) {
        DefaultZoomVC *zoomVC = [[DefaultZoomVC alloc] init];
        [self.navigationController pushViewController:zoomVC animated:YES];
        
    } else if (indexPath.row == 5) {
        PersonalCenterVC *PCVC = [[PersonalCenterVC alloc] init];
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if (indexPath.row == 6) {
        DefaultScrollEndVC *scrollEndVC = [[DefaultScrollEndVC alloc] init];
        [self.navigationController pushViewController:scrollEndVC animated:YES];
        
    } else if (indexPath.row == 7) {
        DefaultCoverVC *coverVC = [[DefaultCoverVC alloc] init];
        [self.navigationController pushViewController:coverVC animated:YES];
        
    } else if (indexPath.row == 8) {
        DefaultTwoCoverVC *twoCoverVC = [[DefaultTwoCoverVC alloc] init];
        [self.navigationController pushViewController:twoCoverVC animated:YES];
        
    } else if (indexPath.row == 9) {
        DefaultThreeCoverVC *threeCoverVC = [[DefaultThreeCoverVC alloc] init];
        [self.navigationController pushViewController:threeCoverVC animated:YES];
        
    } else if (indexPath.row == 10) {
        DefaultFixedVC *fixedVC = [[DefaultFixedVC alloc] init];
        [self.navigationController pushViewController:fixedVC animated:YES];
        
    } else if (indexPath.row == 11) {
        DefaultDynamicVC *dynamicVC = [[DefaultDynamicVC alloc] init];
        [self.navigationController pushViewController:dynamicVC animated:YES];
        
    } else {
        DefaultPopGestureVC *popGestureVC = [[DefaultPopGestureVC alloc] init];
        [self.navigationController pushViewController:popGestureVC animated:YES];
    }
}


@end
