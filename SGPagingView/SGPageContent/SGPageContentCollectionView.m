//
//  SGPageContentCollectionView.m
//  SGPagingViewExample
//
//  Created by kingsic on 16/10/6.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGPageContentCollectionView.h"
#import "UIView+SGPagingView.h"

@interface SGPageContentCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>
/// 外界父控制器
@property (nonatomic, weak) UIViewController *parentViewController;
/// 存储子控制器
@property (nonatomic, strong) NSArray *childViewControllers;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
/// 记录加载的上个子控制器的下标
@property (nonatomic, assign) NSInteger previousCVCIndex;
/// 标记内容滚动
@property (nonatomic, assign) BOOL isScrll;
@end

@implementation SGPageContentCollectionView

static NSString *const cellID = @"cellID";

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentCollectionView 初始化方法中所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentCollectionView 初始化方法中子控制器必须设置" userInfo:nil];
        }
        self.childViewControllers = childVCs;
                
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageContentCollectionViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
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
    // 1、添加UICollectionView, 用于在Cell中存放控制器的View
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat collectionViewX = 0;
        CGFloat collectionViewY = 0;
        CGFloat collectionViewW = self.SG_width;
        CGFloat collectionViewH = self.SG_height;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

#pragma mark - - - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 设置内容
    UIViewController *childVC = self.childViewControllers[indexPath.item];
    [self.parentViewController addChildViewController:childVC];
    [cell.contentView addSubview:childVC.view];
    childVC.view.frame = cell.contentView.frame;
    [childVC didMoveToParentViewController:self.parentViewController];
    return cell;
}

#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
    _isScrll = YES;
    if (self.delegatePageContentCollectionView && [self.delegatePageContentCollectionView respondsToSelector:@selector(pageContentCollectionViewWillBeginDragging)]) {
        [self.delegatePageContentCollectionView pageContentCollectionViewWillBeginDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrll = NO;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 1、记录上个子控制器下标
    _previousCVCIndex = offsetX / scrollView.frame.size.width;
    // 2、pageContentCollectionView:index:
    if (self.delegatePageContentCollectionView && [self.delegatePageContentCollectionView respondsToSelector:@selector(pageContentCollectionView:index:)]) {
        [self.delegatePageContentCollectionView pageContentCollectionView:self index:_previousCVCIndex];
    }
    // 3、pageContentCollectionViewDidEndDecelerating
    if (self.delegatePageContentCollectionView && [self.delegatePageContentCollectionView respondsToSelector:@selector(pageContentCollectionViewDidEndDecelerating)]) {
        [self.delegatePageContentCollectionView pageContentCollectionViewDidEndDecelerating];
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
            targetIndex = originalIndex;
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
    // 3、pageContentCollectionViewDelegate; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    if (self.delegatePageContentCollectionView && [self.delegatePageContentCollectionView respondsToSelector:@selector(pageContentCollectionView:progress:originalIndex:targetIndex:)]) {
        [self.delegatePageContentCollectionView pageContentCollectionView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - - - 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标
- (void)setPageContentCollectionViewCurrentIndex:(NSInteger)currentIndex {
    CGFloat offsetX = currentIndex * self.collectionView.SG_width;
    _startOffsetX = offsetX;
    // 1、处理内容偏移
    if (_previousCVCIndex != currentIndex) {
        [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:_isAnimated];
    }
    // 2、记录上个子控制器下标
    _previousCVCIndex = currentIndex;
    // 3、pageContentCollectionView:index:
    if (self.delegatePageContentCollectionView && [self.delegatePageContentCollectionView respondsToSelector:@selector(pageContentCollectionView:index:)]) {
        [self.delegatePageContentCollectionView pageContentCollectionView:self index:currentIndex];
    }
}

#pragma mark - - - set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        _collectionView.scrollEnabled = YES;
    } else {
        _collectionView.scrollEnabled = NO;
    }
}

- (void)setIsAnimated:(BOOL)isAnimated {
    _isAnimated = isAnimated;
}


@end
