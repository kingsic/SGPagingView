//
//  SGSegmentedControl.h
//  SGSegmentedControlExample
//
//  Created by Sorgle on 2016/10/6.
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
@class SGSegmentedControl;

typedef enum : NSUInteger {
    SGSegmentedControlTypeScroll, // 滚动风格
    SGSegmentedControlTypeStatic, // 静止风格
} SGSegmentedControlType;  // 默认为滚动风格

typedef enum : NSUInteger {
    SGSegmentedControlIndicatorTypeBottom, // 指示器底部样式
    SGSegmentedControlIndicatorTypeCenter, // 指示器背景样式
    SGSegmentedControlIndicatorTypeBankground, // 指示器背景样式
} SGSegmentedControlIndicatorType;  // SGSegmentedControlIndicatorType 指示器样式， 默认为底部样式

@protocol SGSegmentedControlDelegate <NSObject>
// delegate 方法
- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index;

@end


@interface SGSegmentedControl : UIScrollView

/** 对象方法创建 SGSegmentedControl */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr;
/** 类方法创建 SGSegmentedControl */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr;

/** 对象方法创建，带有图片的SGSegmentedControl */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr;
/** 类方法创建，带有图片的SGSegmentedControl */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr;

/** 默认为滚动风格 */
@property (nonatomic, assign) SGSegmentedControlType segmentedControlType;

/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;
/** 指示器样式(默认为底部样式) */
@property (nonatomic, assign) SGSegmentedControlIndicatorType segmentedControlIndicatorType;

@property (nonatomic, weak) id<SGSegmentedControlDelegate> delegate_SG;


/** 标题选中颜色改变以及指示器位置变化 */
- (void)titleBtnSelectedWithScrollView:(UIScrollView *)scrollView;

/** 标题文字渐变效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效*/
@property (nonatomic, assign) BOOL titleColorGradualChange;
/** 标题文字缩放效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效*/
@property (nonatomic, assign) BOOL titleFondGradualChange;
/** 给外界scrollViewDidScroll方法提供文字渐显效果 */
- (void)titleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView;


@end


