//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageTitleView.h
//  SGPagingViewExample
//
//  Created by kingsic on 17/4/10.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGPageTitleViewConfigure, SGPageTitleView;

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

/** 给外界提供的方法，获取 SGPageContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/** 选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标）*/
@property (nonatomic, assign) NSInteger resetSelectedIndex;

/** 根据标题下标重置标题文字 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index;
/** 根据标题下标设置标题的 attributedTitle 属性 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index;

@end
