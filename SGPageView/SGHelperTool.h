//
//  SGHelperTool.h
//  SGPageViewExample
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGHelperTool : NSObject
/** 计算字符串宽度 */
+ (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font;

@end
