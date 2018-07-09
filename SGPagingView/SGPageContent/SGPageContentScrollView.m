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
/// 记录加载的上个子控制器
@property (nonatomic, weak) UIViewController *previousCVC;
/// 记录加载的上个子控制器的下标
@property (nonatomic, assign) NSInteger previousCVCIndex;
/// 标记内容滚动
@property (nonatomic, assign) BOOL isScrll;
@end

@implementation SGPageContentScrollView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentScrollView 初始化方法中所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentScrollView 初始化方法中子控制器必须设置" userInfo:nil];
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
    _startOffsetX = 0;
    _previousCVCIndex = -1;
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
    _startOffsetX = scrollView.contentOffset.x;
    _isScrll = YES;
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollViewWillBeginDragging)]) {
        [self.delegatePageContentScrollView pageContentScrollViewWillBeginDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrll = NO;
    // 1、根据标题下标计算 pageContent 偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
    if (_startOffsetX != offsetX) {
        [self.previousCVC beginAppearanceTransition:NO animated:NO];
    }
    // 3、获取当前显示子控制器的下标
    NSInteger index = offsetX / scrollView.frame.size.width;
    // 4、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
    UIViewController *childVC = self.childViewControllers[index];
    [self.parentViewController addChildViewController:childVC];
    [childVC beginAppearanceTransition:YES animated:NO];
    [self.scrollView addSubview:childVC.view];
    // 2.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
    if (_startOffsetX != offsetX) {
        [self.previousCVC endAppearanceTransition];
    }
    [childVC endAppearanceTransition];
    childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
    [childVC didMoveToParentViewController:self.parentViewController];

    // 4.1、记录上个展示的子控制器、记录当前子控制器偏移量
    self.previousCVC = childVC;
    _previousCVCIndex = index;
    
    // 5、pageContentScrollView:index:
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:index:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self index:index];
    }
    
    // 6、pageContentScrollViewDidEndDecelerating
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollViewDidEndDecelerating)]) {
        [self.delegatePageContentScrollView pageContentScrollViewDidEndDecelerating];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isAnimated == YES && _isScrll == NO) {
        return;
    }
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > _startOffsetX) { // 左滑
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
        if (currentOffsetX - _startOffsetX == scrollViewW) {
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
    // 3、pageContentScrollViewDelegate; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:progress:originalIndex:targetIndex:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - - - 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标
- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex {
    // 1、根据标题下标计算 pageContent 偏移量
    CGFloat offsetX = currentIndex * self.SG_width;

    // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
    if (self.previousCVC != nil && _previousCVCIndex != currentIndex) {
        [self.previousCVC beginAppearanceTransition:NO animated:NO];
    }

    // 3、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
    if (_previousCVCIndex != currentIndex) {
        UIViewController *childVC = self.childViewControllers[currentIndex];
        [self.parentViewController addChildViewController:childVC];
        [childVC beginAppearanceTransition:YES animated:NO];
        [self.scrollView addSubview:childVC.view];
        // 1.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
        if (self.previousCVC != nil && _previousCVCIndex != currentIndex) {
            [self.previousCVC endAppearanceTransition];
        }
        [childVC endAppearanceTransition];
        childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
        [childVC didMoveToParentViewController:self.parentViewController];
        // 3.1、记录上个子控制器
        self.previousCVC = childVC;
        
        // 4、处理内容偏移
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:_isAnimated];
    }
    // 3.2、记录上个子控制器下标
    _previousCVCIndex = currentIndex;
    // 3.3、重置 _startOffsetX
    _startOffsetX = offsetX;
    
    // 5、pageContentScrollView:index:
    if (self.delegatePageContentScrollView && [self.delegatePageContentScrollView respondsToSelector:@selector(pageContentScrollView:index:)]) {
        [self.delegatePageContentScrollView pageContentScrollView:self index:currentIndex];
    }
}

#pragma mark - - - set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        _scrollView.scrollEnabled = YES;
    } else {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)setIsAnimated:(BOOL)isAnimated {
    _isAnimated = isAnimated;
}


@end
