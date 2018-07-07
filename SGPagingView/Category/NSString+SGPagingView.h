//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  NSString+SGPagingView.h
//  SGPagingViewExample
//
//  Created by kingsic on 2018/7/7.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (SGPagingView)
/**
 *  根据 UIFont 计算字符串尺寸
 *
 *  @param font     字符串字号
 *  @return CGSize
 */
- (CGSize)SG_sizeWithFont:(UIFont *)font;

@end
