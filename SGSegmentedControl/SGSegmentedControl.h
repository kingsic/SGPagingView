//
//  SGSegmentedControl.h
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGSegmentedControl.git - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
// SGSegmentedControl 使用说明：
// SGSegmentedControlStatic 类：顶部标题按钮的个数比较少(或已经明确个数)且标题按钮的总个数宽度并没有超出屏幕尺寸
// SGSegmentedControlDefault 类：顶部标题按钮的个数比较多且标题按钮的总个数宽度已经超出屏幕尺寸
// SGSegmentedControlDefault 这个类的指示器样式多一点而 SGSegmentedControlStatic 这个类里面并没有做处理(请根据自己的项目需求，参考 SGSegmentedControlDefault 这个类进行相应的修改)；
// 注意：指示器样式三是使用 UIImageView 创建的，指示器颜色属性(indicatorColor)对此并不起作用

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SGSegmentedControlStatic.h"
#import "SGSegmentedControlDefault.h"
#import "SGSegmentedControlBottomView.h"

