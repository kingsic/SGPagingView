//
//  SGPageTitleView.m
//  SGPageViewExample
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGPageView.git - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGPageTitleView.h"
#import "SGPageViewHelper.h"
#import "UIView+SGFrame.h"
#import "SGHelperTool.h"

@interface SGPageTitleView ()
/** delegatePageTitleView */
@property (nonatomic, weak) id<SGPageTitleViewDelegate> delegatePageTitleView;
/// 保存外界传递过来的标题数组
@property (nonatomic, strong) NSArray *titleArr;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 指示器
@property (nonatomic, strong) UIView *indicatorView;
/// 存储标题按钮的数组
@property (nonatomic, strong) NSMutableArray *btnMArr;
/// tempBtn
@property (nonatomic, strong) UIButton *tempBtn;
/// 选中按钮的下标
@property (nonatomic, assign) NSInteger currentIndex;
/// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
/// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;

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

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
        self.delegatePageTitleView = delegate;
        self.titleArr = titleNames;
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames {
    return [[self alloc] initWithFrame:frame delegate:delegate titleNames:titleNames];
}

- (void)initialization {
    self.indicatorStyle = SGIndicatorTypeDefault;
    self.isTitleGradientEffect = YES;
    self.isIndicatorScroll = YES;
    self.isShowIndicator = YES;
    self.isNeedBounces = YES;
}

- (void)setupSubviews {
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    
    // 2、添加标题按钮
    [self setupTitleButtons];
    
    // 3、添加指示器
    [self setupIndicatorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 默认选中下标
    if (self.selectedIndex == 0) {
        self.selectedIndex = 0;
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnMArr {
    if (!_btnMArr) {
        _btnMArr = [NSMutableArray array];
    }
    return _btnMArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

/// 添加标题按钮
- (void)setupTitleButtons {
    // 计算所有按钮的文字宽度
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempWidth = [SGHelperTool SG_widthWithString:obj font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
        self.allBtnTextWidth += tempWidth;
    }];
    // 所有按钮文字宽度 ＋ 按钮之间的间隔
    self.allBtnWidth = SGPageTitleViewBtnMargin * (self.titleArr.count + 1) + self.allBtnTextWidth;
    
    if (self.allBtnWidth <= self.bounds.size.width) { /// SGPageTitleView 不可滚动
        CGFloat btnY = 0;
        CGFloat btnW = self.frame.size.width / self.titleArr.count;
        CGFloat btnH = self.frame.size.height - SGIndicatorHeight;
        for (NSInteger index = 0; index < self.titleArr.count; index++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            // 设置 frame
            CGFloat btnX = btnW * index;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.tag = index;
            btn.titleLabel.font = [UIFont systemFontOfSize:SGPageTitleViewTextFont];
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    } else { /// SGPageTitleView 可滚动
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnH = self.frame.size.height - SGIndicatorHeight;
        for (NSInteger index = 0; index < self.titleArr.count; index++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            // 设置 frame
            CGFloat btnW = [SGHelperTool SG_widthWithString:self.titleArr[index] font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]] + SGPageTitleViewBtnMargin;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btnX = btnX + btnW;
            btn.tag = index;
            btn.titleLabel.font = [UIFont systemFontOfSize:SGPageTitleViewTextFont];
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }
        
        CGFloat scrollViewWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    }
}

/// 添加指示器
- (void)setupIndicatorView {
    // 包装的底部分割线（可要可不要）
    UIView *bgView = [[UIView alloc] init];
    CGFloat bgViewX = 0;
    CGFloat bgViewY = self.SG_height - 0.5;
    CGFloat bgViewW = self.SG_width;
    CGFloat bgViewH = 0.5;
    bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgView];
    
    // 获取第一个按钮
    UIButton *firstBtn = self.btnMArr.firstObject;
    if (firstBtn == nil) {
        return;
    }
    
    // 添加指示器
    [self.scrollView addSubview:self.indicatorView];
    CGFloat indicatorViewX = firstBtn.frame.origin.x;
    CGFloat indicatorViewY = self.SG_height - SGIndicatorHeight;
    CGFloat indicatorViewW = firstBtn.SG_width;
    CGFloat indicatorViewH = SGIndicatorHeight;
    self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewW, indicatorViewH);
}

/// 标题按钮的点击事件
- (void)btnAction:(UIButton *)button {

    // 1、改变按钮的选择状态
    [self changeSelectedButton:button];
    
    // 0、记录选中按钮的下标
    self.currentIndex = button.tag;
    
    // 2、滚动标题选中居中
    [self selectedBtnCenter:button];
    
    // 3、指示器位置发生改变
    if (self.allBtnWidth <= self.bounds.size.width) { /// SGPageTitleView 不可滚动
        [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
            if (self.indicatorStyle == SGIndicatorTypeEqual) {
                self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:button.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
                self.indicatorView.SG_centerX = button.SG_centerX;
            } else {
                self.indicatorView.SG_width = button.SG_width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
        }];
    } else {
        [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
            if (self.indicatorStyle == SGIndicatorTypeEqual) {
                self.indicatorView.SG_width = button.SG_width - SGPageTitleViewBtnMargin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            } else {
                self.indicatorView.SG_width = button.SG_width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
        }];
    }

    // 4、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(SGPageTitleView:selectedIndex:)]) {
        [self.delegatePageTitleView SGPageTitleView:self selectedIndex:self.currentIndex];
    }
}

/// 改变按钮的选择状态
- (void)changeSelectedButton:(UIButton *)button {
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
}

/// 滚动标题选中居中
- (void)selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.frame.size.width;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/// 给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    // 1、取出 originalBtn／targetBtn
    UIButton *originalBtn = self.btnMArr[originalIndex];
    UIButton *targetBtn = self.btnMArr[targetIndex];

    // 2、改变按钮的选择状态
    if (progress >= 0.8) {
        [self changeSelectedButton:targetBtn];
    }
    
    // 3、 滚动标题选中居中
    [self selectedBtnCenter:targetBtn];
    
    // 4、处理指示器的逻辑
    if (self.allBtnWidth <= self.bounds.size.width) { /// SGPageTitleView 不可滚动
        if (self.isIndicatorScroll) {
            /// 计算 targetBtn／originalBtn 之间的距离
            CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]) - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]) - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            CGFloat totalOffsetX = targetBtnX - originalBtnX;
            /// 计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            /// 计算 targetBtn／originalBtn 宽度的差值
            CGFloat targetBtnDistance = (CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]));
            CGFloat originalBtnDistance = (CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]));
            CGFloat totalDistance = targetBtnDistance - originalBtnDistance;
            /// 计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            if (self.indicatorStyle == SGIndicatorTypeEqual) {
                offsetX = totalOffsetX * progress;
                distance = progress * (totalDistance - totalOffsetX);
                /// 计算 indicatorView 新的 frame
                CGRect temp = self.indicatorView.frame;
                temp.origin.x = originalBtnX + offsetX;
                temp.size.width = [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]] + distance;
                self.indicatorView.frame = temp;
            } else {
                // 3、处理指示器的逻辑
                CGFloat moveTotalX = targetBtn.SG_origin.x - originalBtn.SG_origin.x;
                CGFloat moveX = moveTotalX * progress;
                self.indicatorView.SG_centerX = originalBtn.SG_centerX + moveX;
            }

        } else {
            if (progress > 0.5) {
                [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
                    if (self.indicatorStyle == SGIndicatorTypeEqual) {
                        self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    } else {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                }];
            }
        }

    } else { /// SGPageTitleView 可滚动
        if (self.isIndicatorScroll) {
            /// 计算 targetBtn／originalBtn 之间的距离
            CGFloat totalOffsetX = targetBtn.SG_origin.x - originalBtn.SG_origin.x;
            /// 计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            /// 计算 targetBtn／originalBtn 宽度的差值
            CGFloat totalDistance = CGRectGetMaxX(targetBtn.frame) - CGRectGetMaxX(originalBtn.frame);
            /// 计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            if (self.indicatorStyle == SGIndicatorTypeEqual) {
                offsetX = totalOffsetX * progress + 0.5 * SGPageTitleViewBtnMargin;
                distance = progress * (totalDistance - totalOffsetX) - SGPageTitleViewBtnMargin;
            } else {
                offsetX = totalOffsetX * progress;
                distance = progress * (totalDistance - totalOffsetX);
            }
            
            /// 计算 indicatorView 新的 frame
            CGRect temp = self.indicatorView.frame;
            temp.origin.x = originalBtn.SG_origin.x + offsetX;
            temp.size.width = originalBtn.SG_width + distance;
            self.indicatorView.frame = temp;
        } else {
            if (progress > 0.5) {
                [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
                    if (self.indicatorStyle == SGIndicatorTypeEqual) {
                        self.indicatorView.SG_width = targetBtn.SG_width - SGPageTitleViewBtnMargin;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    } else {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                }];
            }
        }
    }
    
    // 5、颜色的渐变(复杂)
    if (self.isTitleGradientEffect) {
        if (self.titleColorStateSelected) {
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
            
        } else {
            
            originalBtn.titleLabel.textColor = [UIColor colorWithRed:1 - progress green:0 blue:0 alpha:1];
            targetBtn.titleLabel.textColor = [UIColor colorWithRed:progress green:0 blue:0 alpha:1];
        }
    }
}

#pragma mark - - - set
/// titleColorStateNormal
- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }];
    
    [self setupStartColor:titleColorStateNormal];
}

/// titleColorStateSelected
- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }];
    
    [self setupEndColor:titleColorStateSelected];
}

/// indicatorColor
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

/// selectedIndex
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex) {
        [self btnAction:self.btnMArr[self.selectedIndex]];
    } else { // 默认选择选中第一个按钮
        [self btnAction:self.btnMArr[self.selectedIndex]];
    }
}

/// indicatorStyle
- (void)setIndicatorStyle:(SGIndicatorType)indicatorStyle {
    _indicatorStyle = indicatorStyle;
    
    if (indicatorStyle == SGIndicatorTypeEqual) {
        if (self.selectedIndex) {
            UIButton *selectedBtn = self.btnMArr[self.selectedIndex];
            self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:self.titleArr[self.selectedIndex] font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            self.indicatorView.SG_centerX = selectedBtn.SG_centerX;
        } else {
            UIButton *selectedBtn = self.btnMArr.firstObject;
            self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:self.titleArr[self.selectedIndex] font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            self.indicatorView.SG_centerX = selectedBtn.SG_centerX;
        }
    }
}

/// isTitleGradientEffect
- (void)setIsTitleGradientEffect:(BOOL)isTitleGradientEffect {
    _isTitleGradientEffect = isTitleGradientEffect;
}

/// isIndicatorScroll
- (void)setIsIndicatorScroll:(BOOL)isIndicatorScroll {
    _isIndicatorScroll = isIndicatorScroll;
}

/// isShowIndicator
- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator == NO) {
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

/// isNeedBounces
- (void)setIsNeedBounces:(BOOL)isNeedBounces {
    _isNeedBounces = isNeedBounces;
    if (isNeedBounces == NO) {
        self.scrollView.bounces = NO;
    }
}

#pragma mark - - - 颜色设置的计算
/// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}

/// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
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
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
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

