//
//  DefaultTopBottomVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2019/7/27.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "DefaultTopBottomVC.h"
#import "SGPagingView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"

@interface DefaultTopBottomVC () <SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation DefaultTopBottomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"精选\n猜你喜欢", @"大促爆款\n给你放大招", @"特价包邮\n幸福带回家", @"好店\n精选店铺"];
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
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:17];
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.titleViewScrollStyle = SGTitleViewScrollStyleProgressScroll;
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 60) delegate:self titleNames:self.titles configure:configure];
    [self.view addSubview:_pageTitleView];
    
    // 这里只提供了案例并没对代码做处理；请根据项目需求进行代码抽取
    [self attributedString];
    [self attributedString1];
    [self attributedString2];
    [self attributedString3];

    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
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

- (void)attributedString {
    NSString *string = self.titles[0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 };
    NSRange normalRange = NSMakeRange(2, attributedString.length - 2);
    [attributedString addAttributes:normalDict range:normalRange];
    
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    [selectedAttributedString addAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor redColor],
                                              NSFontAttributeName : [UIFont systemFontOfSize:17]
                                              } range:NSMakeRange(0, 2)];
    
    [_pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:0];
}

- (void)attributedString1 {
    NSString *string = self.titles[1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 };
    NSRange normalRange = NSMakeRange(4, attributedString.length - 4);
    [attributedString addAttributes:normalDict range:normalRange];
    
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    [selectedAttributedString addAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor redColor],
                                              NSFontAttributeName : [UIFont systemFontOfSize:17]
                                              } range:NSMakeRange(0, 4)];
    
    [_pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:1];
}

- (void)attributedString2 {
    NSString *string = self.titles[2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 };
    NSRange normalRange = NSMakeRange(4, attributedString.length - 4);
    [attributedString addAttributes:normalDict range:normalRange];
    
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    [selectedAttributedString addAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor redColor],
                                              NSFontAttributeName : [UIFont systemFontOfSize:17]
                                              } range:NSMakeRange(0, 4)];
    
    [_pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:2];
}

- (void)attributedString3 {
    NSString *string = self.titles[3];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 };
    NSRange normalRange = NSMakeRange(2, attributedString.length - 2);
    [attributedString addAttributes:normalDict range:normalRange];
    
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    [selectedAttributedString addAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor redColor],
                                              NSFontAttributeName : [UIFont systemFontOfSize:17]
                                              } range:NSMakeRange(0, 2)];
    
    [_pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:3];
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
