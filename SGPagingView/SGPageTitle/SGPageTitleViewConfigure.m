//
//  SGPageTitleViewConfigure.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/10/16.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "SGPageTitleViewConfigure.h"

@implementation SGPageTitleViewConfigure

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _showBottomSeparator = YES;
    _showIndicator = YES;
    _equivalence = YES;
    _bounces = YES;
}

+ (instancetype)pageTitleViewConfigure {
    return [[self alloc] init];
}

#pragma mark - - SGPageTitleView 属性
- (UIColor *)bottomSeparatorColor {
    if (!_bottomSeparatorColor) {
        _bottomSeparatorColor = [UIColor lightGrayColor];
    }
    return _bottomSeparatorColor;
}
- (CGFloat)contentInsetSpacing {
    if (_contentInsetSpacing < 0) {
        _contentInsetSpacing = 0;
    }
    return _contentInsetSpacing;
}

#pragma mark - - 标题属性
- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:15];
    }
    return _titleFont;
}

- (UIFont *)titleSelectedFont {
    if (!_titleSelectedFont) {
        _titleSelectedFont = [UIFont systemFontOfSize:15];
    }
    return _titleSelectedFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (UIColor *)titleSelectedColor {
    if (!_titleSelectedColor) {
        _titleSelectedColor = [UIColor redColor];
    }
    return _titleSelectedColor;
}

- (CGFloat)titleTextZoomRatio {
    if (_titleTextZoomRatio <= 0.0) {
        _titleTextZoomRatio = 0.0;
    } else if (_titleTextZoomRatio >= 1.0){
        _titleTextZoomRatio = 1.0;
    }
    return _titleTextZoomRatio * 0.5;
}

- (CGFloat)titleAdditionalWidth {
    if (_titleAdditionalWidth <= 0) {
        _titleAdditionalWidth = 20;
    }
    return _titleAdditionalWidth;
}

#pragma mark - - 指示器属性
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor redColor];
    }
    return _indicatorColor;
}

- (CGFloat)indicatorHeight {
    if (_indicatorHeight <= 0) {
        _indicatorHeight = 2.0f;
    }
    return _indicatorHeight;
}

- (CGFloat)indicatorAnimationTime {
    if (_indicatorAnimationTime <= 0) {
        _indicatorAnimationTime = 0.1;
    } else if (_indicatorAnimationTime > 0.3) {
        _indicatorAnimationTime = 0.3;
    }
    return _indicatorAnimationTime;
}

- (CGFloat)indicatorCornerRadius {
    if (_indicatorCornerRadius <= 0) {
        _indicatorCornerRadius = 0;
    }
    return _indicatorCornerRadius;
}

- (CGFloat)indicatorToBottomDistance {
    if (_indicatorToBottomDistance <= 0) {
        _indicatorToBottomDistance = 0;
    }
    return _indicatorToBottomDistance;
}

- (CGFloat)indicatorBorderWidth {
    if (_indicatorBorderWidth <= 0) {
        _indicatorBorderWidth = 0;
    }
    return _indicatorBorderWidth;
}

- (UIColor *)indicatorBorderColor {
    if (!_indicatorBorderColor) {
        _indicatorBorderColor = [UIColor clearColor];
    }
    return _indicatorBorderColor;
}

- (CGFloat)indicatorAdditionalWidth {
    if (_indicatorAdditionalWidth <= 0) {
        _indicatorAdditionalWidth = 0;
    }
    return _indicatorAdditionalWidth;
}

- (CGFloat)indicatorFixedWidth {
    if (_indicatorFixedWidth <= 0) {
        _indicatorFixedWidth = 20;
    }
    return _indicatorFixedWidth;
}

- (CGFloat)indicatorDynamicWidth {
    if (_indicatorDynamicWidth <= 0) {
        _indicatorDynamicWidth = 20;
    }
    return _indicatorDynamicWidth;
}

#pragma mark - - 标题间分割线属性
- (UIColor *)verticalSeparatorColor {
    if (!_verticalSeparatorColor) {
        _verticalSeparatorColor = [UIColor redColor];
    }
    return _verticalSeparatorColor;
}

- (CGFloat)verticalSeparatorReduceHeight {
    if (_verticalSeparatorReduceHeight <= 0) {
        _verticalSeparatorReduceHeight = 0;
    }
    return _verticalSeparatorReduceHeight;
}

#pragma mark - - badge 相关属性
- (UIColor *)badgeColor {
    if (!_badgeColor) {
        _badgeColor = [UIColor redColor];
    }
    return _badgeColor;
}

- (CGFloat)badgeHeight {
    if (!_badgeHeight) {
        _badgeHeight = 7.0f;
    }
    return _badgeHeight;
}

- (UIColor *)badgeTextColor {
    if (!_badgeTextColor) {
        _badgeTextColor = [UIColor whiteColor];
    }
    return _badgeTextColor;
}
- (UIFont *)badgeTextFont {
    if (!_badgeTextFont) {
        _badgeTextFont = [UIFont systemFontOfSize:10];
    }
    return _badgeTextFont;
}

- (CGFloat)badgeAdditionalWidth {
    if (_badgeAdditionalWidth <= 0) {
        _badgeAdditionalWidth = 10.0f;
    }
    return _badgeAdditionalWidth;
}

- (CGFloat)badgeCornerRadius {
    if (!_badgeCornerRadius) {
        _badgeCornerRadius = 5.0f;
    }
    return _badgeCornerRadius;
}

@end
