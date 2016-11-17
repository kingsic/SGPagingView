//
//  StyleSevenVC.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 指示器样式三

#import "StyleSevenVC.h"
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

@interface StyleSevenVC () <SGSegmentedControlDefaultDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlDefault *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;

@end

@implementation StyleSevenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 精选
    TestOneVC *oneVC = [[TestOneVC alloc] init];
    [self addChildViewController:oneVC];
    // 电视剧
    TestTwoVC *twoVC = [[TestTwoVC alloc] init];
    [self addChildViewController:twoVC];
    // 电影
    TestThreeVC *threeVC = [[TestThreeVC alloc] init];
    [self addChildViewController:threeVC];
    // 综艺
    TestFourVC *fourVC = [[TestFourVC alloc] init];
    [self addChildViewController:fourVC];
    
    // NBA
    TestFiveVC *fiveVC = [[TestFiveVC alloc] init];
    [self addChildViewController:fiveVC];
    
    // 新闻
    TestSixVC *sixVC = [[TestSixVC alloc] init];
    [self addChildViewController:sixVC];
    
    // 娱乐
    TestSevenVC *sevenVC = [[TestSevenVC alloc] init];
    [self addChildViewController:sevenVC];
    
    // 音乐
    TestEightVC *eightVC = [[TestEightVC alloc] init];
    [self addChildViewController:eightVC];
    
    // 网络电视
    TestNineVC *nineVC = [[TestNineVC alloc] init];
    [self addChildViewController:nineVC];
    
    NSArray *childVC = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC, eightVC, nineVC];
    
    NSArray *title_arr = @[@"精选", @"电视剧", @"电影", @"综艺", @"NBA", @"新闻", @"娱乐", @"音乐", @"网络电影"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlDefault segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self childVcTitle:title_arr isScaleText:NO];
    _topSView.backgroundColor = [UIColor lightGrayColor];
    _topSView.segmentedControlIndicatorType = segmentedControlIndicatorTypeBottomWithImage;
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
