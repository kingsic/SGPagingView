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
@property (nonatomic, strong) UIScrollView *scrollView; // scrollView

@property (nonatomic, weak) UIViewController *parentViewController; // 外界父控制器
@property (nonatomic, strong) NSArray *childViewControllers; // 存储子控制器

@property (nonatomic, assign) CGFloat startOffsetX; // 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger previousCVCIndex; // 记录加载的上个子控制器的下标
@property (nonatomic, assign) BOOL isScrll; // 标记内容滚动
@property (nonatomic, weak)  UIViewController *previousCVC; // 记录加载的上个子控制器
@end

@implementation SGPageContentScrollView

#pragma mark - Public
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingViewNilParentVC" reason:@"SGPageContentScrollView 初始化方法中所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingViewNilChildVCs" reason:@"SGPageContentScrollView 初始化方法中子控制器必须设置" userInfo:nil];
        }
        self.childViewControllers = childVCs;
        
        _startOffsetX = 0;
        _previousCVCIndex = -1;
        
        [self addSubview:self.scrollView];
    }
    return self;
}

+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    return [[self alloc] initWithFrame:frame parentVC:parentVC childVCs:childVCs];
}

- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex {
    if (_previousCVCIndex == currentIndex) {
        if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollView:didScrollToIndex:previousIndex:)]) {
            [self.pageContentScrollViewDelegate pageContentScrollView:self didScrollToIndex:currentIndex previousIndex:_previousCVCIndex];
        }
        
        return;
    }
    
    CGFloat offsetX = currentIndex * self.SG_width;
    UIViewController *childVC = self.childViewControllers[currentIndex];
    BOOL oneChildVC = NO;
    if (self.parentViewController.childViewControllers.count == 0) {
        oneChildVC = YES;
    }
    
    // 添加子自控制器和view
    [self addTargetControllerForIndex:currentIndex previousIndex:_previousCVCIndex];
    
    // 移动到指定位置
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:oneChildVC?NO:_isAnimated];
    
    // call delegate
    if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollView:didScrollToIndex:previousIndex:)]) {
        [self.pageContentScrollViewDelegate pageContentScrollView:self didScrollToIndex:currentIndex previousIndex:_previousCVCIndex];
    }
    
    // 记录上个展示的子控制器/index/偏移量
    _previousCVC = childVC;
    _previousCVCIndex = currentIndex;
    _startOffsetX = offsetX;
}

- (void)parentControllerdidMoveToParentViewController:(UIViewController *)parent {
    if (parent && self.parentViewController.childViewControllers.count > 0) {
        UIViewController *vc = self.parentViewController.childViewControllers[0];
        [vc didMoveToParentViewController:self.parentViewController];
    }
}

#pragma mark - Private
// 将指定的index对应的控制器添加到scrollView上
- (void)addTargetControllerForIndex:(NSInteger)currentIndex previousIndex:(NSInteger)previousIndex {
    CGFloat offsetX = currentIndex * self.SG_width;
    UIViewController *childVC = self.childViewControllers[currentIndex];
    
    /** 如果self.parentViewController 首次 addChildViewController,为了自控制器和自控制view的生命周期方法执行顺序完美,需要将self.parentViewController的 `didMoveToParentViewController:`方法通知到SGPageContentScrollView,参见`parentControllerdidMoveToParentViewController`
     */
    BOOL oneChildVC = NO;
    if (self.parentViewController.childViewControllers.count == 0) {
        oneChildVC = YES;
        // childVC will move to parent
        [self.parentViewController addChildViewController:childVC];
        
        // childVC view will apppear
        [childVC beginAppearanceTransition:YES animated:NO];
        
        // add & set frame
        childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
        [self.scrollView addSubview:childVC.view];
    } else {
        // 一个子控制器,只会被添加一次就行了
        BOOL firstAdd = NO;
        if (![self.parentViewController.childViewControllers containsObject:childVC]) {
            firstAdd = YES;
        }
        
        if (firstAdd) {
            // childVC will move to parent
            [self.parentViewController addChildViewController:childVC];
            
            // previousCVC will disappear
            if (self.previousCVC != nil) {
                [self.previousCVC beginAppearanceTransition:NO animated:NO];
            }
            
            // childV will appear
            [childVC beginAppearanceTransition:YES animated:NO];
            
            // add & set frame
            childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
            [self.scrollView addSubview:childVC.view];
            
            // previous did disappear
            if (self.previousCVC != nil ) {
                [self.previousCVC endAppearanceTransition];
            }
            
            // childVC did appear
            [childVC endAppearanceTransition];
            
            // childVC did move to parent
            [childVC didMoveToParentViewController:self.parentViewController];
            
        } else {
            // previous will disappear
            if (self.previousCVC != nil) {
                [self.previousCVC beginAppearanceTransition:NO animated:NO];
            }
            
            // childVC will appear
            [childVC beginAppearanceTransition:YES animated:NO];
            
            // previousVC did disappear
            if (self.previousCVC != nil ) {
                [self.previousCVC endAppearanceTransition];
            }
            
            // childVC did appear
            [childVC endAppearanceTransition];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!_isScrll) {
        _startOffsetX = scrollView.contentOffset.x;
        _isScrll = YES;
    }

    if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollViewWillBeginDragging)]) {
        [self.pageContentScrollViewDelegate pageContentScrollViewWillBeginDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrll = NO;
    
    // 拿到目标index和子控制器
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = offsetX / scrollView.frame.size.width;
    UIViewController *childVC = self.childViewControllers[currentIndex];
    
    if (currentIndex == _previousCVCIndex) {
        return;
    }

    // 添加子自控制器和view
    [self addTargetControllerForIndex:currentIndex previousIndex:_previousCVCIndex];
    
    // call delegate: `pageContentScrollView:index:`
    if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollView:didScrollToIndex:previousIndex:)]) {
        [self.pageContentScrollViewDelegate pageContentScrollView:self didScrollToIndex:currentIndex previousIndex:_previousCVCIndex];
    }
    
    // call delegate: `pageContentScrollViewDidEndDecelerating`
    if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollViewDidEndDecelerating)]) {
        [self.pageContentScrollViewDelegate pageContentScrollViewDidEndDecelerating];
    }
    
    // 记录上个展示的 子控制器 和 index
    self.previousCVC = childVC;
    _previousCVCIndex = currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 排除掉通过点击PageTitleView的回调
    if (_isScrll == NO) {
        return;
    }
    
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > _startOffsetX) { // 左滑
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        originalIndex = currentOffsetX / scrollViewW;
        targetIndex = originalIndex + 1;
        
        if (targetIndex >= self.childViewControllers.count) {
            progress = 1;
            targetIndex = self.childViewControllers.count - 1;
        }
        
        // when stop at target index
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
        
    } else { // 右滑
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        targetIndex = currentOffsetX / scrollViewW;
        originalIndex = targetIndex + 1;
        
        if (originalIndex >= self.childViewControllers.count) {
            originalIndex = self.childViewControllers.count - 1;
        }
    }
    
    //  将 progress／sourceIndex／targetIndex 传递给 pageTitleView
    if (self.pageContentScrollViewDelegate && [self.pageContentScrollViewDelegate respondsToSelector:@selector(pageContentScrollView:didScrollToChangedProgress:originalIndex:targetIndex:)]) {
        [self.pageContentScrollViewDelegate pageContentScrollView:self didScrollToChangedProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - Setter
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    
    self.scrollView.scrollEnabled = isScrollEnabled;
}

#pragma mark - Getter
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

@end
