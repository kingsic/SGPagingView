//
//  ChildVCTwo.m
//  SGPageViewExample
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildVCTwo.h"

@interface ChildVCTwo () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChildVCTwo

- (void)dealloc {
    NSLog(@"ChildVCTwo - - dealloc");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ChildVCTwo - - viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ChildVCTwo - - viewDidLoad");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"滚动样式 - 点我可改变标题下标 - %ld", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndex" object:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
}


@end
