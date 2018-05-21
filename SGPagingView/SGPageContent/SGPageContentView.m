//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageContentView.h
//  SGPagingViewExample
//
//  Created by kingsic on 16/10/6.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGPageContentView.h"
#import "UIView+SGPagingView.h"

@interface SGPageContentView () <UIScrollViewDelegate>
// 外界父控制器
@property (nonatomic, weak) UIViewController *parentViewController;
/// 存储子控制器
@property (nonatomic, strong) NSArray *childViewControllers;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
/// 记录加载的上一个控制器
@property (nonatomic, assign) UIViewController *lastVC;
@end

@implementation SGPageContentView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentView 初始化方法中所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentView 初始化方法中子控制器必须设置" userInfo:nil];
        }
        self.childViewControllers = childVCs;
        
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageContentViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    return [[self alloc] initWithFrame:frame parentVC:parentVC childVCs:childVCs];
}

- (void)initialization {
    self.startOffsetX = 0;
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
    self.startOffsetX = scrollView.contentOffset.x;
    
    CGFloat originalOffsetX = scrollView.contentOffset.x;
    NSInteger originalIndex = originalOffsetX / scrollView.SG_width;
    
    // 记录上个展示的子控制器
    self.lastVC = self.childViewControllers[originalIndex];
    
    if (originalIndex == 0) {
        // 加载下个视图控制器
        [self P_loadNextVCWithIndex:originalIndex offsetX:originalOffsetX];
    } else if (originalIndex == self.childViewControllers.count - 1) {
        // 加载上个视图控制器
        [self P_loadPreviousVCWithIndex:originalIndex offsetX:originalOffsetX];
    } else {
        // 1、加载上个视图控制器
        [self P_loadPreviousVCWithIndex:originalIndex offsetX:originalOffsetX];
        // 2、加载下个视图控制器
        [self P_loadNextVCWithIndex:originalIndex offsetX:originalOffsetX];
    }
}
/// 加载上一个视图控制器
- (void)P_loadPreviousVCWithIndex:(NSInteger)index offsetX:(CGFloat)offsetX {
    UIViewController *childVC = self.childViewControllers[index - 1];
    [self.parentViewController addChildViewController:childVC];
    [childVC beginAppearanceTransition:YES animated:NO];
    [self.scrollView addSubview:childVC.view];
    [childVC endAppearanceTransition];
    childVC.view.frame = CGRectMake(offsetX - self.SG_width, 0, self.SG_width, self.SG_height);
}
/// 加载下一个视图控制器
- (void)P_loadNextVCWithIndex:(NSInteger)index offsetX:(CGFloat)offsetX {
    UIViewController *childVC = self.childViewControllers[index + 1];
    [self.parentViewController addChildViewController:childVC];
    [childVC beginAppearanceTransition:YES animated:NO];
    [self.scrollView addSubview:childVC.view];
    [childVC endAppearanceTransition];
    childVC.view.frame = CGRectMake(offsetX + self.SG_width, 0, self.SG_width, self.SG_height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastVC != nil) {
        [self.lastVC beginAppearanceTransition:NO animated:NO];
        [self.lastVC endAppearanceTransition];
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    // pageContentView:offsetX:
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetX = scrollView.contentOffset.x;
    // pageContentScrollView:offsetX:
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:progress:originalIndex:targetIndex:)]) {
        [self.delegatePageContentView pageContentView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - - - 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标
- (void)setPageContentViewCurrentIndex:(NSInteger)currentIndex {
    if (self.lastVC != nil) {
        [self.lastVC beginAppearanceTransition:NO animated:NO];
        [self.lastVC endAppearanceTransition];
    }
    
    CGFloat offsetX = currentIndex * self.SG_width;
    
    // 1、添加子控制器以及子控制器的 view
    UIViewController *childVC = self.childViewControllers[currentIndex];
    [self.parentViewController addChildViewController:childVC];
    [childVC beginAppearanceTransition:YES animated:NO];
    [self.scrollView addSubview:childVC.view];
    [childVC endAppearanceTransition];
    childVC.view.frame = CGRectMake(offsetX, 0, self.SG_width, self.SG_height);
    
    // 1.1、记录上个展示的子控制器
    self.lastVC = childVC;

    // 2、处理内容偏移
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    // 3、pageContentScrollView:offsetX:
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
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
