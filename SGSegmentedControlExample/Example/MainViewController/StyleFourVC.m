//
//  StyleFourVC.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 带有图片的 SGSegmentControlDefault

#import "StyleFourVC.h"
#import "TestOneVC.h"
#import "TestTwoVC.h"
#import "TestThreeVC.h"
#import "TestFourVC.h"
#import "TestFiveVC.h"
#import "TestSixVC.h"
#import "TestSevenVC.h"
#import "TestEightVC.h"
#import "TestNineVC.h"
#import "SGSegmentedControl.h"

@interface StyleFourVC () <SGSegmentedControlDefaultDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlDefault *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;

@end

@implementation StyleFourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 地球
    TestOneVC *oneVC = [[TestOneVC alloc] init];
    [self addChildViewController:oneVC];
    // 学士帽
    TestTwoVC *twoVC = [[TestTwoVC alloc] init];
    [self addChildViewController:twoVC];
    // 书籍
    TestThreeVC *threeVC = [[TestThreeVC alloc] init];
    [self addChildViewController:threeVC];
    // 电视
    TestFourVC *fourVC = [[TestFourVC alloc] init];
    [self addChildViewController:fourVC];
    // 游泳
    TestFiveVC *fiveVC = [[TestFiveVC alloc] init];
    [self addChildViewController:fiveVC];
    // 皇冠
    TestSixVC *sixVC = [[TestSixVC alloc] init];
    [self addChildViewController:sixVC];
    // 金钱
    TestSevenVC *sevenVC = [[TestSevenVC alloc] init];
    [self addChildViewController:sevenVC];
    // 购物
    TestEightVC *eightVC = [[TestEightVC alloc] init];
    [self addChildViewController:eightVC];
    // 银行
    TestNineVC *nineVC = [[TestNineVC alloc] init];
    [self addChildViewController:nineVC];
    
    NSArray *childVC = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC, eightVC, nineVC];
    
    NSArray *nomal_image_arr = @[@"one_icon", @"two_icon", @"three_icon", @"four_icon", @"five_icon", @"six_icon", @"seven_icon", @"eight_icon", @"nine_icon"];
    NSArray *selected_image_arr = @[@"one_selected_icon", @"two_selected_icon", @"three_selected_icon", @"four_selected_icon", @"five_selected_icon", @"six_selected_icon", @"seven_selected_icon", @"eight_selected_icon", @"nine_selected_icon"];
    NSArray *title_arr = @[@"地球", @"学士帽", @"书籍", @"电视", @"游泳", @"皇冠", @"金钱", @"购物", @"银行"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlDefault segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 64) delegate:self nomalImageArr:nomal_image_arr selectedImageArr:selected_image_arr childVcTitle:title_arr];
    [self.view addSubview:_topSView];
}

- (void)SGSegmentedControlDefault:(SGSegmentedControlDefault *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index {
    NSLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

@end
