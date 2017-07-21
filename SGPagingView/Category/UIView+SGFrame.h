//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView.git
//
//  UIView+SGFrame.h
//  UIView+SGFrame
//
//  Created by kingsic on 15/7/13.
//  Copyright © 2015年 kingsic. All rights reserved.
//

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

/// 从 XIB 中加载视图
+ (instancetype)SG_loadViewFromXib;

@end
