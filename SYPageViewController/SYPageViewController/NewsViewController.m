//
//  NewsViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2018/1/15.
//  Copyright © 2018年 gao. All rights reserved.
//

#import "NewsViewController.h"
#import "SYNewsPageViewController.h"

#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "TableViewCell3.h"
#import "TableViewCell4.h"
#import "TableViewCell5.h"

@interface MyStoryVC5 : UIViewController<SYPageViewControllerContentViewControllerProtocol,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end

@interface MyStoryVC6 : UIViewController<SYPageViewControllerContentViewControllerProtocol,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end
@interface MyStoryVC7 : UIViewController<SYPageViewControllerContentViewControllerProtocol,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end

@interface NewsViewController ()<SYNewsPageViewControllerDataSource>
@property (nonatomic,strong) SYNewsPageViewController *newsPageVC;

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) NSArray *titles;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsPageVC = [[SYNewsPageViewController alloc]init];
    self.newsPageVC.dataSource = self;
    
    self.dataSource = @[@"5",@"5",@"5",@"5",@"6",@"6",@"5",@"7",@"7",@"5",@"5",@"6",@"6",@"6",@"6",@"7",@"6",@"7",@"5",@"7",@"6"];
    
     self.titles = @[@"测试1",@"测试2",@"测试3",@"测试4",@"测试5",@"测试6测试6",@"测试7",@"测试8",@"测试测试9",@"测试10",@"测试11",@"测测试12",@"测试13",@"测试14",@"测试15",@"测试16",@"测试17",@"测试18",@"测试19",@"测试20"];
    [self addChildViewController:self.newsPageVC];
    
    [self.view addSubview:self.newsPageVC.view];

}
- (NSUInteger)numberOfTitles{
    return self.titles.count;
}
- (NSString *)titleForSegmentViewAtIndex:(NSUInteger)index{
    return self.titles[index];
}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)willDisplayContentViewControllerAtIndex:(NSUInteger)index{
  UIViewController<SYPageViewControllerContentViewControllerProtocol> *vc5 =  [self.newsPageVC dequeueReusableContentViewControllerWithClassName:[NSString stringWithFormat:@"MyStoryVC%@",self.dataSource[index]] forPageNumber:index];
    return vc5;
}
@end
@implementation MyStoryVC5

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self.view addSubview:self.tableView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];
    
    self.label.backgroundColor = [UIColor grayColor];
    
    self.label.textColor = [UIColor blueColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSource = @[@"1",@"3",@"2",@"2",@"4",@"4",@"4",@"1",@"1",@"1",@"1",@"5",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"5",@"5",@"5",@"5",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"1",@"3",@"2",@"2",@"3",@"1",@"4",@"4",@"4",@"4",@"5",@"1",@"2",@"2",@"2"];
    for (int i = 1; i < 6; i ++) {
        NSString *className = [NSString stringWithFormat:@"TableViewCell%d",i];
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
}
- (BOOL)isReusable{
    return NO;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell5" forIndexPath:indexPath];//
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation MyStoryVC6

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self.view addSubview:self.tableView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];
    
    self.label.backgroundColor = [UIColor grayColor];
    
    self.label.textColor = [UIColor blueColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSource = @[@"1",@"3",@"2",@"2",@"4",@"4",@"4",@"1",@"1",@"1",@"1",@"5",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"5",@"5",@"5",@"5",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"1",@"3",@"2",@"2",@"3",@"1",@"4",@"4",@"4",@"4",@"5",@"1",@"2",@"2",@"2"];
    for (int i = 1; i < 6; i ++) {
        NSString *className = [NSString stringWithFormat:@"TableViewCell%d",i];
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
}
- (BOOL)isReusable{
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell3" forIndexPath:indexPath];//
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
@implementation MyStoryVC7

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self.view addSubview:self.tableView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];
    
    self.label.backgroundColor = [UIColor grayColor];
    
    self.label.textColor = [UIColor blueColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSource = @[@"1",@"3",@"2",@"2",@"4",@"4",@"4",@"1",@"1",@"1",@"1",@"5",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"5",@"5",@"5",@"5",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"1",@"3",@"2",@"2",@"3",@"1",@"4",@"4",@"4",@"4",@"5",@"1",@"2",@"2",@"2"];
    for (int i = 1; i < 6; i ++) {
        NSString *className = [NSString stringWithFormat:@"TableViewCell%d",i];
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
}
- (BOOL)isReusable{
    return NO;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell1" forIndexPath:indexPath];//
    return cell;//[NSString stringWithFormat:@"TableViewCell%@",number]
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
