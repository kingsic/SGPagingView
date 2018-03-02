//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageContentView.m
//  SGPagingViewExample
//
//  Created by kingsic on 16/10/6.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGPageContentView.h"
#import "UIView+SGPagingView.h"

@interface SGPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>
/// 外界父控制器
@property (nonatomic, weak) UIViewController *parentViewController;
/// 存储子控制器
@property (nonatomic, strong) NSArray *childViewControllers;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
/// 标记按钮是否点击
@property (nonatomic, assign) BOOL isClickBtn;

@end

@implementation SGPageContentView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs {
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentView 所在控制器必须设置" userInfo:nil];
        }
        self.parentViewController = parentVC;
        if (childVCs == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageContentView 子控制器必须设置" userInfo:nil];
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
    self.isClickBtn = NO;
    self.startOffsetX = 0;
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、将所有的子控制器添加父控制器中
    for (UIViewController *childVC in self.childViewControllers) {
        [self.parentViewController addChildViewController:childVC];
    }
    // 2、添加UICollectionView, 用于在Cell中存放控制器的View
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
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - - - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 设置内容
    UIViewController *childVC = self.childViewControllers[indexPath.item];
    childVC.view.frame = cell.contentView.frame;
    [cell.contentView addSubview:childVC.view];
    return cell;
}

#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isClickBtn = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    // pageContentView:offsetX:
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetX = scrollView.contentOffset.x;
    // pageContentView:offsetX:
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
            targetIndex = originalIndex;
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
    self.isClickBtn = YES;
    CGFloat offsetX = currentIndex * self.collectionView.SG_width;
    // 1、处理内容偏移
    self.collectionView.contentOffset = CGPointMake(offsetX, 0);
    // 2、pageContentView:offsetX:
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

#pragma mark - - - set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        
    } else {
        _collectionView.scrollEnabled = NO;
    }
}


@end

