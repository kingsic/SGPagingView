//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageTitleViewConfigure.h
//  SGPagingViewExample
//
//  Created by kingsic on 2017/10/16.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// 下划线样式
    SGIndicatorStyleDefault,
    /// 遮盖样式
    SGIndicatorStyleCover,
    /// 固定样式
    SGIndicatorStyleFixed,
    /// 动态样式（仅在 SGIndicatorScrollStyleDefault 样式下支持）
    SGIndicatorStyleDynamic
} SGIndicatorStyle;

typedef enum : NSUInteger {
    /// 指示器位置跟随内容滚动而改变
    SGIndicatorScrollStyleDefault,
    /// 内容滚动一半时指示器位置改变
    SGIndicatorScrollStyleHalf,
    /// 内容滚动结束时指示器位置改变
    SGIndicatorScrollStyleEnd
} SGIndicatorScrollStyle;

@interface SGPageTitleViewConfigure : NSObject
/** 类方法创建 */
+ (instancetype)pageTitleViewConfigure;
/* SGPageTitleView 底部分割线颜色，默认为 lightGrayColor */
@property (nonatomic, strong) UIColor *bottomSeparatorColor;
/** 按钮之间的间距，默认为 20.0f */
@property (nonatomic, assign) CGFloat spacingBetweenButtons;
/** 标题文字字号大小，默认 15 号字体 */
@property (nonatomic, strong) UIFont *titleFont;
/** 普通状态下标题按钮文字的颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 选中状态下标题按钮文字的颜色，默认为红色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 指示器高度，默认为 2.0f */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 指示器颜色，默认为红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 指示器的额外宽度，介于按钮文字宽度与按钮宽度之间 */
@property (nonatomic, assign) CGFloat indicatorAdditionalWidth;
/** 指示器动画时间，默认为 0.1f，取值范围 0 ～ 0.3f */
@property (nonatomic, assign) CGFloat indicatorAnimationTime;
/** 指示器样式，默认为 SGIndicatorStyleDefault */
@property (nonatomic, assign) SGIndicatorStyle indicatorStyle;
/** 指示器遮盖样式下的圆角大小，默认为 0.1f */
@property (nonatomic, assign) CGFloat indicatorCornerRadius;
/** 指示器遮盖样式下的边框宽度，默认为 0.0f */
@property (nonatomic, assign) CGFloat indicatorBorderWidth;
/** 指示器遮盖样式下的边框颜色，默认为 clearColor */
@property (nonatomic, strong) UIColor *indicatorBorderColor;
/** 指示器固定样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) CGFloat indicatorFixedWidth;
/** 指示器动态样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) CGFloat indicatorDynamicWidth;
/** 指示器滚动位置改变样式，默认为 SGIndicatorScrollStyleDefault */
@property (nonatomic, assign) SGIndicatorScrollStyle indicatorScrollStyle;

@end
