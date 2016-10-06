//
//  ViewController.m
//  SGSegmentedControlExample
//
//  Created by Sorgle on 2016/10/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "ViewController.h"
#import "StyleOneVC.h"
#import "StyleTwoVC.h"
#import "StyleThreeVC.h"
#import "StyleFourVC.h"
#import "StyleFiveVC.h"
#import "StyleSixVC.h"
#import "StyleSevenVC.h"
#import "StyleEightVC.h"
#import "StyleNineVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.scrollEnabled = NO;
    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"静止状态下标题按钮";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"滚动状态下标题按钮";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"静态状态下带有图片的标题按钮";
    } else if (indexPath.row == 3){
        cell.textLabel.text = @"滚动状态下带有图片的标题按钮";
    } else if (indexPath.row == 4){
        cell.textLabel.text = @"指示器样式";
    } else if (indexPath.row == 5){
        cell.textLabel.text = @"指示器样式二";
    } else if (indexPath.row == 6){
        cell.textLabel.text = @"标题按钮文字渐显效果";
    } else if (indexPath.row == 7){
        cell.textLabel.text = @"标题按钮文字缩放效果";
    } else {
        cell.textLabel.text = @"导航栏标题按钮的创建";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StyleOneVC *VC = [[StyleOneVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        StyleTwoVC *VC = [[StyleTwoVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 2) {
        StyleFiveVC *VC = [[StyleFiveVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 3){
        StyleSixVC *VC = [[StyleSixVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 4){
        StyleFourVC *VC = [[StyleFourVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 5){
        StyleSevenVC *VC = [[StyleSevenVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 6){
        StyleEightVC *VC = [[StyleEightVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 7){
        StyleNineVC *VC = [[StyleNineVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        StyleThreeVC *VC = [[StyleThreeVC alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nvc animated:YES completion:nil];
    }

}

@end


