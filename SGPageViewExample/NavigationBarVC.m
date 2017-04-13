//
//  NavigationBarVC.m
//  SGPageViewExample
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "NavigationBarVC.h"
#import "SGPageView.h"
#import "NavigationBarTitleView.h"
#import "SubviewVC.h"

@interface NavigationBarVC () <SGPageTitleViewDelegate, SGPageContentViewDelegare>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation NavigationBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会"];
    NSMutableArray *childMArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        if (i == 0) {
            SubviewVC *vcs;
            vcs = [[SubviewVC alloc] init];
            vcs.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
            [self addChildViewController:vcs];
            [childMArr addObject:vcs];
        } else {
            UIViewController *vcs;
            vcs = [[UIViewController alloc] init];
            vcs.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
            [self addChildViewController:vcs];
            [childMArr addObject:vcs];
        }
    }
    CGFloat contentViewHeight = self.view.frame.size.height - 64;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childMArr];
    _pageContentView.delegarePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) titleNames:titleArr];
    _pageTitleView.delegatePageTitleView = self;
    _pageTitleView.isShowIndicator = NO;
    
    // 对navigationItem.titleView的包装，为的是让View占据整个视图宽度
    NavigationBarTitleView *view = [[NavigationBarTitleView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.titleView = view;
    [view addSubview:_pageTitleView];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setSGPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setSegmentedControlWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}



@end

