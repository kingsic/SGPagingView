//
//  ViewController.m
//  SGPageViewExample
//
//  Created by apple on 17/4/12.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "SGPageView.h"
#import "DefaultVCOne.h"
#import "DefaultVCTwo.h"
#import "NavigationBarVC.h"

#define SGScreenWidth [UIScreen mainScreen].bounds.size.width
#define SGScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /// 例一
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺"];
    CGFloat pageTitleViewX = 50;
    CGFloat pageTitleViewY = 74;
    CGFloat pageTitleViewW = SGScreenWidth - 2 * pageTitleViewX;
    CGFloat pageTitleViewH = 44;
    SGPageTitleView *pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(pageTitleViewX, pageTitleViewY, pageTitleViewW, pageTitleViewH) delegate:nil titleNames:titleArr];
    pageTitleView.titleColorStateNormal = [UIColor brownColor];
    pageTitleView.titleColorStateSelected = [UIColor purpleColor];
    pageTitleView.indicatorColor = [UIColor purpleColor];
    pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
    [self.view addSubview:pageTitleView];
    
    /// 例二
    SGPageTitleView *pageTitleView2 = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, CGRectGetMaxY(pageTitleView.frame) + 20, SGScreenWidth, pageTitleViewH) delegate:nil titleNames:titleArr];
    pageTitleView2.selectedIndex = 1;
    pageTitleView2.indicatorLengthStyle = SGIndicatorLengthTypeSpecial;
    [self.view addSubview:pageTitleView2];
    
    /// 例三
    NSArray *titleArr3 = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会"];
    SGPageTitleView *pageTitleView3 = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, CGRectGetMaxY(pageTitleView2.frame) + 20, SGScreenWidth, pageTitleViewH) delegate:nil titleNames:titleArr3];
    [self.view addSubview:pageTitleView3];
    
    /// 普通样式一
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat btnW = 100;
    CGFloat btnX = 0.5 * (0.5 * SGScreenWidth - btnW);
    CGFloat btnY = CGRectGetMaxY(pageTitleView3.frame) + 20;
    CGFloat btnH = 44;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [btn setTitle:@"普通样式一" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    [btn addTarget:self action:@selector(defaultBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    /// 普通样式二
    UIButton *btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat btn2W = 100;
    CGFloat btn2X = 0.5 * SGScreenWidth + 0.5 * (0.5 * SGScreenWidth - btnW);
    CGFloat btn2Y = CGRectGetMaxY(pageTitleView3.frame) + 20;
    CGFloat btn2H = 44;
    btn2.frame = CGRectMake(btn2X, btn2Y, btn2W, btn2H);
    [btn2 setTitle:@"普通样式二" forState:(UIControlStateNormal)];
    btn2.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    [btn2 addTarget:self action:@selector(defaultTwoBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn2];
    
    /// 导航栏样式
    UIButton *lastBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat lastBtnW = 100;
    CGFloat lastBtnX = 0.5 * (SGScreenWidth - btnW);
    CGFloat lastBtnY = CGRectGetMaxY(btn2.frame) + 20;
    CGFloat lastBtnH = 44;
    lastBtn.frame = CGRectMake(lastBtnX, lastBtnY, lastBtnW, lastBtnH);
    [lastBtn setTitle:@"导航栏样式" forState:(UIControlStateNormal)];
    lastBtn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    [lastBtn addTarget:self action:@selector(navigationBarBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:lastBtn];
}

- (void)defaultBtnAction {
    DefaultVCOne *defaultVC = [[DefaultVCOne alloc] init];
    [self.navigationController pushViewController:defaultVC animated:YES];
}

- (void)defaultTwoBtnAction {
    DefaultVCTwo *defaultVC = [[DefaultVCTwo alloc] init];
    [self.navigationController pushViewController:defaultVC animated:YES];
}

- (void)navigationBarBtnAction {
    NavigationBarVC *navigationBarVC = [[NavigationBarVC alloc] init];
    UINavigationController *tempNC = [[UINavigationController alloc] initWithRootViewController:navigationBarVC];
    [self presentViewController:tempNC animated:YES completion:nil];
}


@end

