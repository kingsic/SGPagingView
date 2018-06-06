//
//  DefaultAttributedTitleVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2018/5/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "DefaultAttributedTitleVC.h"
#import "SGPagingView.h"

@interface DefaultAttributedTitleVC () <SGPageTitleViewDelegate>

@end

@implementation DefaultAttributedTitleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self setupHuyaPagingView];
    [self setupDouyuPagingView];
}

- (void)setupHuyaPagingView {
    NSArray *titleArrS = @[@"聊天", @"主播", @"排行",@"贵宾"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.showBottomSeparator = NO;
    configure.indicatorAdditionalWidth = 30;
    configure.indicatorColor = [UIColor orangeColor];
    configure.titleSelectedColor = [UIColor orangeColor];
    configure.titleFont = [UIFont systemFontOfSize:11];

    /// pageTitleView
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 114;
    } else {
        pageTitleViewY = 138;
    }
    CGFloat pageTitleViewH = 44;
    SGPageTitleView *pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width * 4 / 5, pageTitleViewH) delegate:self titleNames:titleArrS configure:configure];
    pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageTitleView];
    
    // setAttributedTitle
    NSString *string = @"贵宾(12138)";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:9]
                                 };
    NSRange normalRange = NSMakeRange(2, attributedString.length - 2);
    [attributedString addAttributes:normalDict range:normalRange];
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor orangeColor],
                                   NSFontAttributeName : [UIFont systemFontOfSize:9]                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    [selectedAttributedString addAttributes:@{
                                       NSForegroundColorAttributeName: [UIColor orangeColor],
                                       NSFontAttributeName : [UIFont systemFontOfSize:11]
                                       } range:NSMakeRange(0, 2)];
    
    [pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:3];
    
    // 提示语
    UILabel *label = [[UILabel alloc] init];
    CGFloat labelHeight = 50;
    label.frame = CGRectMake(0, pageTitleViewY - labelHeight, self.view.frame.size.width, labelHeight);
    label.text = @"虎牙样式";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:label];
    
    // rightBtn
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(pageTitleView.frame), pageTitleViewY, self.view.frame.size.width / 5, pageTitleViewH);
    rightBtn.backgroundColor = [UIColor orangeColor];
    NSString *rightBtnString = @"订阅\n  520";
    NSMutableAttributedString *rightBtnAS = [[NSMutableAttributedString alloc] initWithString:rightBtnString];
    NSDictionary *rightBtnDict = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:17]                                   };
    NSRange rightBtnRange = NSMakeRange(0, 2);
    [rightBtnAS addAttributes:rightBtnDict range:rightBtnRange];
    [rightBtnAS addAttributes:@{
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                
                                } range:NSMakeRange(0, rightBtnAS.length)];
    [rightBtn setAttributedTitle:rightBtnAS forState:(UIControlStateNormal)];
    rightBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:rightBtn];
}

- (void)setupDouyuPagingView {
    NSArray *titleArrS = @[@"聊天", @"主播", @"排行榜",@"贵族", @"直播"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.showBottomSeparator = NO;
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.indicatorFixedWidth = 30;
    configure.indicatorColor = [UIColor redColor];
    configure.indicatorHeight = 3;
    configure.indicatorCornerRadius = 1.5;
    configure.indicatorToBottomDistance = 4;
    configure.titleSelectedColor = [UIColor orangeColor];
    configure.titleFont = [UIFont systemFontOfSize:11];
    
    /// pageTitleView
    CGFloat pageTitleViewY = self.view.frame.size.height * 0.5;
    SGPageTitleView *pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArrS configure:configure];
    pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageTitleView];
    
    // setAttributedTitle
    NSString *string = @"贵族(12138)";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *normalDict = @{
                                 NSForegroundColorAttributeName: [UIColor orangeColor],
                                 };
    NSRange normalRange = NSMakeRange(2, attributedString.length - 2);
    [attributedString addAttributes:normalDict range:normalRange];
    
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName: [UIColor orangeColor],
                                   };
    NSRange selectedRange = NSMakeRange(0, selectedAttributedString.length);
    [selectedAttributedString addAttributes:selectedDict range:selectedRange];
    
    [pageTitleView setAttributedTitle:attributedString selectedAttributedTitle:selectedAttributedString forIndex:3];
    
    // 提示语
    UILabel *label = [[UILabel alloc] init];
    CGFloat labelHeight = 50;
    label.frame = CGRectMake(0, pageTitleViewY - labelHeight, self.view.frame.size.width, labelHeight);
    label.text = @"斗鱼样式";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:label];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    
}


@end

