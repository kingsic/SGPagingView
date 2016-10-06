//
//  SGSegmentedControl.m
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

#import "SGSegmentedControl.h"
#import "SGImageButton.h"
#import "UIView+SGExtension.h"

#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define indicatorViewColorDefualt [UIColor redColor]

@interface SGSegmentedControl ()
/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 带有图片的标题按钮 */
@property (nonatomic, strong) SGImageButton *image_title_btn;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *titleBtn_mArr;
/** 普通状态下的图片数组 */
@property (nonatomic, strong) NSArray *nomal_image_Arr;
/** 选中状态下的图片数组 */
@property (nonatomic, strong) NSArray *selected_image_Arr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 背景指示器下面的小indicatorView */
@property (nonatomic, strong) UIView *bgIndicatorView;

/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;

@end

@implementation SGSegmentedControl

/** 按钮之间的间距(滚动时按钮之间的间距) */
static CGFloat const btn_Margin = 15;
/** 按钮字体的大小(字号) */
static CGFloat const btn_fondOfSize = 17;
/** 指示器的高度 */
static CGFloat const indicatorViewHeight = 2;
/** 点击按钮时, 指示器的动画移动时间 */
static CGFloat const indicatorViewTimeOfAnimation = 0.4;

- (NSMutableArray *)titleBtn_mArr {
    if (!_titleBtn_mArr) {
        _titleBtn_mArr = [NSMutableArray array];
    }
    return _titleBtn_mArr;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate_SG = delegate;
        self.segmentedControlType = segmentedControlType;
        self.title_Arr = titleArr;
        
        [self setupTitleArr];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType titleArr:(NSArray *)titleArr {
    return [[self alloc] initWithFrame:frame delegate:delegate segmentedControlType:segmentedControlType titleArr:titleArr];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate_SG = delegate;
        self.nomal_image_Arr = nomalImageArr;
        self.selected_image_Arr = selectedImageArr;
        self.segmentedControlType = segmentedControlType;
        self.title_Arr = titleArr;
        
        [self setupImageAndTitleArr];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SGSegmentedControlDelegate>)delegate segmentedControlType:(SGSegmentedControlType)segmentedControlType nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr titleArr:(NSArray *)titleArr {
    return [[self alloc] initWithFrame:frame delegate:delegate segmentedControlType:segmentedControlType nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr titleArr:titleArr];
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

/** 创建标题按钮 */
- (void)setupTitleArr {
    
    if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
        
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_H = self.frame.size.height;
        
        for (NSUInteger i = 0; i < _title_Arr.count; i++) {
            /** 创建滚动时的标题Label */
            self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            _title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
            _title_btn.tag = i;
            
            // 计算内容的Size
            CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];
            
            // 计算内容的宽度
            CGFloat button_W = 2 * btn_Margin + buttonSize.width;
            _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
            
            [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            
            // 计算每个label的X值
            button_X = button_X + button_W;
            
            // 点击事件
            [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_title_btn];
            }
            
            // 存入所有的title_btn
            [self.titleBtn_mArr addObject:_title_btn];
            [self addSubview:_title_btn];
        }
        
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
        self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
        
        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        
        // 添加指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = indicatorViewColorDefualt;
        _indicatorView.SG_height = indicatorViewHeight;
        _indicatorView.SG_y = self.frame.size.height - 2 * indicatorViewHeight;
        [self addSubview:_indicatorView];
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = buttonSize.width;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        
    } else {
        
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = self.frame.size.width;
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_W = scrollViewWidth / _title_Arr.count;
        CGFloat button_H = self.frame.size.height;
        
        for (NSInteger i = 0; i < _title_Arr.count; i++) {
            // 创建静止时的标题Label
            self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            _title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
            _title_btn.tag = i;
            
            // 计算title_btn的x值
            button_X = i * button_W;
            _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
            
            [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            
            // 点击事件
            [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_title_btn];
            }
            
            // 存入所有的title_btn
            [self.titleBtn_mArr addObject:_title_btn];
            [self addSubview:_title_btn];
        }
        
        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        
        // 添加指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = indicatorViewColorDefualt;
        _indicatorView.SG_height = indicatorViewHeight;
        _indicatorView.SG_y = self.frame.size.height - 2 * indicatorViewHeight;
        [self addSubview:_indicatorView];
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = buttonSize.width;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
    }
}

/** 创建带有图片的标题按钮 */
- (void)setupImageAndTitleArr {
    
    if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
        
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_H = self.frame.size.height;

        for (NSUInteger i = 0; i < _title_Arr.count; i++) {
            /** 创建滚动时的标题Label */
            self.image_title_btn = [[SGImageButton alloc] init];

            _image_title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
            _image_title_btn.tag = i;

            // 计算内容的Size
            CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];

            // 计算内容的宽度
            CGFloat button_W = 2 * btn_Margin + buttonSize.width;
            _image_title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);

            [_image_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
            [_image_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [_image_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            [_image_title_btn setImage:[UIImage imageNamed:_nomal_image_Arr[i]] forState:(UIControlStateNormal)];
            [_image_title_btn setImage:[UIImage imageNamed:_selected_image_Arr[i]] forState:(UIControlStateSelected)];
            
            // 计算每个label的X值
            button_X = button_X + button_W;

            // 点击事件
            [_image_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];

            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_image_title_btn];
            }

            // 存入所有的title_btn
            [self.titleBtn_mArr addObject:_image_title_btn];
            [self addSubview:_image_title_btn];
        }

        // 计算scrollView的宽度
        CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
        self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);

        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;

        // 添加指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = indicatorViewColorDefualt;
        _indicatorView.SG_height = indicatorViewHeight;
        _indicatorView.SG_y = self.frame.size.height - indicatorViewHeight;
        [self addSubview:_indicatorView];


        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = buttonSize.width;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        
    } else {
        
        // 计算scrollView的宽度
        CGFloat scrollViewWidth = self.frame.size.width;
        CGFloat button_X = 0;
        CGFloat button_Y = 0;
        CGFloat button_W = scrollViewWidth / _title_Arr.count;
        CGFloat button_H = self.frame.size.height;

        for (NSInteger i = 0; i < _title_Arr.count; i++) {
            // 创建静止时的标题Label
            self.image_title_btn = [[SGImageButton alloc] init];

            _image_title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
            _image_title_btn.tag = i;

            // 计算title_btn的x值
            button_X = i * button_W;
            _image_title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);

            [_image_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
            [_image_title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [_image_title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            [_image_title_btn setImage:[UIImage imageNamed:_nomal_image_Arr[i]] forState:(UIControlStateNormal)];
            [_image_title_btn setImage:[UIImage imageNamed:_selected_image_Arr[i]] forState:(UIControlStateSelected)];
            
            // 点击事件
            [_image_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];

            // 默认选中第0个button
            if (i == 0) {
                [self buttonAction:_image_title_btn];
            }

            // 存入所有的title_btn
            [self.titleBtn_mArr addObject:_image_title_btn];
            [self addSubview:_image_title_btn];
        }

        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;

        // 添加指示器
        self.indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = indicatorViewColorDefualt;
        _indicatorView.SG_height = indicatorViewHeight;
        _indicatorView.SG_y = self.frame.size.height - indicatorViewHeight;
        [self addSubview:_indicatorView];
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = buttonSize.width;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
    }
}

#pragma mark - - - 按钮的点击事件
- (void)buttonAction:(UIButton *)sender {
    
    // 1、让选中的标题居中
    if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
        [self titleBtnSelectededCenter:sender];
    }
    
    // 2、代理方法实现
    NSInteger index = sender.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGSegmentedControl:didSelectBtnAtIndex:)]) {
        [self.delegate_SG SGSegmentedControl:self didSelectBtnAtIndex:index];
    }
    
    // 3、改变指示器位置
    [self titleBtnSelected:sender];
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)titleBtnSelected:(UIButton *)button {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(indicatorViewTimeOfAnimation * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_temp_btn == nil) {
            button.selected = YES;
            _temp_btn = button;
        }else if (_temp_btn != nil && _temp_btn == button){
            button.selected = YES;
        }else if (_temp_btn != button && _temp_btn != nil){
            _temp_btn.selected = NO;
            button.selected = YES; _temp_btn = button;
        }
    });

    if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
        // 改变指示器位置
        if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeCenter) {
            [UIView animateWithDuration:0.20 animations:^{
                self.indicatorView.SG_width = button.SG_width - btn_Margin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
        } else if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeBankground) {
            [UIView animateWithDuration:0.20 animations:^{
                self.indicatorView.SG_width = button.SG_width;
                self.bgIndicatorView.SG_width = button.SG_width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
        } else {
            [UIView animateWithDuration:0.20 animations:^{
                self.indicatorView.SG_width = button.SG_width - 2 * btn_Margin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
        }
        
        // 2、让选中的标题居中
        [self titleBtnSelectededCenter:button];
        
    } else {
        
        // 改变指示器位置
        if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeCenter) {
            // 改变指示器位置
            [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
                // 计算内容的Size
                CGSize buttonSize = [self sizeWithText:button.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorViewHeight)];
                self.indicatorView.SG_width = buttonSize.width + btn_Margin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
            
        } else if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeBankground){
            
            // 改变指示器位置
            [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
                // 计算内容的Size
                //                CGSize buttonSize = [self sizeWithText:sender.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorViewHeight)];
                self.indicatorView.SG_width = self.SG_width / _title_Arr.count;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
            
        } else {
            
            // 改变指示器位置
            [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
                // 计算内容的Size
                CGSize buttonSize = [self sizeWithText:button.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorViewHeight)];
                self.indicatorView.SG_width = buttonSize.width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }];
        }
    }
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)titleBtnSelectedWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.titleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self titleBtnSelected:selectedBtn];
}

/** 给外界scrollViewDidScroll方法提供文字渐显效果 */
- (void)titleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 左边label角标
    NSInteger leftIndex = curPage;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 获取左边的label
    UIButton *left_btn = self.titleBtn_mArr[leftIndex];
    
    // 获取右边的label
    UIButton *right_btn;
    if (rightIndex < self.titleBtn_mArr.count - 1) {
        right_btn = self.titleBtn_mArr[rightIndex];
    }
    
    // 计算下右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    
    if (self.titleFondGradualChange == YES) {
        // 左边缩放
        left_btn.transform = CGAffineTransformMakeScale(leftScale * 0.1 + 1, leftScale * 0.1 + 1);
        // 右边缩放
        right_btn.transform = CGAffineTransformMakeScale(rightScale * 0.1 + 1, rightScale * 0.1 + 1);
    }

    if (self.titleColorGradualChange == YES) {
        // 设置文字颜色渐变
        left_btn.titleLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
        right_btn.titleLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    }
}

/** 滚动标题选中居中 */
- (void)titleBtnSelectededCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - SG_screenWidth * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - SG_screenWidth;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma mark - - - setter 方法设置属性
- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    for (UIView *subViews in self.titleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    for (UIView *subViews in self.titleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicatorView.backgroundColor = indicatorColor;
}

- (void)setShowsBottomScrollIndicator:(BOOL)showsBottomScrollIndicator {
    if (self.showsBottomScrollIndicator == YES) {
        
    } else {
        [self.indicatorView removeFromSuperview];
    }
}

- (void)setSegmentedControlIndicatorType:(SGSegmentedControlIndicatorType)segmentedControlIndicatorType {
    _segmentedControlIndicatorType = segmentedControlIndicatorType;
    if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeBottom) {
        
    } else if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeCenter){

        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        _indicatorView.SG_width = buttonSize.width + btn_Margin;
        _indicatorView.SG_centerX = firstButton.SG_centerX;
        
        CGFloat indicatorViewHeight = 25;
        self.indicatorView.SG_height = indicatorViewHeight;
        self.indicatorView.SG_y = (self.frame.size.height - indicatorViewHeight) * 0.5;
    
        self.indicatorView.alpha = 0.3;
        self.indicatorView.layer.cornerRadius = 7;
        self.indicatorView.layer.masksToBounds = YES;
        
    } else if (self.segmentedControlIndicatorType == SGSegmentedControlIndicatorTypeBankground){
        
        // 取出第一个子控件
        UIButton *firstButton = self.subviews.firstObject;
        
        // 指示器默认在第一个选中位置
        // 计算TitleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
            _indicatorView.SG_x = firstButton.SG_x;
            _indicatorView.SG_width = buttonSize.width + 2 * btn_Margin;
        } else {
            _indicatorView.SG_x = 0;
            _indicatorView.SG_width = self.SG_width / _title_Arr.count;
        }
        
        CGFloat indicatorViewHeight = self.frame.size.height;
        self.indicatorView.SG_height = indicatorViewHeight;
        self.indicatorView.SG_y = 0;
        
        self.indicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        // 指示器底部的小指示器
        self.bgIndicatorView = [[UIView alloc] init];
        _bgIndicatorView.backgroundColor = [UIColor redColor];
        
        if (self.segmentedControlType == SGSegmentedControlTypeScroll) {
            _bgIndicatorView.SG_x = firstButton.SG_x;
            _bgIndicatorView.SG_width = buttonSize.width + 2 * btn_Margin;
        } else {
            _bgIndicatorView.SG_x = _indicatorView.SG_x;
            _bgIndicatorView.SG_width = self.SG_width / _title_Arr.count;
        }
        
        CGFloat bgIndicatorViewHeight = 3;
        _bgIndicatorView.SG_height = bgIndicatorViewHeight;
        _bgIndicatorView.SG_y = _indicatorView.SG_height - bgIndicatorViewHeight;
        [self.indicatorView addSubview:_bgIndicatorView];
    }
}


@end
    
