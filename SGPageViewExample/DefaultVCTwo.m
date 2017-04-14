//
//  DefaultVCTwo.m
//  SGPageViewExample
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "DefaultVCTwo.h"
#import "SGPageView.h"

@interface DefaultVCTwo () <SGPageTitleViewDelegate, SGPageContentViewDelegare>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation DefaultVCTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会"];
    NSMutableArray *childMArr = [NSMutableArray array];
    UIViewController *vcs;
    for (int i = 0; i < titleArr.count; i++) {
        vcs = [[UIViewController alloc] init];
        vcs.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
        [self addChildViewController:vcs];
        [childMArr addObject:vcs];
    }
    CGFloat contentViewHeight = self.view.frame.size.height - 108;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childMArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) titleNames:titleArr];
    _pageTitleView.delegatePageTitleView = self;
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 1;
    _pageTitleView.indicatorStyle = SGIndicatorTypeEqual;
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setSGPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


@end

