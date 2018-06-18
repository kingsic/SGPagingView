//
//  ChildFirstPopGestureVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/12/7.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildFirstPopGestureVC.h"
#import "ChildFirstPopGestureNextVC.h"

@interface ChildFirstPopGestureVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChildFirstPopGestureVC

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 切记：纯代码在 viewDidLoad 方法中创建 tableView 时，高度一定要等于 PageContent 的高度 self.view.frame.size.height - 108 或 使用 Masonry 进行 下面一句代码的约束；
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
    
    // XIB 创建 tableView 时，不会出现这种问题，是因为 XIB 加载完成之后会调用 viewDidLayoutSubviews 这个方法，所以 XIB 中创建 tableVIew 不会出现约束问题
    
    
    /// 解决方案三
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    /// 解决方案一
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108) style:UITableViewStylePlain];
    //    _tableView.dataSource = self;
    //    [self.view addSubview:self.tableView];
    
    
    /// 解决方案二
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    _tableView.dataSource = self;
    //    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"点击可进入下一界面 - - %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildFirstPopGestureNextVC *VC = [[ChildFirstPopGestureNextVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
