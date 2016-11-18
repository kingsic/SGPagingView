//
//  SGSegmentedControlDefault.h
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGSegmentedControl.git - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import <UIKit/UIKit.h>
@class SGSegmentedControlDefault;

typedef enum : NSUInteger {
    segmentedControlIndicatorTypeBottom, // 指示器底部样式
    segmentedControlIndicatorTypeCenter, // 指示器中心背景样式
    segmentedControlIndicatorTypeBankground, // 指示器背景样式
    segmentedControlIndicatorTypeBottomWithImage, // 带有图片的指示器样式
} segmentedControlIndicatorType;  // SGSegmentedControlIndicatorType 指示器样式，默认为底部样式

@protocol SGSegmentedControlDefaultDelegate <NSObject>
// delegate 方法
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

@property (nonatomic, weak) id<SGSegmentedControlDefaultDelegate> delegate_SG;
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

/** 对象方法创建，带有图片的 SGSegmentedControlDefault */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
/** 类方法创建，带有图片的 SGSegmentedControlDefault */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

/** 标题文字渐显效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleColorGradualChange;
/** 标题文字缩放效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleFondGradualChange;
/** 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） */
- (void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView;



@end


