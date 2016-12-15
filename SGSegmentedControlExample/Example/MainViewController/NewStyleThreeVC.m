//
//  NewStyleThreeVC.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  带有图片的 SGSegmentedControlStatic，且图片在下面

#import "NewStyleThreeVC.h"
#import "TestOneVC.h"
#import "TestTwoVC.h"
#import "TestThreeVC.h"
#import "TestFourVC.h"
#import "SGSegmentedControl.h"

@interface NewStyleThreeVC () <SGSegmentedControlStaticDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;
@end

@implementation NewStyleThreeVC

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
    
    TestFourVC *fourVC = [[TestFourVC alloc] init];
    [self addChildViewController:fourVC];
    
    NSArray *childVC = @[oneVC, twoVC, threeVC, fourVC];
    
    NSArray *nomal_image_arr = @[@"one_icon", @"two_icon", @"three_icon", @"four_icon"];
    NSArray *selected_image_arr = @[@"one_selected_icon", @"two_selected_icon", @"three_selected_icon", @"four_selected_icon"];
    NSArray *title_arr = @[@"地球", @"学士帽", @"书籍", @"电视"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60) delegate:self childVcTitle:title_arr indicatorIsFull:YES];
    
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        *segmentedControlStaticType = SGSegmentedControlStaticTypeVertical;
        *nomalImageArr = nomal_image_arr;
        *selectedImageArr = selected_image_arr;
    }];
    [self.view addSubview:_topSView];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
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
