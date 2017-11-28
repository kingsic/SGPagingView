//
//  ChildVCFour.m
//  SGPageViewExample
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildVCFour.h"
#import "TempVC.h"

@interface ChildVCFour () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChildVCFour

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
    cell.textLabel.text = [NSString stringWithFormat:@"侧滑返回手势点击进入下一界面 - - %ld", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TempVC *VC = [[TempVC alloc] init];
    // 如果子控制器为第一个控制器，跳转下一个界面不需要调用 ReturnBlock；如果否需要调用；至于侧滑返回失效以及侧滑冲突问题可网上补习，这里只是提供本 Demo 的解决方案
    // 请结合 FirstTempVC 类做对比
    VC.ReturnBlock = ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    };
    [self.navigationController pushViewController:VC animated:YES];
}


@end
