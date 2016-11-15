//
//  SGSegmentedControlStatic.h
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
@class SGSegmentedControlStatic;

@protocol SGSegmentedControlStaticDelegate <NSObject>
// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index;

@end

@interface SGSegmentedControlStatic : UIScrollView
/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;

@property (nonatomic, weak) id<SGSegmentedControlStaticDelegate> delegate_SG;
/** 对象方法创建 SGSegmentedControlStatic */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;
/** 类方法创建 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle;

/** 对象方法创建，带有图片的 SGSegmentedControlStatic */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
/** 类方法创建，带有图片的 SGSegmentedControlStatic */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

@end


