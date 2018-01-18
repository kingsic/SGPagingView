//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageContentScrollView.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/7/21.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "SGPageContentScrollView.h"
#import "UIView+SGPagingView.h"

@interface SGPageContentScrollView () <UIScrollViewDelegate>
// 外界父控制器
@property (nonatomic, weak) UIViewController *parentViewController;
/// 存储子控制器
@property (nonatomic, strong) NSArray *childViewControllers;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
/// 标记按钮是否点击
@property (nonatomic, assign) BOOL isClickBtn;
/// 标记是否默认加载第一个子视图
@property (nonatomic, assign) BOOL isFirstViewLoaded;

@end

@implementation SGPageContentScrollView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentScrollView 所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentScrollView 子控制器必须设置" userInfo:nil];
        }
        self.childViewControllers = childVCs;
        
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    return [[self alloc] initWithFrame:frame parentVC:parentVC childVCs:childVCs];
}

- (void)initialization {
    self.isClickBtn = YES;
    self.startOffsetX = 0;
    self.isFirstViewLoaded = YES;
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、添加 scrollView
    [self addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat contentWidth = self.childViewControllers.count * _scrollView.SG_width;
        _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    }
    return _scrollView;
}

#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isClickBtn = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    // 1、pageContentScrollView:offsetX:
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:offsetX:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self offsetX:offsetX];
    }
    NSInteger index = offsetX / scrollView.frame.size.width;
    UIViewController *childVC = self.childViewControllers[index];
    // 2、判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (childVC.isViewLoaded) return;
    [self.scrollView addSubview:childVC.view];
    [self.parentViewController addChildViewController:childVC];
    childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetX = scrollView.contentOffset.x;
    // pageContentScrollView:offsetX:
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:offsetX:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isClickBtn == YES) {
        [self scrollViewDidEndDecelerating:scrollView];
        return;
    }
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > self.startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.childViewControllers.count) {
            progress = 1;
            targetIndex = self.childViewControllers.count - 1;
        }
        // 4、如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    } else { // 右滑
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.childViewControllers.count) {
            originalIndex = self.childViewControllers.count - 1;
        }
    }
    // 3、pageContentViewDelegare; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:progress:originalIndex:targetIndex:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - - - 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标
- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex {
    self.isClickBtn = YES;
    CGFloat offsetX = currentIndex * self.SG_width;
    if (self.isFirstViewLoaded && currentIndex == 0) {
        self.isFirstViewLoaded = NO;
        // 2、默认选中第一个子控制器；self.scrollView.contentOffset ＝ 0
        UIViewController *childVC = self.childViewControllers[0];
        if (childVC.isViewLoaded) return;
        [self.scrollView addSubview:childVC.view];
        [self.parentViewController addChildViewController:childVC];
        childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
    }
    // 1、处理内容偏移
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    // 2、pageContentScrollView:offsetX:
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:offsetX:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self offsetX:offsetX];
    }
}

#pragma mark - - - set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        
    } else {
        _scrollView.scrollEnabled = NO;
    }
}


@end

