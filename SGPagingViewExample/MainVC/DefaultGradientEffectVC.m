//
//  DefaultGradientEffectVC.m
//  SGPageViewExample
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "DefaultGradientEffectVC.h"
#import "SGPagingView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"
#import <Masonry/Masonry.h>

@interface DefaultGradientEffectVC () <SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation DefaultGradientEffectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageView];
}

- (void)setupPageView {
    CGFloat pageTitleViewY = 0;
    if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
        pageTitleViewY += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }
    if (self.navigationController.navigationBar.isHidden == NO) {
        pageTitleViewY += self.navigationController.navigationBar.frame.size.height;
    }
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor lightGrayColor];
    configure.titleSelectedColor = [UIColor blackColor];
    configure.indicatorColor = [UIColor blackColor];
    configure.titleAlignment = SGPageTitleAlignmentJustified;
    configure.indicatorAdditionalWidth = 100; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [[SGPageTitleView alloc] init];
    self.pageTitleView.titleArr = titleArr;
    self.pageTitleView.configure = configure;
    self.pageTitleView.isShowBottomSeparator = YES;
    [self.view addSubview:_pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44.0));
        make.top.equalTo(@(pageTitleViewY));
        make.leading.trailing.equalTo(self.view);
    }];
    self.pageTitleView.delegatePageTitleView = self;
    _pageTitleView.selectedIndex = 1;
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] init];
    self.pageContentView.parentViewController = self;
    self.pageContentView.childViewControllers = childArr;
    [self.view addSubview:_pageContentView];
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentViewHeight));
        make.top.equalTo(self.pageTitleView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
    }];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition: nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGFloat pageTitleViewY = 0;
        if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
            pageTitleViewY += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        }
        if (self.navigationController.navigationBar.isHidden == NO) {
            pageTitleViewY += self.navigationController.navigationBar.frame.size.height;
        }
        [self.pageTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(pageTitleViewY));
        }];
    }];
}

#pragma mark SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

#pragma mark SGPageContentViewDelegate
- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
