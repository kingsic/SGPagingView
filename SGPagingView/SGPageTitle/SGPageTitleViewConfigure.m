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

- (CGFloat)titleTextScaling {
    if (_titleTextScaling >= 0.3) {
        _titleTextScaling = 0.3;
    } else {
        _titleTextScaling = 0.1;
    }
    return _titleTextScaling;
}

- (CGFloat)spacingBetweenButtons {
    if (_spacingBetweenButtons <= 0) {
        _spacingBetweenButtons = 20;
    }
    return _spacingBetweenButtons;
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


@end
