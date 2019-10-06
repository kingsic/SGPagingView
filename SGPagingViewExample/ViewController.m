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
#import "DefaultSystemVC.h"
#import "DefaultImageVC.h"
#import "DefaultTopBottomVC.h"
#import "DefaultGradientEffectVC.h"
#import "DefaultZoomVC.h"
#import "DefaultFixedVC.h"
#import "DefaultDynamicVC.h"
#import "DefaultCoverVC.h"
#import "DefaultTwoCoverVC.h"
#import "DefaultThreeCoverVC.h"
#import "DefaultPopGestureVC.h"
#import "DefaultAnimatedVC.h"
#import "DefaultAttributedTitleVC.h"
#import "NavigationBarVC.h"
#import "DefaultIndicatorAutoFollowViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *TitleDataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TitleDataList = @[@"静止样式", @"滚动样式", @"系统样式", @"图片样式", @"文字上下样式（富文本）", @"文字渐变效果", @"文字缩放效果", @"指示器固定样式", @"指示器动态样式", @"指示器遮盖样式一", @"指示器遮盖样式二（从左到右自动布局）", @"指示器遮盖样式三", @"侧滑返回手势案例", @"滚动内容动画案例", @"富文本案例", @"导航栏样式案例", @"指示器自动跟随滚动样式"];
    
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
    switch (indexPath.row) {
        case 0: {
            // 静止样式
            DefaultStaticVC *staticVC = [[DefaultStaticVC alloc] init];
            [self.navigationController pushViewController:staticVC animated:YES];
        }
            break;
        case 1: {
            // 滚动样式
            DefaultScrollVC *scrollVC = [[DefaultScrollVC alloc] init];
            [self.navigationController pushViewController:scrollVC animated:YES];
        }
            break;
        case 2: {
            // 系统样式
            DefaultSystemVC *systemVC = [[DefaultSystemVC alloc] init];
            [self.navigationController pushViewController:systemVC animated:YES];
        }
            break;
        case 3: {
            // 图片样式
            DefaultImageVC *imageVC = [[DefaultImageVC alloc] init];
            [self.navigationController pushViewController:imageVC animated:YES];
        }
            break;
        case 4: {
            // 文字上下样式（富文本）
            DefaultTopBottomVC *tbVC = [[DefaultTopBottomVC alloc] init];
            [self.navigationController pushViewController:tbVC animated:YES];
        }
            break;
        case 5: {
            // 文字渐变效果
            DefaultGradientEffectVC *gradientEffectVC = [[DefaultGradientEffectVC alloc] init];
            [self.navigationController pushViewController:gradientEffectVC animated:YES];
        }
            break;
        case 6: {
            // 文字缩放效果
            DefaultZoomVC *zoomVC = [[DefaultZoomVC alloc] init];
            [self.navigationController pushViewController:zoomVC animated:YES];
        }
            break;
        case 7: {
            // 指示器固定样式
            DefaultFixedVC *fixedVC = [[DefaultFixedVC alloc] init];
            [self.navigationController pushViewController:fixedVC animated:YES];
        }
            break;
        case 8: {
            // 指示器动态样式
            DefaultDynamicVC *dynamicVC = [[DefaultDynamicVC alloc] init];
            [self.navigationController pushViewController:dynamicVC animated:YES];
        }
            break;
        case 9: {
            // 指示器遮盖样式一
            DefaultCoverVC *coverVC = [[DefaultCoverVC alloc] init];
            [self.navigationController pushViewController:coverVC animated:YES];
        }
            break;
        case 10: {
            // 指示器遮盖样式二（从左到右自动布局）
            DefaultTwoCoverVC *twoCoverVC = [[DefaultTwoCoverVC alloc] init];
            [self.navigationController pushViewController:twoCoverVC animated:YES];
        }
            break;
        case 11: {
            // 指示器遮盖样式三
            DefaultThreeCoverVC *threeCoverVC = [[DefaultThreeCoverVC alloc] init];
            [self.navigationController pushViewController:threeCoverVC animated:YES];
        }
            break;
        case 12: {
            // 侧滑返回手势案例
            DefaultPopGestureVC *popGestureVC = [[DefaultPopGestureVC alloc] init];
            [self.navigationController pushViewController:popGestureVC animated:YES];
        }
            break;
        case 13: {
            // 滚动内容动画案例
            DefaultAnimatedVC *animatedVC = [[DefaultAnimatedVC alloc] init];
            [self.navigationController pushViewController:animatedVC animated:YES];
        }
            break;
        case 14: {
            // 富文本案例
            DefaultAttributedTitleVC *attributedTitleVC = [[DefaultAttributedTitleVC alloc] init];
            [self.navigationController pushViewController:attributedTitleVC animated:YES];
        }
            break;
        case 15: {
            // 导航栏样式案例
            NavigationBarVC *VC = [[NavigationBarVC alloc] init];
            UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:VC];
            // 问题：模态的时候有延迟，而且延迟比较厉害。第一次遇到这种问题；上网查了一下，网上给出的答案：由于某种原因： presentViewController:animated:completion 里的内容并不会真的马上触发执行，除非有一个主线程事件触发。比如在弹出慢的时候，你随便点击一下屏幕，马上就能弹出来；这个我亲自测试了是这种情况
            // 解决方法：将 presentViewController:animated:completion: 添加到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:navC animated:YES completion:^{
                }];
            }];
        }
            break;
        case 16: {
            // 指示器自动跟随滚动样式
            DefaultIndicatorAutoFollowViewController *afVC = [DefaultIndicatorAutoFollowViewController new];
            [self.navigationController pushViewController:afVC animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
