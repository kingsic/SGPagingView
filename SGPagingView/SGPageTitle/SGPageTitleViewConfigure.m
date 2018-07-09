//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
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
    _needBounces = YES;
    _showBottomSeparator = YES;
    _showIndicator = YES;
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

- (CGFloat)titleTextZoomAdditionalPointSize {
    if (_titleTextZoomAdditionalPointSize <= 3) {
        _titleTextZoomAdditionalPointSize = 3;
    } else if (_titleTextZoomAdditionalPointSize >= 10) {
        _titleTextZoomAdditionalPointSize = 10;
    }
    return _titleTextZoomAdditionalPointSize;
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

#pragma mark - - 按钮之间分割线属性
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

- (CGFloat)badgeSize {
    if (!_badgeSize) {
        _badgeSize = 7.0f;
    }
    return _badgeSize;
}

- (CGPoint)badgeOff {
    if (!_badgeOff.x && !_badgeOff.y) {
        _badgeOff = CGPointMake(0, 0);
    }
    return _badgeOff;
}

@end
