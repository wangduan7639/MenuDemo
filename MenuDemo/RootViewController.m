//
//  RootViewController.m
//  MenuDemo
//
//  Created by wd on 2017/1/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "RootViewController.h"
#import "MenuView.h"

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MenuView *menuView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Menu";
    [self setupNavView];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.menuView = [[MenuView shareManager] initWithContainerViewController:self];
    //NSLog(@"----LeftMenuView0---- %@",self.menuView);
}

- (void)setupNavView{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor darkGrayColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"Left" forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(openLeftMenuView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Right" forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [leftBtn addTarget:self action:@selector(openRightMenuView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openLeftMenuView {

}

- (void)openRightMenuView {

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    if (indexPath.row %2 ==0) {
        cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
    }else{
        cell.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.25];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    //#ifdef DEBUG
    //    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
    //#endif
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了 tableView的第 %ld 个cell", (long)indexPath.row);

}


@end
