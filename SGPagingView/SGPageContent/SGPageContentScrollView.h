//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageContentScrollView.h
//  SGPagingViewExample
//
//  Created by kingsic on 2017/7/21.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGPageContentScrollView;

@protocol SGPageContentScrollViewDelegate <NSObject>
@optional
/**
 *  联动 SGPageTitleView 的方法
 *
 *  @param pageContentScrollView      SGPageContentScrollView
 *  @param progress                   SGPageContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  给 SGPageContentScrollView 所在控制器提供的方法（根据偏移量来处理返回手势的问题）
 *
 *  @param pageContentScrollView     SGPageContentScrollView
 *  @param offsetX                   SGPageContentScrollView 内部视图的偏移量
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView offsetX:(CGFloat)offsetX;
@end

@interface SGPageContentScrollView : UIView
/**
 *  对象方法创建 SGPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 SGPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** SGPageContentScrollViewDelegate */
@property (nonatomic, weak) id<SGPageContentScrollViewDelegate> delegatePageContentScrollView;
/** 是否需要滚动 SGPageContentScrollView 默认为 YES；设为 NO 时，不必设置 SGPageContentScrollView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标 */
- (void)setPageCententScrollViewCurrentIndex:(NSInteger)currentIndex;

@end

