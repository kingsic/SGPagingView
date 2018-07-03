//
//  DefaultSystemVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2018/5/14.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "DefaultSystemVC.h"
#import "SGPagingView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"

@interface DefaultSystemVC () <SGPageTitleViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

@end

@implementation DefaultSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self setupSystem];
    
    [self setupPageView];
}

- (void)setupSystem {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 84;
    } else {
        pageTitleViewY = 108;
    }
    CGFloat pageTitleViewW = self.view.frame.size.width * 4 / 5;
    CGFloat pageTitleViewX = 0.5 * (self.view.frame.size.width - pageTitleViewW);
    NSArray *titleArr = @[@"新建", @"QQGroup", @"429899752"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = [UIColor whiteColor];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.showBottomSeparator = NO;
    configure.indicatorStyle = SGIndicatorStyleCover;
    configure.indicatorColor = [UIColor orangeColor];
    configure.indicatorHeight = 30;
    configure.indicatorAdditionalWidth = 120; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.showVerticalSeparator = YES;

    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(pageTitleViewX, pageTitleViewY, pageTitleViewW, 30) delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.layer.borderWidth = 1;
    _pageTitleView.layer.borderColor = [UIColor redColor].CGColor;
    _pageTitleView.layer.cornerRadius = 5;
    _pageTitleView.layer.masksToBounds = YES;
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 1;
}

- (void)setupPageView {
    NSArray *titleArrS = @[@"精选", @"电影", @"OC", @"Swift"];
    SGPageTitleViewConfigure *configureS = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configureS.indicatorAdditionalWidth = 20;
    configureS.showVerticalSeparator = YES;
    configureS.verticalSeparatorColor = [UIColor grayColor];
    configureS.verticalSeparatorReduceHeight = 14;
    /// pageTitleViewS
    CGFloat pageTitleViewSY = CGRectGetMaxY(_pageTitleView.frame) + 30;
    SGPageTitleView *pageTitleViewS = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewSY, self.view.frame.size.width, 44) delegate:self titleNames:titleArrS configure:configureS];
    [self.view addSubview:pageTitleViewS];
    
    NSArray *titleArrL = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    SGPageTitleViewConfigure *configureL = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configureL.indicatorStyle = SGIndicatorStyleDynamic;
    configureL.titleAdditionalWidth = 30;
    configureL.showVerticalSeparator = YES;
    configureL.verticalSeparatorReduceHeight = 24;
    /// pageTitleViewL
    CGFloat pageTitleViewLY = CGRectGetMaxY(pageTitleViewS.frame) + 30;
    SGPageTitleView *pageTitleViewL = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewLY, self.view.frame.size.width, 44) delegate:self titleNames:titleArrL configure:configureL];
    [self.view addSubview:pageTitleViewL];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    
}


@end

