//
//  ViewController.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "ViewController.h"
#import "NewStyleOneVC.h"
#import "NewStyleTwoVC.h"
#import "NewStyleThreeVC.h"
#import "StyleTwoVC.h"
#import "StyleFiveVC.h"
#import "StyleSevenVC.h"
#import "StyleEightVC.h"
#import "StyleNineVC.h"
#import "StyleBlockVC.h"
#import "StyleLastVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *title_arr;
@property (nonatomic, strong) NSArray *VC_arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title_arr = @[@"静止状态下标题按钮样式一", @"静止状态下标题按钮样式二", @"静止状态下标题按钮样式三", @"滚动状态下指示器样式一", @"滚动状态下指示器样式二", @"滚动状态下指示器样式三", @"标题按钮文字渐显效果", @"标题按钮文字缩放效果", @"Block创建滚动状态下标题按钮", @"导航栏上面的标题按钮"];
    
    NewStyleOneVC *newOneVC = [[NewStyleOneVC alloc] init];
    NewStyleTwoVC *newTwoVC = [[NewStyleTwoVC alloc] init];
    NewStyleThreeVC *newThreeVC = [[NewStyleThreeVC alloc] init];
    
    StyleTwoVC *twoVC = [[StyleTwoVC alloc] init];
    StyleFiveVC *fiveVC = [[StyleFiveVC alloc] init];
    StyleSevenVC *sevenVC = [[StyleSevenVC alloc] init];
    StyleEightVC *eightVC = [[StyleEightVC alloc] init];
    StyleNineVC *nineVC = [[StyleNineVC alloc] init];
    StyleBlockVC *blockVC = [[StyleBlockVC alloc] init];
    StyleLastVC *lastVC = [[StyleLastVC alloc] init];

    self.VC_arr = @[newOneVC, newTwoVC, newThreeVC, twoVC, fiveVC, sevenVC, eightVC, nineVC, blockVC, lastVC];

    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.title_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.title_arr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.VC_arr.count - 1) {
        [self.navigationController pushViewController:self.VC_arr[indexPath.row] animated:YES];
    } else {
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:self.VC_arr[indexPath.row]];
        [self presentViewController:nvc animated:YES completion:nil];
    }
}



@end


