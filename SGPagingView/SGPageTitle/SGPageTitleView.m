//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGPagingView
//
//  SGPageTitleView.m
//  SGPagingViewExample
//
//  Created by kingsic on 17/4/10.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "SGPageTitleView.h"
#import "UIView+SGPagingView.h"
#import "SGPageTitleViewConfigure.h"
#import <Masonry/Masonry.h>

#define SGPageTitleViewHeight self.frame.size.height

#pragma mark - - - SGPageTitleButton
@interface SGPageTitleButton : UIButton
@property (nonatomic, assign) CGFloat width;
@end
@implementation SGPageTitleButton
- (void)setHighlighted:(BOOL)highlighted {
    
}
@end

#pragma mark - - - TitleAttribute
@interface TitleAttribute : NSObject
@property (nonatomic, strong) NSAttributedString* stateNormal;
@property (nonatomic, strong) NSAttributedString* stateSelected;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@end
@implementation TitleAttribute
- (id)initWithNormalState:(NSAttributedString*)stateNormal stateSelected:(NSAttributedString*)stateSelected height:(CGFloat)height width:(CGFloat)width{
    self = [self init];
    self.stateNormal = stateNormal;
    self.stateSelected = stateSelected;
    self.width = width;
    self.height = height;
    return self;
}
@end

#pragma mark - - - SGPageTitleView
@interface SGPageTitleView ()
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 指示器
@property (nonatomic, strong) UIView *indicatorView;
/// 底部分割线
@property (nonatomic, strong) UIView *bottomSeparator;
/// 存储标题按钮的数组
@property (nonatomic, strong) NSMutableArray *btnMArr;
/// 存储标题NSAttributedString的数组
@property (nonatomic, strong) NSMutableArray<TitleAttribute *> *titleAttributes;
/// tempBtn
@property (nonatomic, strong) UIButton *tempBtn;
/// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
/// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;
/// 标记按钮下标
@property (nonatomic, assign) NSInteger signBtnIndex;

/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;
    
/// check whether init setup done
@property (nonatomic, assign) BOOL initSetup;
    
@end

@implementation SGPageTitleView

#pragma mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizesSubviews = YES;
        _initSetup = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.77];
        if (delegate == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的代理方法必须设置" userInfo:nil];
        }
        self.delegatePageTitleView = delegate;
        if (titleNames == nil || titleNames.count == 0) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的标题数组必须设置, 且不能为空数组" userInfo:nil];
        }
        self.titleArr = titleNames;
        if (configure == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的配置属性必须设置" userInfo:nil];
        }
        self.configure = configure;
        
        _initSetup = NO;
        
        [self initialization];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(SGPageTitleViewConfigure *)configure {
    return [[self alloc] initWithFrame:frame delegate:delegate titleNames:titleNames configure:configure];
}

#pragma mark - instance methods
- (void)initialization {
    // TODO: need to fix those options
    _isTitleGradientEffect = YES;
    _isOpenTitleTextZoom = NO;
    _isShowIndicator = YES;
    _isNeedBounces = YES;

    _selectedIndex = 0;
    _titleTextScaling = 0.1;
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@(SGPageTitleViewHeight));
    }];
    [self.scrollView layoutIfNeeded];
    // 2、添加标题按钮
    [self setupTitleButtons];
    // 3、添加指示器
    [self.scrollView insertSubview:self.indicatorView atIndex:0];
    // 4、添加底部分割线
    if (_isShowBottomSeparator == YES) {
        [self addSubview:self.bottomSeparator];
        [self.bottomSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.5));
            make.leading.trailing.bottom.equalTo(self.scrollView);
        }];
    }
}

#pragma mark - lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_initSetup) {
        // check compulsory variables are valid
        if (self.configure == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的配置属性必须设置" userInfo:nil];
        }else if (self.delegatePageTitleView == nil) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的代理方法必须设置" userInfo:nil];
        }else if (self.titleArr == nil || self.titleArr.count == 0) {
            @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 的标题数组必须设置, 且不能为空数组" userInfo:nil];
        }
        
        // when view is ready, add subviews
        [self setupSubviews];
        
        // 选中按钮下标初始值
        UIButton *lastBtn = self.btnMArr.lastObject;
        if (lastBtn.tag >= _selectedIndex && _selectedIndex >= 0) {
            [self P_btn_action:self.btnMArr[_selectedIndex]];
        } else {
            return;
        }
        
        _initSetup = YES;
    }
}

#pragma mark - lazy loading
    
- (BOOL)isShowBottomSeparator {
    if(!_isShowBottomSeparator) {
        _isShowBottomSeparator = YES;
    }
    return _isShowBottomSeparator;
}
    
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnMArr {
    if (!_btnMArr) {
        _btnMArr = [[NSMutableArray alloc] init];
    }
    return _btnMArr;
}

- (NSMutableArray<TitleAttribute *> *)titleAttributes {
    if (!_titleAttributes) {
        _titleAttributes = [[NSMutableArray<TitleAttribute *> alloc] init];
    }
    return _titleAttributes;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        if (self.configure.indicatorStyle == SGIndicatorStyleCover) {
            // 拿到button最大的高度
            // TODO: 创造一个titleattribute collection, set property maxHeight while insertion
            CGFloat maxHeight = 0;
            for (TitleAttribute* titleAttr in self.titleAttributes) {
                if (titleAttr.height > maxHeight) {
                    maxHeight = titleAttr.height;
                }
            }
            
            CGFloat tempIndicatorViewH = maxHeight;
            
            if (self.configure.indicatorHeight > self.SG_height) {
                _indicatorView.SG_y = 0;
                _indicatorView.SG_height = self.SG_height;
            } else if (self.configure.indicatorHeight < tempIndicatorViewH) {
                _indicatorView.SG_y = 0.5 * (self.SG_height - tempIndicatorViewH);
                _indicatorView.SG_height = tempIndicatorViewH;
            } else {
                _indicatorView.SG_y = 0.5 * (self.SG_height - self.configure.indicatorHeight);
                _indicatorView.SG_height = self.configure.indicatorHeight;
            }
            
            // 圆角处理
            if (self.configure.indicatorCornerRadius > 0.5 * _indicatorView.SG_height) {
                _indicatorView.layer.cornerRadius = 0.5 * _indicatorView.SG_height;
            } else {
                _indicatorView.layer.cornerRadius = self.configure.indicatorCornerRadius;
            }
            
            // 边框宽度及边框颜色
            _indicatorView.layer.borderWidth = self.configure.indicatorBorderWidth;
            _indicatorView.layer.borderColor = self.configure.indicatorBorderColor.CGColor;
            
        } else {
            // 拿到button最大的高度
            // TODO: 创造一个titleattribute collection, set property maxHeight while insertion
            CGFloat maxHeight = 0;
            if (!self.configure.elasticHeight) {
                maxHeight = self.SG_height;
            }else {
                for (TitleAttribute* titleAttr in self.titleAttributes) {
                    if (titleAttr.height > maxHeight) {
                        maxHeight = titleAttr.height;
                    }
                }
            }
            
            CGFloat indicatorViewH = self.configure.indicatorHeight;
            _indicatorView.SG_height = indicatorViewH;
            _indicatorView.SG_y = maxHeight - indicatorViewH - self.configure.indicatorToBottomDistance;
            
            // 圆角处理
            if (self.configure.indicatorCornerRadius > 0.5 * _indicatorView.SG_height) {
                _indicatorView.layer.cornerRadius = 0.5 * _indicatorView.SG_height;
            } else {
                _indicatorView.layer.cornerRadius = self.configure.indicatorCornerRadius;
            }
        }
        _indicatorView.backgroundColor = self.configure.indicatorColor;
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] init];
        _bottomSeparator.backgroundColor = self.configure.bottomSeparatorColor;
    }
    return _bottomSeparator;
}

#pragma mark - - - TextKit计算字符串宽度
- (CGFloat)SG_widthWithNSAttributedString:(NSAttributedString *)attributedText {
    NSTextStorage*textStorage = [NSTextStorage new];
    [textStorage appendAttributedString:attributedText];
    NSDictionary*attrs = [textStorage attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, textStorage.length)];
    return [textStorage.string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
#pragma mark - - - TextKit计算字符串高度
- (CGFloat)SG_heightWithNSAttributedString:(NSAttributedString *)attributedText width:(CGFloat)width {
    NSTextStorage*textStorage = [NSTextStorage new];
    [textStorage appendAttributedString:attributedText];
    NSTextContainer *textContainer = [[NSTextContainer alloc]
                                       initWithSize: CGSizeMake(width, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textContainer setLineFragmentPadding: 2.0];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}

#pragma mark - - - 处理标题NSAttributedString
- (void)processTitleArray {
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.paragraphSpacing = 2.0;
        NSDictionary *titleAttrSetting = @{
                                           NSFontAttributeName : self.configure.titleFont,
                                           NSForegroundColorAttributeName : self.configure.titleColor,
                                           NSParagraphStyleAttributeName:paragraphStyle,
                                           };
        NSAttributedString *titleAttrString = [[NSAttributedString alloc] initWithString:obj attributes:titleAttrSetting];
        NSDictionary *titleSelectedAttrSetting = @{
                                                   NSFontAttributeName : self.configure.titleSelectedFont,
                                                   NSForegroundColorAttributeName : self.configure.titleSelectedColor,
                                                   NSParagraphStyleAttributeName:paragraphStyle,
                                                   };
        NSAttributedString *selectedAttrString = [[NSAttributedString alloc] initWithString:obj attributes:titleSelectedAttrSetting];
        
        CGFloat width = 0;
        CGFloat height = 0;
        
        CGFloat widthNormal = [self SG_widthWithNSAttributedString:titleAttrString];
        CGFloat widthSelected = [self SG_widthWithNSAttributedString:selectedAttrString];
        
        CGFloat heightNormal = [self SG_heightWithNSAttributedString:titleAttrString width:widthNormal];
        CGFloat heightSelected = [self SG_heightWithNSAttributedString:selectedAttrString width:widthSelected];
        
        width = widthNormal > widthSelected ? widthNormal: widthSelected;
        height = heightNormal > heightSelected ? heightNormal: heightSelected;
        
        TitleAttribute* titleAttr = [[TitleAttribute alloc] initWithNormalState:titleAttrString stateSelected:selectedAttrString height:height width:width];
        
        [self.titleAttributes addObject:titleAttr];
    }];
}

#pragma mark - - - 添加标题按钮
- (void)setupTitleButtons {
    // 处理title数据
    [self processTitleArray];
    
    // 计算所有按钮的文字宽度
    // 拿到button最大的高度
    CGFloat maxHeight = 0;
    if (self.configure.elasticHeight) {
        for (TitleAttribute* titleAttr in self.titleAttributes) {
            CGFloat tempWidth = titleAttr.width;
            self.allBtnTextWidth += tempWidth;
            
            if (titleAttr.height > maxHeight) {
                maxHeight = titleAttr.height;
            }
        }
    }else {
        for (TitleAttribute* titleAttr in self.titleAttributes) {
            CGFloat tempWidth = titleAttr.width;
            self.allBtnTextWidth += tempWidth;
        }
        maxHeight = SGPageTitleViewHeight;
    }
    
    // 所有按钮文字宽度 ＋ 按钮之间的间隔
    self.allBtnWidth = self.configure.spacingBetweenButtons * (self.titleArr.count + 1) + self.allBtnTextWidth;
    self.allBtnWidth = ceilf(self.allBtnWidth);
    
    if (self.configure.elasticHeight) {
        // update storyboard constraints
        NSLayoutConstraint *titleViewheightConstraint;
        
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                titleViewheightConstraint = constraint;
                break;
            }
        }
        
        if (titleViewheightConstraint != nil) {
            titleViewheightConstraint.constant = maxHeight;
            // TODO: add padding option top/bottom
            self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, maxHeight);
        }else {
            // update height of title base on attributed largest height
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, maxHeight);
            // TODO: add padding option top/bottom
            self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, maxHeight);
        }
    }
    
    NSInteger titleCount = self.titleAttributes.count;
    if (self.allBtnWidth <= self.scrollView.frame.size.width) { // SGPageTitleView 静止样式, 总按钮宽度小于screen width
        CGFloat btnY = 0;
        CGFloat btnW = 0;
        if (self.configure.titleAlignment == SGPageTitleAlignmentJustified) {
            // this place divided width equality
            btnW = self.scrollView.frame.size.width / self.titleArr.count;
        }else {
            // base on largest width set title view width
            CGFloat maxWidth = 0;
            for (TitleAttribute* titleAttr in self.titleAttributes) {
                if (titleAttr.width > maxWidth) {
                    maxWidth = titleAttr.width;
                }
            }
            btnW = maxWidth;
        }
    
        CGFloat totalBtnWidthWithInterSpace = btnW*titleCount + _configure.spacingBetweenButtons*(titleCount - 1);
    
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == SGIndicatorStyleDefault) {
            btnH = maxHeight - self.configure.indicatorHeight;
        } else {
            btnH = maxHeight;
        }
        
        for (NSInteger index = 0; index < titleCount; index++) {
            SGPageTitleButton *btn = [[SGPageTitleButton alloc] init];
            btn.width = btnW;
            
            TitleAttribute* titleAttr = self.titleAttributes[index];
            
            btn.tag = index;
            
            // multiple line display support
            if (_configure.multipleLineDisplay == YES) {
                btn.titleLabel.numberOfLines = 0;
            }else {
                btn.titleLabel.numberOfLines = 1;
            }
            
            [btn setAttributedTitle:titleAttr.stateNormal forState:(UIControlStateNormal)];
            [btn setAttributedTitle:titleAttr.stateSelected forState:(UIControlStateSelected)];
            
            [btn addTarget:self action:@selector(P_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
            
            // add Masonry autolayout for btn
            if (index == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(btnH));
                    make.width.equalTo(@(btnW));
                    make.top.equalTo(@(btnY));
                    if (self.configure.titleAlignment == SGPageTitleAlignmentJustified) {
                        make.leading.equalTo(self.scrollView);
                    }else {
                        make.centerX.equalTo(self.scrollView).offset(-totalBtnWidthWithInterSpace/2 + btnW/2);
                    }
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(btnH));
                    make.width.equalTo(@(btnW));
                    make.top.equalTo(@(btnY));
                    if (self.configure.titleAlignment == SGPageTitleAlignmentJustified) {
                        make.leading.equalTo([self.scrollView subviews][index - 1].mas_trailing);
                    }else {
                        make.leading.equalTo([self.scrollView subviews][index - 1].mas_trailing).offset(self.configure.spacingBetweenButtons);
                    }
                }];
            }
        }
        
        [self setupStartColor:self.configure.titleColor];
        [self setupEndColor:self.configure.titleSelectedColor];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, SGPageTitleViewHeight);
        
    } else { // SGPageTitleView 滚动样式
        CGFloat btnY = 0;
        CGFloat btnH = 0;

        CGFloat totalBtnWidthWithInterSpace = 0;
        for (TitleAttribute* titleAttr in self.titleAttributes) {
            totalBtnWidthWithInterSpace += titleAttr.width;
        }
        totalBtnWidthWithInterSpace += _configure.spacingBetweenButtons*(titleCount - 1);
        totalBtnWidthWithInterSpace += 2*_configure.titleViewPadding.width;

        for (NSInteger index = 0; index < titleCount; index++) {
            SGPageTitleButton *btn = [[SGPageTitleButton alloc] init];
            TitleAttribute* titleAttr = self.titleAttributes[index];

            CGFloat btnW = titleAttr.width;
            btn.width = btnW;

            if (self.configure.indicatorStyle == SGIndicatorStyleDefault) {
                btnH = maxHeight - self.configure.indicatorHeight;
            } else {
                btnH = maxHeight;
            }

            // multiple line display support
            if (_configure.multipleLineDisplay == YES) {
                btn.titleLabel.numberOfLines = 0;
            }else {
                btn.titleLabel.numberOfLines = 1;
            }

            btn.tag = index;

            [btn setAttributedTitle:titleAttr.stateNormal forState:(UIControlStateNormal)];
            [btn setAttributedTitle:titleAttr.stateSelected forState:(UIControlStateSelected)];

            [btn addTarget:self action:@selector(P_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];

            // add Masonry autolayout for btn
            if (index == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(btnH));
                    make.width.equalTo(@(btnW));
                    make.top.equalTo(@(btnY));
                    make.leading.equalTo(self.scrollView).offset(self.configure.titleViewPadding.width);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(btnH));
                    make.width.equalTo(@(btnW));
                    make.top.equalTo(@(btnY));
                    make.leading.equalTo([self.scrollView subviews][index - 1].mas_trailing).offset(self.configure.spacingBetweenButtons);
                }];
            }
        }

        [self setupStartColor:self.configure.titleColor];
        [self setupEndColor:self.configure.titleSelectedColor];
        self.scrollView.contentSize = CGSizeMake(totalBtnWidthWithInterSpace, maxHeight);
    }
}

#pragma mark - - - 标题按钮的点击事件
- (void)P_btn_action:(SGPageTitleButton *)button {
    // 1、改变按钮的选择状态
    [self P_changeSelectedButton:button];
    // 2、滚动标题选中按钮居中
    if (self.allBtnWidth > self.scrollView.frame.size.width) {
        [self P_selectedBtnCenter:button];
    }
    // 3、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
        [self.delegatePageTitleView pageTitleView:self selectedIndex:button.tag];
    }
    // 4、标记按钮下标
    self.signBtnIndex = button.tag;
}

#pragma mark - - - 改变按钮的选择状态
- (void)P_changeSelectedButton:(SGPageTitleButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
        CGFloat indicatorWidth = _configure.indicatorFixedWidth;
        // get first button, and calculate offset
        SGPageTitleButton *firstBtn = _btnMArr[0];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstBtn.mas_bottom);
            make.width.equalTo(@(indicatorWidth));
            make.height.equalTo(@(self.configure.indicatorHeight));
            make.leading.equalTo(firstBtn).offset([self offsetToButton:button] + (button.width - indicatorWidth)/2);
        }];
    } else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
    } else if (self.tempBtn != button && self.tempBtn != nil){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        CGFloat indicatorWidth = _configure.indicatorFixedWidth;
        SGPageTitleButton *firstBtn = _btnMArr[0];
        [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(firstBtn).offset([self offsetToButton:button] + (button.width - indicatorWidth)/2);
        }];
    }
    
    if (self.configure.titleSelectedFont == [UIFont systemFontOfSize:15]) {
        // 标题文字缩放属性(开启 titleSelectedFont 属性将不起作用)
        if (self.isOpenTitleTextZoom) {
            [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.transform = CGAffineTransformMakeScale(1, 1);
            }];
            button.transform = CGAffineTransformMakeScale(1 + self.titleTextScaling, 1 + self.titleTextScaling);
        }
    }

    // 此处作用：避免滚动内容视图时 手指不离开屏幕的前提下点击按钮后 再次滚动内容视图时按钮文字颜色由于文字渐变效果导致未选中按钮文字的不标准化处理
    if (self.isTitleGradientEffect == YES) {
        NSDictionary *titleAttrSetting = @{
                                           NSForegroundColorAttributeName : self.configure.titleColor
                                           };
        NSDictionary *titleSelectedAttrSetting = @{
                                                   NSForegroundColorAttributeName : self.configure.titleSelectedColor
                                                   };
        
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            NSMutableAttributedString* btnAttr = [btn.titleLabel.attributedText mutableCopy];
            [btnAttr addAttributes:titleAttrSetting range:NSMakeRange(0, btnAttr.length)];
        }];
        NSMutableAttributedString* buttonAttr = [button.titleLabel.attributedText mutableCopy];
        [buttonAttr addAttributes:titleSelectedAttrSetting range:NSMakeRange(0, buttonAttr.length)];
    }
}

#pragma mark - - - 滚动标题选中按钮居中
- (void)P_selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.scrollView.frame.size.width * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - - - 给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    // 1、取出 originalBtn／targetBtn
    SGPageTitleButton *originalBtn = self.btnMArr[originalIndex];
    SGPageTitleButton *targetBtn = self.btnMArr[targetIndex];
    self.signBtnIndex = targetBtn.tag;
    
    // 2、处理指示器的逻辑
    if (self.allBtnWidth <= self.scrollView.frame.size.width) { /// SGPageTitleView 不可滚动
        if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleDefault) {
            [self P_smallIndicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_smallIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }

    } else { /// SGPageTitleView 可滚动
        [self P_selectedBtnCenter:targetBtn];
        if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleDefault) {
            [self P_indicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
    }
    // 4、颜色的渐变(复杂)
    if (self.isTitleGradientEffect) {
        [self P_isTitleGradientEffectWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
    }
    
    // 5 、标题文字缩放属性(开启文字选中字号属性将不起作用)
    if (self.configure.titleSelectedFont == [UIFont systemFontOfSize:15]) {
        if (self.isOpenTitleTextZoom) {
            // 左边缩放
            originalBtn.transform = CGAffineTransformMakeScale((1 - progress) * self.titleTextScaling + 1, (1 - progress) * self.titleTextScaling + 1);
            // 右边缩放
            targetBtn.transform = CGAffineTransformMakeScale(progress * self.titleTextScaling + 1, progress * self.titleTextScaling + 1);
        }
    }
}
/**
 *  根据下标重置标题文字
 *
 *  @param index 标题所对应的下标
 *  @param title 新标题名
 */
- (void)resetTitleWithIndex:(NSInteger)index newTitle:(NSString *)title {
    if (index < self.btnMArr.count) {
        UIButton *button = (UIButton *)self.btnMArr[index];
        [button setTitle:title forState:UIControlStateNormal];
        if (self.signBtnIndex == index) {
            if (self.configure.indicatorStyle == SGIndicatorStyleDefault || self.configure.indicatorStyle == SGIndicatorStyleCover) {
                CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[button titleLabel] attributedText]];
                
                if (tempIndicatorWidth > button.SG_width) {
                    tempIndicatorWidth = button.SG_width;
                }
                self.indicatorView.SG_width = tempIndicatorWidth;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
        }
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_smallIndicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(SGPageTitleButton *)originalBtn targetBtn:(SGPageTitleButton *)targetBtn {
    // 1、改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == SGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        // 按钮之间的距离
        CGFloat distance = self.SG_width / self.titleArr.count;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            if (progress <= 0.5) {
                self.indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.SG_x = targetBtnIndicatorX + 2 * (progress - 1) * distance;
                self.indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        } else {
            if (progress <= 0.5) {
                CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.SG_x = originalBtnIndicatorX - 2 * progress * distance;
                self.indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (distance - self.configure.indicatorDynamicWidth);
                self.indicatorView.SG_x = targetBtnIndicatorX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.SG_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        }
        
    } else if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.SG_width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        self.indicatorView.SG_x = originalBtnIndicatorX + progress * totalOffsetX;
        
    } else {
        /// 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = 0.0;
        CGFloat indicatorWidth = _configure.indicatorFixedWidth;
        
        // because progress 1 update constraints will update by other place
        if (progress != 1) {
            offsetX = (([self offsetToButton:targetBtn] + (targetBtn.width - indicatorWidth)/2) - ([self offsetToButton:originalBtn] + (originalBtn.width - indicatorWidth)/2)) * progress;
            SGPageTitleButton *firstBtn = _btnMArr[0];
            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(firstBtn).offset(([self offsetToButton:originalBtn] + (originalBtn.width - indicatorWidth)/2) + offsetX);
            }];
        }
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_indicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(SGPageTitleButton *)originalBtn targetBtn:(SGPageTitleButton *)targetBtn {
    /// 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == SGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            // targetBtn 与 originalBtn 中心点之间的距离
            CGFloat btnCenterXDistance = targetBtn.SG_centerX - originalBtn.SG_centerX;
            if (progress <= 0.5) {
                self.indicatorView.SG_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.SG_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.SG_x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance;
                self.indicatorView.SG_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        } else {
            // originalBtn 与 targetBtn 中心点之间的距离
            CGFloat btnCenterXDistance = originalBtn.SG_centerX - targetBtn.SG_centerX;
            if (progress <= 0.5) {
                CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (originalBtn.SG_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.SG_x = originalBtnX - 2 * progress * btnCenterXDistance;
                self.indicatorView.SG_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.SG_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.SG_x = targetBtnX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.SG_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        }
        
    } else if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (targetBtn.SG_width - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorFixedWidth - 0.5 * (originalBtn.SG_width - self.configure.indicatorFixedWidth);
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        CGFloat offsetX = totalOffsetX * progress;
        self.indicatorView.SG_x = originalBtnIndicatorX + offsetX;
        
    } else {
        /// 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = 0.0;
        CGFloat indicatorWidth = _configure.indicatorFixedWidth;
    
        // because progress 1 update constraints will update by other place
        if (progress != 1) {
            offsetX = (([self offsetToButton:targetBtn] + (targetBtn.width - indicatorWidth)/2) - ([self offsetToButton:originalBtn] + (originalBtn.width - indicatorWidth)/2)) * progress;
            SGPageTitleButton *firstBtn = _btnMArr[0];
            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(firstBtn).offset(([self offsetToButton:originalBtn] + (originalBtn.width - indicatorWidth)/2) + offsetX);
            }];
        }
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_smallIndicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(SGPageTitleButton *)originalBtn targetBtn:(SGPageTitleButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[targetBtn titleLabel] attributedText]];
            
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    self.indicatorView.SG_width = targetBtn.SG_width;
                } else {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
                self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[originalBtn titleLabel] attributedText]];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    self.indicatorView.SG_width = originalBtn.SG_width;
                } else {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
                self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }

    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress == 1.0) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[targetBtn titleLabel] attributedText]];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                self.indicatorView.SG_width = targetBtn.SG_width;
            } else {
                self.indicatorView.SG_width = tempIndicatorWidth;
            }
            self.indicatorView.SG_centerX = targetBtn.SG_centerX;
            [self P_changeSelectedButton:targetBtn];
        }];
    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[originalBtn titleLabel] attributedText]];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                self.indicatorView.SG_width = originalBtn.SG_width;
            } else {
                self.indicatorView.SG_width = tempIndicatorWidth;
            }
            self.indicatorView.SG_centerX = originalBtn.SG_centerX;
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_indicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(SGPageTitleButton *)originalBtn targetBtn:(SGPageTitleButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == SGIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[targetBtn titleLabel] attributedText]];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.SG_width) {
                    self.indicatorView.SG_width = targetBtn.SG_width;
                } else {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
                self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[originalBtn titleLabel] attributedText]];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= originalBtn.SG_width) {
                    self.indicatorView.SG_width = originalBtn.SG_width;
                } else {
                    self.indicatorView.SG_width = tempIndicatorWidth;
                }
                self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }

    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == SGIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.SG_centerX = originalBtn.SG_centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[targetBtn titleLabel] attributedText]];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.SG_width) {
                self.indicatorView.SG_width = targetBtn.SG_width;
            } else {
                self.indicatorView.SG_width = tempIndicatorWidth;
            }
            self.indicatorView.SG_centerX = targetBtn.SG_centerX;
            [self P_changeSelectedButton:targetBtn];
        }];

    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self SG_widthWithNSAttributedString:[[originalBtn titleLabel] attributedText]];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= originalBtn.SG_width) {
                self.indicatorView.SG_width = originalBtn.SG_width;
            } else {
                self.indicatorView.SG_width = tempIndicatorWidth;
            }
            self.indicatorView.SG_centerX = originalBtn.SG_centerX;
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - 颜色渐变方法抽取
- (void)P_isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 获取 targetProgress
    CGFloat targetProgress = progress;
    // 获取 originalProgress
    CGFloat originalProgress = 1 - targetProgress;
    
    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
    UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
    
    // 设置文字颜色渐变
    originalBtn.titleLabel.textColor = originalColor;
    targetBtn.titleLabel.textColor = targetColor;
}

#pragma mark - - - set
- (void)setIsNeedBounces:(BOOL)isNeedBounces {
    _isNeedBounces = isNeedBounces;
    if (isNeedBounces == NO) {
        self.scrollView.bounces = NO;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (selectedIndex) {
        _selectedIndex = selectedIndex;
    }
}

- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex {
    _resetSelectedIndex = resetSelectedIndex;
    [self P_btn_action:self.btnMArr[resetSelectedIndex]];
}

- (void)setIsTitleGradientEffect:(BOOL)isTitleGradientEffect {
    _isTitleGradientEffect = isTitleGradientEffect;
}

- (void)setIsOpenTitleTextZoom:(BOOL)isOpenTitleTextZoom {
    _isOpenTitleTextZoom = isOpenTitleTextZoom;
}

- (void)setTitleTextScaling:(CGFloat)titleTextScaling {
    _titleTextScaling = titleTextScaling;
    
    if (titleTextScaling) {
        if (titleTextScaling >= 0.3) {
            _titleTextScaling = 0.3;
        } else {
            _titleTextScaling = 0.1;
        }
    }
}

- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator == NO) {
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

#pragma mark - - - 颜色设置的计算
/// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}
/// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (CGFloat)offsetToButton:(SGPageTitleButton*)btn {
    CGFloat offsetX = 0;
    NSUInteger index = 0;
    if (btn.tag) {
        index = btn.tag;
    }
    if (index < _btnMArr.count) {
        for (int i = 0; i < index; i++) {
            SGPageTitleButton *btn = _btnMArr[i];
            if (self.configure.titleAlignment == SGPageTitleAlignmentJustified) {
                offsetX += btn.width;
            }else {
                offsetX += btn.width + _configure.spacingBetweenButtons;
            }
        }
    }
    return offsetX;
}

@end

