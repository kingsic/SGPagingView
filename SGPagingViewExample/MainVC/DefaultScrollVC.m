//
//  DefaultScrollVC.m
//  SGPageViewExample
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "DefaultScrollVC.h"
#import "SGPagingView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"
#import "ChildVCFive.h"
#import "ChildVCSix.h"
#import "ChildVCSeven.h"
#import "ChildVCEight.h"
#import "ChildVCNine.h"
#import <Masonry/Masonry.h>

@interface DefaultScrollVC () <SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation DefaultScrollVC

- (void)dealloc {
    NSLog(@"DefaultScrollVC - - dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];

    [self setupPageView];
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView {
    CGFloat pageTitleViewY = 0;
    if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
        pageTitleViewY += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }
    if (self.navigationController.navigationBar.isHidden == NO) {
        pageTitleViewY += self.navigationController.navigationBar.frame.size.height;
    }
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.titleViewPadding = CGSizeMake(10.0, 0);
    
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
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    ChildVCFive *fiveVC = [[ChildVCFive alloc] init];
    ChildVCSix *sixVC = [[ChildVCSix alloc] init];
    ChildVCSeven *sevenVC = [[ChildVCSeven alloc] init];
    ChildVCEight *eightVC = [[ChildVCEight alloc] init];
    ChildVCNine *nineVC = [[ChildVCNine alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC, eightVC, nineVC];
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


@end

