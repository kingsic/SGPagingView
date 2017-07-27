//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView.git
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
/// SGPageContentScrollViewDelegate 的代理方法
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
@end

@interface SGPageContentScrollView : UIView
/**
 *  对象方法创建 SGPageContentScrollView
 *
 *  @param frame     frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 SGPageContentScrollView
 *
 *  @param frame     frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/// SGPageContentScrollViewDelegate
@property (nonatomic, weak) id<SGPageContentScrollViewDelegate> delegatePageContentScrollView;
/// 是否需要滚动 SGPageContentScrollView，默认为 YES；设为 NO 时，不用设置 SGPageContentScrollView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/// 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标, 必须实现
- (void)setPageCententScrollViewCurrentIndex:(NSInteger)currentIndex;

@end

