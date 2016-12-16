//
//  SGSegmentedControlDefault.h
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGSegmentedControl.git - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import <UIKit/UIKit.h>
@class SGSegmentedControlDefault;

typedef enum : NSUInteger {
    segmentedControlIndicatorTypeDefault, // 指示器底部样式
    segmentedControlIndicatorTypeCover, // 指示器中心背景样式
    segmentedControlIndicatorTypeImageView, // 带有图片的指示器样式
} segmentedControlIndicatorType;  // SGSegmentedControlIndicatorType 指示器样式，默认为底部样式

// Block 方法
typedef void(^SGSegmentedControlDefaultBlock)(SGSegmentedControlDefault *segmentedControlDefault, NSInteger selectedIndex);

// delegate 方法
@protocol SGSegmentedControlDefaultDelegate <NSObject>

- (void)SGSegmentedControlDefault:(SGSegmentedControlDefault *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index;

@end

@interface SGSegmentedControlDefault : UIScrollView
/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;
/** 指示器样式(默认为底部样式) */
@property (nonatomic, assign) segmentedControlIndicatorType segmentedControlIndicatorType;

/** Block */
@property (nonatomic, copy) SGSegmentedControlDefaultBlock block_SG;
/** Delegate */
@property (nonatomic, weak) id<SGSegmentedControlDefaultDelegate> delegate_SG;

#pragma mark - - - delegate 创建 SGSegmentedControlDefault
/**
 *  对象方法创建 SGSegmentedControlDefault
 *
 *  @param frame    frame
 *  @param delegate     delegate
 *  @param childVcTitle     子控制器标题数组
 *  @param isScaleText     是否开启文字缩放功能；默认不开启
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;
/**
 *  类方法创建 SGSegmentedControlDefault
 *
 *  @param frame    frame
 *  @param delegate     delegate
 *  @param childVcTitle     子控制器标题数组
 *  @param isScaleText     是否开启文字缩放功能；默认不开启
 */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;

#pragma mark - - - Block 创建 SGSegmentedControlDefault
/** 对象方法创建 (Block 创建SGSegmentedControlDefault) */
- (instancetype)initWithFrame:(CGRect)frame childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText didSelectedTitleIndex:(SGSegmentedControlDefaultBlock)didSelectedTitleIndex;
/** 类方法创建 (Block 创建SGSegmentedControlDefault) */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText didSelectedTitleIndex:(SGSegmentedControlDefaultBlock)didSelectedTitleIndex;

#pragma mark - - - 给外界scrollViewDidEndDecelerating:scrollView提供的方法
/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

/** 标题文字渐显效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleColorGradualChange;
/** 标题文字缩放效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleFondGradualChange;
/** 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） */
- (void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView;



@end


