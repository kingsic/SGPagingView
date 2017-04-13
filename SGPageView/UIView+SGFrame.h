//
//  UIView+SGFrame.h
//  UIView+SGFrame
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//
//  拓展 UIView 的 frame 属性
//  在分类中声明@property，只会生成方法的声明，不会生成方法的实现和带有_线成员变量

#import <UIKit/UIKit.h>

@interface UIView (SGFrame)
@property (nonatomic, assign) CGFloat SG_x;
@property (nonatomic, assign) CGFloat SG_y;
@property (nonatomic, assign) CGFloat SG_width;
@property (nonatomic, assign) CGFloat SG_height;
@property (nonatomic, assign) CGFloat SG_centerX;
@property (nonatomic, assign) CGFloat SG_centerY;
@property (nonatomic, assign) CGPoint SG_origin;
@property (nonatomic, assign) CGSize SG_size;

/** 从 XIB 中加载视图 */
+ (instancetype)SG_loadViewFromXib;

@end
