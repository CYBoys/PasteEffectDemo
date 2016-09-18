//
//  ViewController.m
//  PasteEffectDemo
//
//  Created by chairman on 16/9/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LYPaste.h"

/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *pasteView;

@end

static NSString * const identifier = @"identifier";

@implementation ViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 200)];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_SIZE.width, 50)];
    topView.backgroundColor = [UIColor orangeColor];
    [self.headerView addSubview:topView];
    
    UIView *middleView =[[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_SIZE.width, 50)];
    middleView.backgroundColor = [UIColor magentaColor];
    [self.headerView addSubview:middleView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_SIZE.width, 50)];
    [self.headerView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor redColor];
    self.headerView.backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.tableFooterView = [UIView new];
    
    
#warning 可以切换
//    self.pasteView = topView;
    self.pasteView = middleView;
//    self.pasteView = bottomView;
    
    [self.pasteView lyPaste_topWithSpacing:20.0];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_SIZE.width-150)/2, 0, 150, 50)];
    [button setTitle:@"clickME" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor cyanColor]];
    [bottomView addSubview:button];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = @"LaiYoung_";
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pasteView lyPaste_currentContentOffset:scrollView.contentOffset];
}

- (void)clickedBtn:(UIButton *)sender {
    NSLog(@"clickMe");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
