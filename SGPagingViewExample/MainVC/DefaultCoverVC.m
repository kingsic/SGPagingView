//
//  DefaultCoverVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/10/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "DefaultCoverVC.h"
#import "SGPagingView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"

@interface DefaultCoverVC () <SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation DefaultCoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageView];
}

- (void)setupPageView {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[@"下载列表", @"上传列表", @"保存至手机"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = [UIColor lightGrayColor];
    configure.titleSelectedColor = [UIColor blackColor];
//    configure.indicatorStyle = SGIndicatorStyleCover;
    CGFloat indicatorWidth = (self.view.frame.size.width - 60)/3 - 5;
//    configure.indicatorAdditionalWidth = indicatorWidth;
    configure.indicatorColor = [UIColor whiteColor];
    configure.indicatorHeight = 38;
    configure.indicatorCornerRadius = 10;
    configure.titleGradientEffect = YES;
    configure.showBottomSeparator = NO;
    // 由于指示器是固定长度，而 SGIndicatorStyleCover 样式下额外宽度是在标题文字的基础上再增加的，不满足需求。故这里使用 SGIndicatorStyleFixed 样式，并配置相关属性
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.indicatorFixedWidth = indicatorWidth;
    configure.indicatorToBottomDistance = 0.5 * (44 - 38);
    configure.indicatorAnimationTime = 0.05;
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(30, pageTitleViewY, self.view.frame.size.width - 60, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.layer.cornerRadius = 10;
    self.pageTitleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.07];
    [self.view addSubview:_pageTitleView];
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC];
    /// pageContentCollectionView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
