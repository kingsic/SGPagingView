//
//  SGImageButton_Horizontal.h
//  SGSegmentedControlExample
//
//  Created by apple on 16/12/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  带有图片的按钮（图片位置位于标题左边）

#import <UIKit/UIKit.h>

@interface SGImageButton_Horizontal : UIButton
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nomal_image;
@property (nonatomic, copy) NSString *selected_image;

@end
