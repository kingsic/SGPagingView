//
//  StyleThreeVC.m
//  SGSegmentedControlExample
//
//  Created by Sorgle on 2016/10/6.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "StyleThreeVC.h"
#import "SGSegmentedControl.h"
#import "SGNavigationItemTitleView.h"

@interface StyleThreeVC ()

@end

@implementation StyleThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSArray *title_arr = @[@"精选", @"电视剧", @"电影", @"综艺", @"NBA", @"新闻", @"娱乐", @"音乐", @"网络电影"];
    SGSegmentedControl *SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:nil segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:title_arr];
    SG.titleColorStateNormal = [UIColor blueColor];
    SG.showsBottomScrollIndicator = NO;

    // 对navigationItem.titleView的包装，为的是让View占据整个视图宽度
    SGNavigationItemTitleView *view = [[SGNavigationItemTitleView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:SG];
    self.navigationItem.titleView = view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
