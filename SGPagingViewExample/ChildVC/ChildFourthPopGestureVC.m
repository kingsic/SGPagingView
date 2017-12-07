//
//  ChildFourthPopGestureVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/12/7.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildFourthPopGestureVC.h"
#import "ChildFourthPopGestureNextVC.h"

@interface ChildFourthPopGestureVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChildFourthPopGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"点击可进入下一界面 - - %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildFourthPopGestureNextVC *VC = [[ChildFourthPopGestureNextVC alloc] init];
    // 如果子控制器为第一个控制器，跳转下一个界面不需要调用 ReturnBlock；如果否需要调用；至于侧滑返回失效以及侧滑冲突问题可网上补习，这里只是提供本 Demo 的解决方案
    // 请结合 ChildFirstPopGestureVC 类做对比
    VC.ReturnBlock = ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    };
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
