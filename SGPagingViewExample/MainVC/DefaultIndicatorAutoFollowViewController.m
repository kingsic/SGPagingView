//
//  AutoFollowViewController.m
//  SGPagingViewExample
//
//  Created by WGQ-Macbook Pro on 2019/10/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "DefaultIndicatorAutoFollowViewController.h"
#import "SGPagingView.h"


@interface DefaultIndicatorAutoFollowViewController () <UITableViewDelegate, UITableViewDataSource, SGPageTitleViewDelegate>

@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSArray *dataSourceArray;

@property(nonatomic, strong) SGPageTitleView *titleView;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation DefaultIndicatorAutoFollowViewController

static NSString * const Identifier = @"AutoFollowViewControllerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.titleArray = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员", @"本地", @"小视频", @"猜你喜欢"];
    
    self.dataSourceArray = @[
        @[@"1", @"2"], @[@"3", @"4", @"5", @"6"], @[@"7", @"8", @"9"], @[@"10"],
        @[@"1", @"2"], @[@"3", @"4", @"5", @"6"], @[@"7", @"8", @"9"], @[@"10"],
        @[@"1", @"2"], @[@"3", @"4", @"5", @"6"], @[@"7", @"8", @"9"], @[@"10"]
    ];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
}


#pragma mark - Lazy Load

- (SGPageTitleView *)titleView {
    if (!_titleView) {
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.titleFont = [UIFont systemFontOfSize:12];
        configure.indicatorHeight = 5;
        configure.indicatorCornerRadius = 5;
        configure.indicatorToBottomDistance = 5;
        configure.titleSelectedFont = [UIFont systemFontOfSize:16];
        configure.indicatorStyle = SGIndicatorStyleDefault;
        configure.bottomSeparatorColor = [UIColor redColor];
        
        _titleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) delegate:self titleNames:self.titleArray configure:configure];
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
        
        // 解决scrollToRowAtIndexPath定位不准确的问题
        _tableView.estimatedRowHeight = 44;
        _tableView.estimatedSectionFooterHeight = 44;
        _tableView.estimatedSectionHeaderHeight = 32;
    }
    return _tableView;
}


#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self.dataSourceArray count] - 1) {
        return self.tableView.bounds.size.height;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = section == [self.dataSourceArray count] - 1 ? CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height) : CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:scrollView.contentOffset];
    if (!indexPath) {
        return;
    }
    
    NSInteger oldIndex = [indexPath section];
    NSInteger newIndex = oldIndex < [self.titleArray count] - 1 ? oldIndex + 1 : oldIndex;
    
    NSLog(@"indexPath: %@, old: %ld, new: %ld", indexPath, oldIndex, newIndex);
    
    [self.titleView setPageTitleViewWithProgress:0 originalIndex:oldIndex targetIndex:newIndex];
}


#pragma mark - SGPageTitleViewDelegate

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    NSLog(@"%ld", selectedIndex);
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
