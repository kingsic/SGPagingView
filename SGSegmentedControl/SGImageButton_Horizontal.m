//
//  SGImageButton_Horizontal.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/12/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGImageButton_Horizontal.h"
#import "UIView+SGExtension.h"
#import "SGSegmentedControlHelper.h"

@implementation SGImageButton_Horizontal

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:SG_defaultTitleFont];
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
#pragma mark - - - 这里的 imageView 给定的是固定值，项目中可根据自己的需求来设置大小或不设置打开以下注释代码，并注视掉上面三句代码
    self.imageView.SG_width = SG_defaultHorizontalImageWidth;
    self.imageView.SG_height = 20;
    self.imageView.SG_centerY = self.SG_centerY;
    
    //CGFloat margin = 4;
    //self.imageEdgeInsets = UIEdgeInsetsMake(0, - 0.5 * margin, 0, 0);
    //self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * margin, 0, 0);
    
    [self setTitle:_title forState:(UIControlStateNormal)];
    [self setImage:[UIImage imageNamed:_nomal_image] forState:(UIControlStateNormal)];
    [self setImage:[UIImage imageNamed:_selected_image] forState:(UIControlStateSelected)];
}


@end
