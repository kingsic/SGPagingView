//
//  SGImageButton.m
//  SGSegmentedControlExample
//
//  Created by Sorgle on 2016/10/6.
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

#import "SGImageButton.h"
#import "UIView+SGExtension.h"

@implementation SGImageButton

- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    self.titleLabel.SG_height = self.SG_height - self.titleLabel.SG_y - self.imageView.SG_y;
    self.titleLabel.SG_width = self.SG_width;
}


@end
