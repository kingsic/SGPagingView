//
//  SGSegmentedControlStatic.h
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
@class SGSegmentedControlStatic;

typedef enum : NSUInteger {
    SGSegmentedControlStaticTypeDefault,
    SGSegmentedControlStaticTypeHorizontal,
    SGSegmentedControlStaticTypeVertical,
} SGSegmentedControlStaticType;

@protocol SGSegmentedControlStaticDelegate <NSObject>
// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index;

@end

@interface SGSegmentedControlStatic : UIScrollView
/** 根据下标，选中对应的控制器 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<SGSegmentedControlStaticDelegate> delegate_SG;

/**
 *  对象方法创建 SGSegmentedControlStatic
 *
 *  frame       frame
 *  delegate      delegate
 *  childVcTitle      childVcTitle
 *  indicatorColor      指示器颜色, 默认红色
 *  isFull       YES，指示器的宽度等于按钮的宽度，NO，指示器的宽度等于文字的宽度
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle indicatorIsFull:(BOOL)isFull;
/** 类方法创建 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle indicatorIsFull:(BOOL)isFull;

#pragma mark - - - 设置标题样式的方法（必须实现）
- (void)SG_setUpSegmentedControlType:(void(^)(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray **nomalImageArr, NSArray **selectedImageArr))segmentedControlTypeBlock;

/**
 *  设置SGSegmentedControlStatic风格
 *
 *  segmentedControlColor       SGSegmentedControlStatic背景颜色设置
 *  titleColor      普通状态下标题颜色，默认黑色
 *  selectedTitleColor      选中标题时的颜色，默认红色
 *  indicatorColor      指示器颜色, 默认红色
 *  isShowIndicor       是否显示指示器，默认显示
 */
- (void)SG_setUpSegmentedControlStyle:(void(^)(UIColor **segmentedControlColor, UIColor **titleColor, UIColor **selectedTitleColor, UIColor **indicatorColor, BOOL *isShowIndicor))segmentedControlStyleBlock;

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

@end


