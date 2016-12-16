//
//  SGSegmentedControlStatic.m
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

#import "SGSegmentedControlStatic.h"
#import "SGSegmentedControlHelper.h"
#import "SGImageButton_Horizontal.h"
#import "SGImageButton_Vertical.h"

@interface SGSegmentedControlStatic ()
/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 标题按钮 */
@property (nonatomic, strong) SGImageButton_Horizontal *imageTitle_btnH;
/** 标题按钮 */
@property (nonatomic, strong) SGImageButton_Vertical *imageTitle_btnV;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 指示器是否宽度是否填充整个button宽度 */
@property (nonatomic, assign) BOOL isFull;
/** 标记SGImageButton_Horizontal */
@property (nonatomic, assign) BOOL isButtonH;
/** 标记SGImageButton_Vertical */
@property (nonatomic, assign) BOOL isButtonV;
/** 普通状态下的图片数组 */
@property (nonatomic, strong) NSArray *nomal_image_Arr;
/** 选中状态下的图片数组 */
@property (nonatomic, strong) NSArray *selected_image_Arr;
/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;

/** SGSegmentedControlStatic背景颜色 */
@property (nonatomic, strong) UIColor *segmentControlColor;
/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;
/** 标题样式(默样式只显示标题) */
@property (nonatomic, assign) SGSegmentedControlStaticType segmentedControlStaticType;

@end

@implementation SGSegmentedControlStatic

- (NSMutableArray *)storageAlltitleBtn_mArr {
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle indicatorIsFull:(BOOL)isFull{
    
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        
        self.delegate_SG = delegate;
        self.title_Arr = childVcTitle;
        self.isFull = isFull;
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle indicatorIsFull:(BOOL)isFull {
    return [[self alloc] initWithFrame:frame delegate:delegate childVcTitle:childVcTitle  indicatorIsFull:isFull];
}

/** 设置标题样式的方法 */
- (void)SG_setUpSegmentedControlType:(void(^)(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray **nomalImageArr, NSArray **selectedImageArr))segmentedControlTypeBlock {
    NSArray *nomalImage_arr;
    NSArray *selectedImage_arr;
    if (segmentedControlTypeBlock) {
        segmentedControlTypeBlock(&_segmentedControlStaticType, &nomalImage_arr, &selectedImage_arr);
        self.nomal_image_Arr = nomalImage_arr;
        self.selected_image_Arr = selectedImage_arr;
    }
    
    if (_segmentedControlStaticType == SGSegmentedControlStaticTypeHorizontal) {
        [self imageTitle_btnH];
    } else if (_segmentedControlStaticType == SGSegmentedControlStaticTypeVertical) {
        [self imageTitle_btnV];
    } else {
        [self title_btn];
    }
}

- (void)SG_setUpSegmentedControlStyle:(void(^)(UIColor **segmentedControlColor, UIColor **titleColor, UIColor **selectedTitleColor, UIColor **indicatorColor, BOOL *isShowIndicor))segmentedControlStyleBlock {
    UIColor *segmentedControl_color;
    UIColor *title_color;
    UIColor *selectedTitle_color;
    UIColor *indicator_color;
    BOOL isShowIndicor;
    isShowIndicor = YES;

    if (segmentedControlStyleBlock) {
        segmentedControlStyleBlock(&segmentedControl_color, &title_color, &selectedTitle_color, &indicator_color, &isShowIndicor);
        self.segmentControlColor = segmentedControl_color;
        self.titleColorStateNormal = title_color;
        self.titleColorStateSelected = selectedTitle_color;
        self.indicatorColor = indicator_color;
        self.showsBottomScrollIndicator = isShowIndicor;
    }
    if (_segmentControlColor == nil) {
        self.segmentControlColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    }
    if (_titleColorStateNormal == nil) {
        self.titleColorStateNormal = SG_titleColor;
    }
    if (_titleColorStateSelected == nil) {
        self.titleColorStateSelected = SG_selectedTitleColor;
    }
    if (_indicatorColor == nil) {
        self.indicatorColor = SG_indicatorColor;
    }
    
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - - - 普通标题样式
- (UIButton *)title_btn {
    if (!_title_btn) {
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = self.frame.size.width;
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_W = scrollViewWidth / _title_Arr.count;
        CGFloat button_H = self.frame.size.height;
        
        for (NSInteger i = 0; i < _title_Arr.count; i++) {
            // 创建静止时的标题button
            self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            _title_btn.titleLabel.font = [UIFont systemFontOfSize:SG_defaultTitleFont];
            _title_btn.tag = i;
            
            // 计算title_btn的x值
            button_X = i * button_W;
            _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
            
            [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:SG_titleColor forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:SG_selectedTitleColor forState:(UIControlStateSelected)];
            // 点击事件
            [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_title_btn];
            }
            
            // 存入所有的title_btn
            [self.storageAlltitleBtn_mArr addObject:_title_btn];
            [self addSubview:_title_btn];
        }
        
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = SG_indicatorColor;
        _indicatorView.SG_height = SG_indicatorHeight;
        _indicatorView.SG_y = self.frame.size.height - SG_indicatorHeight;
        
        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        // 计算Titlebutton内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        if (self.isFull) {
            _indicatorView.SG_width = button_W;
        } else {
            _indicatorView.SG_width = buttonSize.width;
        }
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        [self addSubview:_indicatorView];
    }
    return _title_btn;
}
#pragma mark - - - 带有图片的标题样式且图片位于标题左边
- (SGImageButton_Horizontal *)imageTitle_btnH {
    if (!_imageTitle_btnH) {
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = self.frame.size.width;
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_W = scrollViewWidth / _title_Arr.count;
        CGFloat button_H = self.frame.size.height;
        
        for (NSInteger i = 0; i < _title_Arr.count; i++) {
            // 创建静止时的标题button
            self.imageTitle_btnH = [[SGImageButton_Horizontal alloc] init];
            _isButtonH = YES;
            _imageTitle_btnH.tag = i;
            
            _imageTitle_btnH.title = _title_Arr[i];
            _imageTitle_btnH.nomal_image = _nomal_image_Arr[i];
            _imageTitle_btnH.selected_image = _selected_image_Arr[i];
            
            // 计算title_btn的x值
            button_X = i * button_W;
            _imageTitle_btnH.frame = CGRectMake(button_X, button_Y, button_W, button_H);
            
            // 点击事件
            [_imageTitle_btnH addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_imageTitle_btnH];
            }
            
            // 存入所有的title_btn
            [self.storageAlltitleBtn_mArr addObject:_imageTitle_btnH];
            [self addSubview:_imageTitle_btnH];
        }

        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = SG_indicatorColor;
        _indicatorView.SG_height = SG_indicatorHeight;
        _indicatorView.SG_y = self.frame.size.height - SG_indicatorHeight;
        
        // 取出第一个子控件
        SGImageButton_Horizontal *firstButton = self.subviews.firstObject;

        // 计算Titlebutton内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.title font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        if (self.isFull) {
            _indicatorView.SG_width = button_W;
        } else {
            _indicatorView.SG_width = buttonSize.width + SG_defaultHorizontalImageWidth + 5;

            NSLog(@"SG_width - %.f", _indicatorView.SG_width);
        }
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        [self addSubview:_indicatorView];
    }
    return _imageTitle_btnH;
}

#pragma mark - - - 带有图片的标题样式且图片位于标题下面
- (SGImageButton_Vertical *)imageTitle_btnV {
    if (!_imageTitle_btnV) {
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = self.frame.size.width;
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_W = scrollViewWidth / _title_Arr.count;
        CGFloat button_H = self.frame.size.height;
        
        for (NSInteger i = 0; i < _title_Arr.count; i++) {
            // 创建静止时的标题button
            self.imageTitle_btnV = [[SGImageButton_Vertical alloc] init];
            _isButtonV = YES;
            _imageTitle_btnV.tag = i;
            
            _imageTitle_btnV.title = _title_Arr[i];
            _imageTitle_btnV.nomal_image = _nomal_image_Arr[i];
            _imageTitle_btnV.selected_image = _selected_image_Arr[i];
            
            // 计算title_btn的x值
            button_X = i * button_W;
            _imageTitle_btnV.frame = CGRectMake(button_X, button_Y, button_W, button_H);
            
            // 点击事件
            [_imageTitle_btnV addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_imageTitle_btnV];
            }
            
            // 存入所有的title_btn
            [self.storageAlltitleBtn_mArr addObject:_imageTitle_btnV];
            [self addSubview:_imageTitle_btnV];
        }
        
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = SG_indicatorColor;
        _indicatorView.SG_height = SG_indicatorHeight;
        _indicatorView.SG_y = self.frame.size.height - SG_indicatorHeight;
        
        // 取出第一个子控件
        SGImageButton_Vertical *firstButton = self.subviews.firstObject;
        
        // 计算Titlebutton内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.title font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        if (self.isFull) {
            _indicatorView.SG_width = button_W;
        } else {
            _indicatorView.SG_width = buttonSize.width;
            
            NSLog(@"SG_width - %.f", _indicatorView.SG_width);
        }
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        [self addSubview:_indicatorView];
    }
    return _imageTitle_btnV;
}

#pragma mark - - - 按钮的点击事件
- (void)buttonAction:(UIButton *)sender {
    // 1、代理方法实现
    NSInteger index = sender.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGSegmentedControlStatic:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGSegmentedControlStatic:self didSelectTitleAtIndex:index];
    }
    
    // 2、改变选中的button的位置
    [self selectedBtnLocation:sender];
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)selectedBtnLocation:(UIButton *)button {
    
    // 1、选中的button
    if (_temp_btn == nil) {
        button.selected = YES;
        _temp_btn = button;
    }else if (_temp_btn != nil && _temp_btn == button){
        button.selected = YES;
    }else if (_temp_btn != button && _temp_btn != nil){
        _temp_btn.selected = NO;
        button.selected = YES; _temp_btn = button;
    }
    
    // 计算普通标题按钮的Size
    CGSize buttonSize = [self sizeWithText:button.titleLabel.text font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    // 计算SGImageButton_Horizontal按钮的Size
    SGImageButton_Horizontal *buttonH = (SGImageButton_Horizontal *)button;
    CGSize buttonHSize = [self sizeWithText:buttonH.title font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    
    // 计算SGImageButton_Horizontal按钮的Size
    SGImageButton_Horizontal *buttonV = (SGImageButton_Horizontal *)button;
    CGSize buttonVSize = [self sizeWithText:buttonV.title font:[UIFont systemFontOfSize:SG_defaultTitleFont] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    
    // 2、改变指示器的位置
    [UIView animateWithDuration:SG_indicatorAnimationTime animations:^{
        if (self.isFull) {
            self.indicatorView.SG_width = self.frame.size.width / _title_Arr.count;
        } else {
            if (_isButtonH) {
                self.indicatorView.SG_width = buttonHSize.width + SG_defaultHorizontalImageWidth + 5;
            } else if (_isButtonV) {
                self.indicatorView.SG_width = buttonVSize.width;
            } else {
                self.indicatorView.SG_width = buttonSize.width;
            }
        }
        self.indicatorView.SG_centerX = button.SG_centerX;
    }];
}

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}


#pragma mark - - - setter 方法设置属性
- (void)setSegmentControlColor:(UIColor *)segmentControlColor {
    _segmentControlColor = segmentControlColor;
    self.backgroundColor = segmentControlColor;
}

- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicatorView.backgroundColor = indicatorColor;
}

- (void)setShowsBottomScrollIndicator:(BOOL)showsBottomScrollIndicator {
    _showsBottomScrollIndicator = showsBottomScrollIndicator;
    if (showsBottomScrollIndicator == YES) {
        
    } else {
        [self.indicatorView removeFromSuperview];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (_isButtonH) {
        SGImageButton_Horizontal *selected_btn = self.storageAlltitleBtn_mArr[selectedIndex];
        [self buttonAction:selected_btn];
    } else if (_isButtonV) {
        SGImageButton_Vertical *selected_btn = self.storageAlltitleBtn_mArr[selectedIndex];
        [self buttonAction:selected_btn];
    } else {
        UIButton *selected_btn = self.storageAlltitleBtn_mArr[selectedIndex];
        [self buttonAction:selected_btn];
    }

}


@end


