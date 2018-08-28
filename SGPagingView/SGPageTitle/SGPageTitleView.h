//
//  SGPageTitleView.h
//  SGPagingViewExample
//
//  Created by kingsic on 17/4/10.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGPageTitleViewConfigure, SGPageTitleView;

typedef enum : NSUInteger {
    /// 图片在左，文字在右
    SGImagePositionTypeDefault,
    /// 图片在右，文字在左
    SGImagePositionTypeRight,
    /// 图片在上，文字在下
    SGImagePositionTypeTop,
    /// 图片在下，文字在上
    SGImagePositionTypeBottom,
} SGImagePositionType;

@protocol SGPageTitleViewDelegate <NSObject>
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;
@end

@interface SGPageTitleView : UIView
/**
 *  对象方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 *  @param configure        SGPageTitleView 信息配置
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure;
/**
 *  类方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 *  @param configure        SGPageTitleView 信息配置
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure;

/** 给外界提供的方法，获取 PageContent 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/** 选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标）*/
@property (nonatomic, assign) NSInteger resetSelectedIndex;

/** 根据标题下标值添加 badge */
- (void)addBadgeForIndex:(NSInteger)index;
/** 根据标题下标值移除 badge */
- (void)removeBadgeForIndex:(NSInteger)index;
/** 根据标题下标值重置标题文字 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index;
/** 根据标题下标值设置标题的 attributedTitle 属性 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index;
/**
 *  设置标题图片及位置样式
 *
 *  @param images       默认图片数组
 *  @param selectedImages       选中时图片数组
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 */
- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectedImages imagePositionType:(SGImagePositionType)imagePositionType spacing:(CGFloat)spacing;

@end
