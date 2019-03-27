//
//  SGPageTitleView.m
//  SGPagingViewExample
//
//  Created by kingsic on 17/4/10.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "SGPageTitleView.h"
#import "UIView+SGPagingView.h"
#import "UIButton+SGPagingView.h"
#import "SGPageTitleViewConfigure.h"

#pragma mark - - - SGPageTitleButton
@interface SGPageTitleButton : UIButton
@end
@implementation SGPageTitleButton
- (void)setHighlighted:(BOOL)highlighted {
    
}
@end

#pragma mark - - - SGPageTitleView
@interface SGPageTitleView ()
/// SGPageTitleViewDelegate
@property (nonatomic, weak) id<SGPageTitleViewDelegate> delegatePageTitleView;
/// SGPageTitleView 配置信息
@property (nonatomic, strong) SGPageTitleViewConfigure *configure;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 指示器
@property (nonatomic, strong) UIView *indicatorView;
/// 底部分割线
@property (nonatomic, strong) UIView *bottomSeparator;
/// 保存外界传递过来的标题数组
@property (nonatomic, strong) NSArray *titleArr;
/// 存储标题按钮的数组
@property (nonatomic, strong) NSMutableArray *btnMArr;
/// 存储标题按钮间分割线的数组
@property (nonatomic, strong) NSMutableArray *VSeparatorMArr;
/// tempBtn
@property (nonatomic, strong) UIButton *tempBtn;
/// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
/// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;
/// 标记按钮下标
@property (nonatomic, assign) NSInteger signBtnIndex;
/// 标记按钮是否点击
@property (nonatomic, assign) BOOL signBtnClick;

/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;
@end

@implementation SGPageTitleView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.77];
        if (delegate == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的代理必须设置" userInfo:nil];
        }
        self.delegatePageTitleView = delegate;
        if (titleNames == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的标题数组必须设置" userInfo:nil];
        }
        self.titleArr = titleNames;
        if (configure == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的配置信息必须设置" userInfo:nil];
        }
        self.configure = configure;
        
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure {
    return [[self alloc] initWithFrame:frame delegate:delegate titleNames:titleNames configure:configure];
}

- (void)initialization {
    _selectedIndex = 0;
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    // 2、添加标题按钮
    [self setupTitleButtons];
    // 3、添加底部分割线
    if (self.configure.showBottomSeparator) {
        [self addSubview:self.bottomSeparator];
    }
    // 4、添加指示器
    if (self.configure.showIndicator) {
        [self.scrollView insertSubview:self.indicatorView atIndex:0];
    }
}

#pragma mark - - - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 布局子控制器的 frame
    [self P_layoutSubviews];
    
    // 选中按钮下标初始值
    [self P_btn_action:self.btnMArr[_selectedIndex]];
}

#pragma mark - - - 布局子控制器的 frame
- (void)P_layoutSubviews {
    CGFloat selfHeight = self.frame.size.height;
    // 1、布局 UIScrollView 的 frame
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, selfHeight);
    // 2、布局标题按钮的 frame
    NSInteger titleCount = self.titleArr.count;
    if (self.allBtnWidth <= self.bounds.size.width) { // SGPageTitleView 静止样式
        CGFloat btnY = 0;
        CGFloat btnW = self.frame.size.width / titleCount;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == SGIndicatorStyleDefault) {
            btnH = selfHeight - self.configure.indicatorHeight;
        } else {
            btnH = selfHeight;
        }
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat btnX = btnW * idx;
            UIButton *btn = obj;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, selfHeight);
        // 2.2、布局标题间分割线的 frame
        if (self.configure.showVerticalSeparator) {
            CGFloat VSeparatorW = 1;
            CGFloat VSeparatorH = selfHeight - self.configure.verticalSeparatorReduceHeight;
            if (VSeparatorH <= 0) {
                VSeparatorH = selfHeight;
            }
            CGFloat VSeparatorY = 0.5 * (selfHeight - VSeparatorH);
            [self.VSeparatorMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat VSeparatorX = btnW * (idx + 1) - 0.5 * VSeparatorW;
                UIView *VSeparator = obj;
                VSeparator.frame = CGRectMake(VSeparatorX, VSeparatorY, VSeparatorW, VSeparatorH);
            }];
        }
        
    } else { // SGPageTitleView 滚动样式
        __block CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == SGIndicatorStyleDefault) {
            btnH = selfHeight - self.configure.indicatorHeight;
        } else {
            btnH = selfHeight;
        }
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize tempSize = [self P_sizeWithString:self.titleArr[idx] font:self.configure.titleFont];
            CGFloat btnW = tempSize.width + self.configure.titleAdditionalWidth;
            UIButton *btn = obj;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btnX = btnX + btnW;
        }];
        UIButton *lastBtn = self.btnMArr.lastObject;
        CGFloat scrollViewWidth = CGRectGetMaxX(lastBtn.frame);
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, selfHeight);
        // 2.2、布局标题间分割线的 frame
        if (self.configure.showVerticalSeparator) {
            CGFloat VSeparatorW = 1;
            CGFloat VSeparatorH = selfHeight - self.configure.verticalSeparatorReduceHeight;
            if (VSeparatorH <= 0) {
                VSeparatorH = selfHeight;
            }
            CGFloat VSeparatorY = 0.5 * (selfHeight - VSeparatorH);
            [self.VSeparatorMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = self.btnMArr[idx];
                CGFloat VSeparatorX = CGRectGetMaxX(btn.frame) - 0.5 * VSeparatorW;
                UIView *VSeparator = obj;
                VSeparator.frame = CGRectMake(VSeparatorX, VSeparatorY, VSeparatorW, VSeparatorH);
            }];
        }
    }
    // 3、布局底部分割线的 frame
    if (self.configure.showBottomSeparator) {
        CGFloat bottomSeparatorW = self.SG_width;
        CGFloat bottomSeparatorH = 0.5;
        CGFloat bottomSeparatorX = 0;
        CGFloat bottomSeparatorY = self.SG_height - bottomSeparatorH;
        _bottomSeparator.frame = CGRectMake(bottomSeparatorX, bottomSeparatorY, bottomSeparatorW, bottomSeparatorH);
    }
    // 4、布局指示器的 frame
    if (self.configure.showIndicator) {
        if (self.configure.indicatorStyle == SGIndicatorStyleCover) {
            CGSize tempSize = [self P_sizeWithString:[self.btnMArr[0] currentTitle] font:self.configure.titleFont];
            CGFloat tempIndicatorViewH = tempSize.height;
            if (self.configure.indicatorHeight > self.SG_height) {
                _indicatorView.SG_y = 0;
                _indicatorView.SG_height = self.SG_height;
            } else if (self.configure.indicatorHeight < tempIndicatorViewH) {
                _indicatorView.SG_y = 0.5 * (self.SG_height - tempIndicatorViewH);
                _indicatorView.SG_height = tempIndicatorViewH;
            } else {
                _indicatorView.SG_y = 0.5 * (self.SG_height - self.configure.indicatorHeight);
                _indicatorView.SG_height = self.configure.indicatorHeight;
            }
        } else {
            CGFloat indicatorViewH = self.configure.indicatorHeight;
            _indicatorView.SG_height = indicatorViewH;
            _indicatorView.SG_y = self.SG_height - indicatorViewH - self.configure.indicatorToBottomDistance;
        }
        // 4.1、指示器圆角处理
        if (self.configure.indicatorCornerRadius > 0.5 * _indicatorView.SG_height) {
            _indicatorView.layer.cornerRadius = 0.5 * _indicatorView.SG_height;
        } else {
            _indicatorView.layer.cornerRadius = self.configure.indicatorCornerRadius;
        }
    }
}

#pragma mark - - - 计算字符串尺寸
- (CGSize)P_sizeWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - - - 懒加载
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnMArr {
    if (!_btnMArr) {
        _btnMArr = [[NSMutableArray alloc] init];
    }
    return _btnMArr;
}

- (NSMutableArray *)VSeparatorMArr {
    if (!_VSeparatorMArr) {
        _VSeparatorMArr = [[NSMutableArray alloc] init];
    }
    return _VSeparatorMArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        if (_configure.needBounces == NO) {
            _scrollView.bounces = NO;
        }
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        if (self.configure.indicatorStyle == SGIndicatorStyleCover) {
            _indicatorView.layer.borderWidth = self.configure.indicatorBorderWidth;
            _indicatorView.layer.borderColor = self.configure.indicatorBorderColor.CGColor;
        }
        _indicatorView.backgroundColor = self.configure.indicatorColor;
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] init];
        _bottomSeparator.backgroundColor = self.configure.bottomSeparatorColor;
    }
    return _bottomSeparator;
}

#pragma mark - - - 添加标题按钮
- (void)setupTitleButtons {
    NSInteger titleCount = self.titleArr.count;

    // 计算所有按钮的文字宽度
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize tempSize = [self P_sizeWithString:obj font:self.configure.titleFont];
        CGFloat tempWidth = tempSize.width;
        self.allBtnTextWidth += tempWidth;
    }];
    // 所有按钮文字宽度 ＋ 所有按钮额外增加的宽度
    self.allBtnWidth = self.allBtnTextWidth + self.configure.titleAdditionalWidth * titleCount;
    self.allBtnWidth = ceilf(self.allBtnWidth);
    if (self.allBtnWidth <= self.bounds.size.width) { // SGPageTitleView 静止样式
        for (NSInteger index = 0; index < titleCount; index++) {
            SGPageTitleButton *btn = [[SGPageTitleButton alloc] init];
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleSelectedColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(P_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }

    } else { // SGPageTitleView 滚动样式
        for (NSInteger index = 0; index < titleCount; index++) {
            // 1、添加按钮
            SGPageTitleButton *btn = [[SGPageTitleButton alloc] init];
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleSelectedColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(P_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }
    }
    // 标题文字渐变效果下对标题文字默认、选中状态下颜色的记录
    if (self.configure.titleGradientEffect) {
        [self setupStartColor:self.configure.titleColor];
        [self setupEndColor:self.configure.titleSelectedColor];
    }
    
    // 添加按钮之间分割线
    if (self.configure.showVerticalSeparator) {
        for (NSInteger index = 0; index < titleCount - 1; index++) {
            UIView *VSeparator = [[UIView alloc] init];
            VSeparator.backgroundColor = self.configure.verticalSeparatorColor;
            [self.VSeparatorMArr addObject:VSeparator];
            [self.scrollView addSubview:VSeparator];
        }
    }
}

#pragma mark - - - 标题按钮的点击事件
- (void)P_btn_action:(UIButton *)button {
    // 1、改变按钮的选择状态
    [self P_changeSelectedButton:button];
    // 2、标题滚动样式下选中标题居中处理
    if (self.allBtnWidth > self.frame.size.width) {
        _signBtnClick = YES;
        [self P_selectedBtnCenter:button];
    }
    // 3、改变有关指示器的相关操作
    [self P_changeIndicatorWithButton:button];

    // 4、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
        [self.delegatePageTitleView pageTitleView:self selectedIndex:button.tag];
    }
    // 5、标记按钮下标
    _signBtnIndex = button.tag;
}

#pragma mark - - - 改变按钮的选择状态
- (void)P_changeSelectedButton:(UIButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    } else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
    } else if (self.tempBtn != button && self.tempBtn != nil){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
    
    UIFont *configureTitleSelectedFont = self.configure.titleSelectedFont;
    UIFont *defaultTitleFont = [UIFont systemFontOfSize:15];
    if ([configureTitleSelectedFont.fontName isEqualToString:defaultTitleFont.fontName] && configureTitleSelectedFont.pointSize == defaultTitleFont.pointSize) {
        // 标题文字缩放属性(开启 titleSelectedFont 属性将不起作用)
        if (self.configure.titleTextZoom == YES) {
            [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.transform = CGAffineTransformIdentity;
            }];
            CGFloat afterZoomRatio = 1 + self.configure.titleTextZoomRatio;
            button.transform = CGAffineTransformMakeScale(afterZoomRatio, afterZoomRatio);
        }
        
        // 此处作用：避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
        if (self.configure.titleGradientEffect == YES) {
            [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.textColor = self.configure.titleColor;
            }];
            button.titleLabel.textColor = self.configure.titleSelectedColor;
        }
    } else {
        // 此处作用：避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
        if (self.configure.titleGradientEffect == YES) {
            [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.textColor = self.configure.titleColor;
                btn.titleLabel.font = self.configure.titleFont;
            }];
            button.titleLabel.textColor = self.configure.titleSelectedColor;
            button.titleLabel.font = self.configure.titleSelectedFont;
        } else {
            [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.font = self.configure.titleFont;
            }];
            button.titleLabel.font = self.configure.titleSelectedFont;
        }
    }
}

#pragma mark - - - 标题滚动样式下选中标题居中处理
- (void)P_selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.frame.size.width * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.frame.size.width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - - - 改变有关指示器的相关操作
- (void)P_changeIndicatorWithButton:(UIButton *)button {
    [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
        if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (self.configure.showIndicator) {
                self.indicatorView.SG_width = self.configure.indicatorFixedWidth;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
            return;
        }
        
        if (self.configure.indicatorStyle == SGIndicatorStyleDynamic) {
            if (self.configure.showIndicator) {
                self.indicatorView.SG_width = self.configure.indicatorDynamicWidth;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
            return;
        }
        
        CGSize tempSize = [self P_sizeWithString:button.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
        if (tempIndicatorWidth > button.SG_width) {
            tempIndicatorWidth = button.SG_width;
        }
        if (self.configure.showIndicator) {
            self.indicatorView.SG_width = tempIndicatorWidth;
            self.indicatorView.SG_centerX = button.SG_centerX;
        }
    }];
}

#pragma mark - - - 给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    // 1、取出 originalBtn、targetBtn
    UIButton *originalBtn = self.btnMArr[originalIndex];
    UIButton *targetBtn = self.btnMArr[targetIndex];
    _signBtnIndex = targetBtn.tag;
    // 2、标题滚动样式下选中标题居中处理
    if (self.allBtnWidth > self.frame.size.width) {
        if (_signBtnClick == NO) {
            [self P_selectedBtnCenter:targetBtn];
        }
        _signBtnClick = NO;
    }
    // 3、处理指示器的逻辑
    if (self.allBtnWidth <= self.bounds.size.width) { /// SGPageTitleView 静止样式
        if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleDefault) {
            [self P_staticIndicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_staticIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }

    } else { /// SGPageTitleView 可滚动
        if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleDefault) {
            [self P_indicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
    }
    // 4、颜色的渐变(复杂)
    if (self.configure.titleGradientEffect == YES) {
        [self P_isTitleGradientEffectWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
    }
    
    // 5 、标题文字缩放属性(开启文字选中字号属性将不起作用)
    UIFont *configureTitleSelectedFont = self.configure.titleSelectedFont;
    UIFont *defaultTitleFont = [UIFont systemFontOfSize:15];
    if ([configureTitleSelectedFont.fontName isEqualToString:defaultTitleFont.fontName] && configureTitleSelectedFont.pointSize == defaultTitleFont.pointSize) {
        if (self.configure.titleTextZoom == YES) {
            // originalBtn 缩放
            CGFloat originalBtnZoomRatio = (1 - progress) * self.configure.titleTextZoomRatio;
            originalBtn.transform = CGAffineTransformMakeScale(originalBtnZoomRatio + 1, originalBtnZoomRatio + 1);
            // targetBtn 缩放
            CGFloat targetBtnZoomRatio = progress * self.configure.titleTextZoomRatio;
            targetBtn.transform = CGAffineTransformMakeScale(targetBtnZoomRatio + 1, targetBtnZoomRatio + 1);
        }
    };
}

/** 根据下标值添加 badge */
- (void)addBadgeForIndex:(NSInteger)index {
    /// 这里使用GCD延迟函数的目的：是将 addBadgeForIndex 方法内部的 badge 布局在 layoutSubviews 之后调用，这里的 badge 是添加在标题（按钮），badge 的布局也可在 layoutSubviews 中在标题（按钮）布局之后布局。这里采取了GCD延迟函数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn = self.btnMArr[index];
        UIView *badge = [[UIView alloc] init];
        CGFloat btnTextWidth = [self P_sizeWithString:btn.currentTitle font:self.configure.titleFont].width;
        CGFloat btnTextHeight = [self P_sizeWithString:btn.currentTitle font:self.configure.titleFont].height;
        CGFloat badgeX = 0.5 * (btn.SG_width - btnTextWidth) + btnTextWidth + self.configure.badgeOff.x;
        CGFloat badgeY = 0.5 * (btn.SG_height - btnTextHeight) + self.configure.badgeOff.y - self.configure.badgeSize;
        CGFloat badgeWidth = self.configure.badgeSize;
        CGFloat badgeHeight = badgeWidth;
        badge.frame = CGRectMake(badgeX, badgeY, badgeWidth, badgeHeight);
        badge.layer.backgroundColor = self.configure.badgeColor.CGColor;
        badge.layer.cornerRadius = 0.5 * self.configure.badgeSize;
//        badge.tag = 2018 + index;
        [btn addSubview:badge];
    });
}
/** 根据下标值移除 badge */
- (void)removeBadgeForIndex:(NSInteger)index {
    UIButton *btn = self.btnMArr[index];
    [btn.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.tag != 0) {
        /// 之前使用 tag 进行 btn 内部子视图区分（UIImageView、UIButtonLabel的 tag 值都是 0）
        /// isMemberOfClass 这个方法明确某个类
        if ([obj isMemberOfClass:[UIView class]]) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
}

/**
 *  根据标题下标值重置标题文字
 *
 *  @param title    标题名
 *  @param index    标题所对应的下标
 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index {
    UIButton *button = (UIButton *)self.btnMArr[index];
    [button setTitle:title forState:UIControlStateNormal];
    if (_signBtnIndex == index) {
        if (self.configure.indicatorStyle == SGIndicatorStyleDefault || self.configure.indicatorStyle == SGIndicatorStyleCover) {
            CGSize tempSize = [self P_sizeWithString:button.currentTitle font:self.configure.titleFont];
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
            if (tempIndicatorWidth > button.SG_width) {
                tempIndicatorWidth = button.SG_width;
            }
            if (self.configure.showIndicator) {
                _indicatorView.SG_width = tempIndicatorWidth;
                _indicatorView.SG_centerX = button.SG_centerX;
            }
        }
    }
}

/** 重置指示器颜色方法 */
- (void)resetIndicatorColor:(UIColor *)color {
    _indicatorView.backgroundColor = color;
}
/**
 *  重置标题普通状态、选中状态下文字颜色方法
 *
 *  @param color       普通状态下标题文字颜色
 *  @param selectedColor       选中状态下标题文字颜色
 */
- (void)resetTitleColor:(UIColor *)color titleSelectedColor:(UIColor *)selectedColor {
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitleColor:color forState:(UIControlStateNormal)];
        [btn setTitleColor:selectedColor forState:(UIControlStateSelected)];
    }];
}
/**
 *  重置标题普通状态、选中状态下文字颜色及指示器颜色方法
 *
 *  @param color       普通状态下标题文字颜色
 *  @param selectedColor       选中状态下标题文字颜色
 *  @param indicatorColor      指示器颜色
 */
- (void)resetTitleColor:(UIColor *)color titleSelectedColor:(UIColor *)selectedColor indicatorColor:(UIColor *)indicatorColor {
    [self resetTitleColor:color titleSelectedColor:selectedColor];
    [self resetIndicatorColor:indicatorColor];
}

/**
 *  根据标题下标值设置标题的 attributedTitle 属性
 *
 *  @param attributedTitle      attributedTitle 属性
 *  @param selectedAttributedTitle      选中状态下 attributedTitle 属性
 *  @param index     标题所对应的下标
 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index {
    UIButton *button = (UIButton *)self.btnMArr[index];
    [button setAttributedTitle:attributedTitle forState:(UIControlStateNormal)];
    [button setAttributedTitle:selectedAttributedTitle forState:(UIControlStateSelected)];
}

/**
 *  设置标题图片及位置样式
 *
 *  @param images       默认图片名数组
 *  @param selectedImages       选中图片名数组
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 */
- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectedImages imagePositionType:(SGImagePositionType)imagePositionType spacing:(CGFloat)spacing {
    NSInteger imagesCount = images.count;
    NSInteger selectedImagesCount = selectedImages.count;
    NSInteger titlesCount = self.titleArr.count;
    if (imagesCount < selectedImagesCount) {
        NSLog(@"温馨提示：SGPageTitleView -> [setImages:selectedImages:imagePositionType:spacing] 方法中 images 必须大于或者等于selectedImages，否则 imagePositionTypeDefault 以外的其他样式图片及文字布局将会出现问题");
    }
    
    if (imagesCount < titlesCount) {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            if (idx >= imagesCount - 1) {
                *stop = YES;
            }
            [self P_btn:btn imageName:images[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateNormal)];
        }];
    } else {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            [self P_btn:btn imageName:images[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateNormal)];
        }];
    }
    
    if (selectedImagesCount < titlesCount) {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            if (idx >= selectedImagesCount - 1) {
                *stop = YES;
            }
            [self P_btn:btn imageName:selectedImages[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateSelected)];
        }];
    } else {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            [self P_btn:btn imageName:selectedImages[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateSelected)];
        }];
    }
}
/**
 *  根据标题下标设置标题图片及位置样式
 *
 *  @param image       默认图片名
 *  @param selectedImage       选中时图片名
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 *  @param index        标题对应下标值
 */
- (void)setImage:(NSString *)image selectedImage:(NSString *)selectedImage imagePositionType:(SGImagePositionType)imagePositionType spacing:(CGFloat)spacing forIndex:(NSInteger)index {
    UIFont *configureTitleFont = self.configure.titleFont;
    UIFont *configureTitleSelectedFont = self.configure.titleSelectedFont;
    if ([configureTitleFont.fontName isEqualToString:configureTitleSelectedFont.fontName] && configureTitleFont.pointSize == configureTitleSelectedFont.pointSize) {
        UIButton *btn = self.btnMArr[index];
        if (image != nil) {
            [self P_btn:btn imageName:image imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateNormal)];
        }
        if (selectedImage != nil) {
            [self P_btn:btn imageName:selectedImage imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateSelected)];
        }
        return;
    }
    
    NSLog(@"配置属性 titleFont 必须与配置属性 titleSelectedFont 一致，否则 setImage:selectedImage:imagePositionType:spacing:forIndex 方法将不起任何作用");
}

/// imagePositionType 样式设置方法抽取
- (void)P_btn:(UIButton *)btn imageName:(NSString *)imageName imagePositionType:(SGImagePositionType)imagePositionType spacing:(CGFloat)spacing btnControlState:(UIControlState)btnControlState {
    if (imagePositionType == SGImagePositionTypeDefault) {
        [btn SG_imagePositionStyle:SGImagePositionStyleDefault spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
        return;
    }
    if (imagePositionType == SGImagePositionTypeRight) {
        [btn SG_imagePositionStyle:SGImagePositionStyleRight spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
        return;
    }
    if (imagePositionType == SGImagePositionTypeTop) {
        [btn SG_imagePositionStyle:SGImagePositionStyleTop spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
        return;
    }
    if (imagePositionType == SGImagePositionTypeBottom) {
        [btn SG_imagePositionStyle:SGImagePositionStyleBottom spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_staticIndicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    
    /// 处理 SGIndicatorStyleFixed 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        CGFloat btnWidth = self.SG_width / self.titleArr.count;
        CGFloat targetBtnMaxX = (targetBtn.tag + 1) * btnWidth;
        CGFloat originalBtnMaxX = (originalBtn.tag + 1) * btnWidth;

        CGFloat targetBtnIndicatorX = targetBtnMaxX - 0.5 * (btnWidth - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = originalBtnMaxX - 0.5 * (btnWidth - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        if (self.configure.showIndicator) {
            _indicatorView.SG_x = originalBtnIndicatorX + progress * totalOffsetX;
        }
        return;
    }
    
    /// 处理 SGIndicatorStyleDynamic 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        CGFloat btnWidth = self.SG_width / self.titleArr.count;
        CGFloat targetBtnMaxX = (targetBtn.tag + 1) * btnWidth;;
        CGFloat originalBtnMaxX = (originalBtn.tag + 1) * btnWidth;
        
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            if (progress <= 0.5) {
                if (self.configure.showIndicator) {
                    _indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * progress * btnWidth;
                }
            } else {
                CGFloat targetBtnIndicatorX = targetBtnMaxX - 0.5 * (btnWidth - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = targetBtnIndicatorX + 2 * (progress - 1) * btnWidth;
                    _indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth;
                }
            }
        } else {
            if (progress <= 0.5) {
                CGFloat originalBtnIndicatorX = originalBtnMaxX - 0.5 * (btnWidth - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = originalBtnIndicatorX - 2 * progress * btnWidth;
                    _indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * progress * btnWidth;
                }
            } else {
                CGFloat targetBtnIndicatorX = targetBtnMaxX - self.configure.indicatorDynamicWidth - 0.5 * (btnWidth - self.configure.indicatorDynamicWidth);
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = targetBtnIndicatorX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    _indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * btnWidth;
                }
            }
        }
        return;
    }
    
    /// 处理指示器下划线、遮盖样式
    CGFloat btnWidth = self.SG_width / self.titleArr.count;
    // 文字宽度
    CGFloat targetBtnTextWidth = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont].width;
    CGFloat originalBtnTextWidth = [self P_sizeWithString:originalBtn.currentTitle font:self.configure.titleFont].width;
    CGFloat targetBtnMaxX = 0.0;
    CGFloat originalBtnMaxX = 0.0;
    /// 这里的缩放是标题按钮缩放，按钮的 frame 会发生变化，开启缩放性后，如果指示器还使用 CGRectGetMaxX 获取按钮的最大 X 值是会比之前的值大，这样会导致指示器的位置相对按钮位置不对应（存在一定的偏移）；所以这里根据按钮下标计算原本的 CGRectGetMaxX 的值，缩放后的不去理会，这样指示器位置会与按钮位置保持一致。
    /// 在缩放属性关闭情况下，下面的计算结果一样的，所以可以省略判断，直接采用第一种计算结果（这个只是做个记录对指示器位置与按钮保持一致的方法）
    if (self.configure.titleTextZoom == YES) {
        targetBtnMaxX = (targetBtn.tag + 1) * btnWidth;
        originalBtnMaxX = (originalBtn.tag + 1) * btnWidth;
    } else {
        targetBtnMaxX = CGRectGetMaxX(targetBtn.frame);
        originalBtnMaxX = CGRectGetMaxX(originalBtn.frame);
    }
    CGFloat targetIndicatorX = targetBtnMaxX - targetBtnTextWidth - 0.5 * (btnWidth - targetBtnTextWidth + self.configure.indicatorAdditionalWidth);
    CGFloat originalIndicatorX = originalBtnMaxX - originalBtnTextWidth - 0.5 * (btnWidth - originalBtnTextWidth + self.configure.indicatorAdditionalWidth);
    CGFloat totalOffsetX = targetIndicatorX - originalIndicatorX;
    
    /// 2、计算文字之间差值
    // targetBtn 文字右边的 x 值
    CGFloat targetBtnRightTextX = targetBtnMaxX - 0.5 * (btnWidth - targetBtnTextWidth);
    // originalBtn 文字右边的 x 值
    CGFloat originalBtnRightTextX = originalBtnMaxX - 0.5 * (btnWidth - originalBtnTextWidth);
    CGFloat totalRightTextDistance = targetBtnRightTextX - originalBtnRightTextX;
    // 计算 indicatorView 滚动时 x 的偏移量
    CGFloat offsetX = totalOffsetX * progress;
    // 计算 indicatorView 滚动时文字宽度的偏移量
    CGFloat distance = progress * (totalRightTextDistance - totalOffsetX);
    
    /// 3、计算 indicatorView 新的 frame
    if (self.configure.showIndicator) {
        _indicatorView.SG_x = originalIndicatorX + offsetX;
    }
    
    CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + originalBtnTextWidth + distance;
    if (tempIndicatorWidth >= targetBtn.SG_width) {
        CGFloat moveTotalX = targetBtn.SG_origin.x - originalBtn.SG_origin.x;
        CGFloat moveX = moveTotalX * progress;
        if (self.configure.showIndicator) {
            _indicatorView.SG_centerX = originalBtn.SG_centerX + moveX;
        }
    } else {
        if (self.configure.showIndicator) {
            _indicatorView.SG_width = tempIndicatorWidth;
        }
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_indicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /// 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    /// 处理 SGIndicatorStyleFixed 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        CGFloat targetIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (targetBtn.SG_width - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalIndicatorX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorFixedWidth - 0.5 * (originalBtn.SG_width - self.configure.indicatorFixedWidth);
        CGFloat totalOffsetX = targetIndicatorX - originalIndicatorX;
        CGFloat offsetX = totalOffsetX * progress;
        if (self.configure.showIndicator) {
            _indicatorView.SG_x = originalIndicatorX + offsetX;
        }
        return;
    }
    
    /// 处理 SGIndicatorStyleDynamic 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            // targetBtn 与 originalBtn 中心点之间的距离
            CGFloat btnCenterXDistance = targetBtn.SG_centerX - originalBtn.SG_centerX;
            if (progress <= 0.5) {
                if (self.configure.showIndicator) {
                    _indicatorView.SG_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
                }
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.SG_width - self.configure.indicatorDynamicWidth);
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance;
                    _indicatorView.SG_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
                }
            }
        } else {
            // originalBtn 与 targetBtn 中心点之间的距离
            CGFloat btnCenterXDistance = originalBtn.SG_centerX - targetBtn.SG_centerX;
            if (progress <= 0.5) {
                CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (originalBtn.SG_width - self.configure.indicatorDynamicWidth);
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = originalBtnX - 2 * progress * btnCenterXDistance;
                    _indicatorView.SG_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
                }
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.SG_width - self.configure.indicatorDynamicWidth);
                if (self.configure.showIndicator) {
                    _indicatorView.SG_x = targetBtnX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                    _indicatorView.SG_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
                }
            }
        }
        return;
    }
    
    /// 处理指示器下划线、遮盖样式
    if (self.configure.titleTextZoom && self.configure.showIndicator) {
//        NSLog(@"标题文字缩放属性与指示器下划线、遮盖样式下不兼容，但固定及动态样式下兼容");
        return;
    }

    // 1、计算 targetBtn 与 originalBtn 之间的 x 差值
    CGFloat totalOffsetX = targetBtn.SG_x - originalBtn.SG_x;
    // 2、计算 targetBtn 与 originalBtn 之间距离的差值
    CGFloat totalDistance = CGRectGetMaxX(targetBtn.frame) - CGRectGetMaxX(originalBtn.frame);
    /// 计算 indicator 滚动时 x 的偏移量
    CGFloat offsetX = 0.0;
    /// 计算 indicator 滚动时宽度的偏移量
    CGFloat distance = 0.0;
    
    CGFloat targetBtnTextWidth = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont].width;
    CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + targetBtnTextWidth;
    if (tempIndicatorWidth >= targetBtn.SG_width) {
        offsetX = totalOffsetX * progress;
        distance = progress * (totalDistance - totalOffsetX);
        if (self.configure.showIndicator) {
            _indicatorView.SG_x = originalBtn.SG_x + offsetX;
            _indicatorView.SG_width = originalBtn.SG_width + distance;
        }
    } else {
        offsetX = totalOffsetX * progress + 0.5 * self.configure.titleAdditionalWidth - 0.5 * self.configure.indicatorAdditionalWidth;
        distance = progress * (totalDistance - totalOffsetX) - self.configure.titleAdditionalWidth;
        /// 计算 indicator 新的 frame
        if (self.configure.showIndicator) {
            _indicatorView.SG_x = originalBtn.SG_x + offsetX;
            _indicatorView.SG_width = originalBtn.SG_width + distance + self.configure.indicatorAdditionalWidth;
        }
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_staticIndicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /// 1、处理 SGIndicatorScrollStyleHalf 逻辑
    if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleHalf) {
        // 1、处理 SGIndicatorStyleFixed 样式
        if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        // 2、处理指示器下划线、遮盖样式
        if (progress >= 0.5) {
            CGSize tempSize = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont];
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                    }
                } else {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = tempIndicatorWidth;
                    }
                }
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                }
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGSize tempSize = [self P_sizeWithString:originalBtn.currentTitle font:self.configure.titleFont];
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = originalBtn.SG_width;
                    }
                } else {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = tempIndicatorWidth;
                    }
                }
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                }
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }

    
    /// 2、处理 SGIndicatorScrollStyleEnd 逻辑
    // 1、处理 SGIndicatorStyleFixed 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress == 1.0) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
        return;
    }
    
    // 2、处理指示器下划线、遮盖样式
    if (progress == 1.0) {
        CGSize tempSize = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = targetBtn.SG_width;
                }
            } else {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
            }
            if (self.configure.showIndicator) {
                self.indicatorView.SG_centerX = targetBtn.SG_centerX;
            }
            [self P_changeSelectedButton:targetBtn];
        }];
    } else {
        CGSize tempSize = [self P_sizeWithString:originalBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = originalBtn.SG_width;
                }
            } else {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
            }
            if (self.configure.showIndicator) {
                self.indicatorView.SG_centerX = originalBtn.SG_centerX;
            }
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_indicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /// 1、处理 SGIndicatorScrollStyleHalf 逻辑
    if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleHalf) {
        // 1、处理 SGIndicatorStyleFixed 样式
        if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    }
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        // 2、处理指示器下划线、遮盖样式
        if (progress >= 0.5) {
            CGSize tempSize = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont];
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                    }
                } else {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = tempIndicatorWidth;
                    }
                }
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                }
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGSize tempSize = [self P_sizeWithString:originalBtn.currentTitle font:self.configure.titleFont];
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= originalBtn.SG_width) {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = originalBtn.SG_width;
                    }
                } else {
                    if (self.configure.showIndicator) {
                        self.indicatorView.SG_width = tempIndicatorWidth;
                    }
                }
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                }
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }

    
    /// 2、处理 SGIndicatorScrollStyleEnd 逻辑
    // 1、处理 SGIndicatorStyleFixed 样式
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                }
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                }
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    // 2、处理指示器下划线、遮盖样式
    if (progress == 1.0) {
        CGSize tempSize = [self P_sizeWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = targetBtn.SG_width;
                }
            } else {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
            }
            if (self.configure.showIndicator) {
                self.indicatorView.SG_centerX = targetBtn.SG_centerX;
            }
            [self P_changeSelectedButton:targetBtn];
        }];

    } else {
        CGSize tempSize = [self P_sizeWithString:originalBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + tempSize.width;
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= originalBtn.SG_width) {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = originalBtn.SG_width;
                }
            } else {
                if (self.configure.showIndicator) {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
            }
            if (self.configure.showIndicator) {
                self.indicatorView.SG_centerX = originalBtn.SG_centerX;
            }
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - 颜色渐变方法抽取
- (void)P_isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 获取 targetProgress
    CGFloat targetProgress = progress;
    // 获取 originalProgress
    CGFloat originalProgress = 1 - targetProgress;
    
    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
    UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
    
    // 设置文字颜色渐变
    originalBtn.titleLabel.textColor = originalColor;
    targetBtn.titleLabel.textColor = targetColor;
}

#pragma mark - - - set
- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex {
    _resetSelectedIndex = resetSelectedIndex;
    [self P_btn_action:self.btnMArr[resetSelectedIndex]];
}

#pragma mark - - - 颜色设置的计算
/// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self P_getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}
/// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self P_getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)P_getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end
