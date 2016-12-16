//
//  SGImageButton_Vertical.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/12/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGImageButton_Vertical.h"
#import "SGSegmentedControlHelper.h"

@implementation SGImageButton_Vertical

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        self.titleLabel.font = [UIFont systemFontOfSize:SG_defaultTitleFont];
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.SG_y = 5;
    self.imageView.SG_centerX = self.SG_width * 0.5;
    
    // 调整文字
    self.titleLabel.SG_x = 0;
    self.titleLabel.SG_y = self.imageView.SG_bottom + 5;
    self.titleLabel.SG_height = self.SG_height - self.titleLabel.SG_y - self.imageView.SG_y - 5;
    self.titleLabel.SG_width = self.SG_width;
    
    [self setTitle:_title forState:(UIControlStateNormal)];
    [self setImage:[UIImage imageNamed:_nomal_image] forState:(UIControlStateNormal)];
    [self setImage:[UIImage imageNamed:_selected_image] forState:(UIControlStateSelected)];
}


@end
