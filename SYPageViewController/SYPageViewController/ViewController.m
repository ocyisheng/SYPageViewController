//
//  ViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "ViewController.h"


#import "SYPageViewController.h"
#import "SYTitleSegmentView.h"


#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "TableViewCell3.h"
#import "TableViewCell4.h"
#import "TableViewCell5.h"

#import "NewsViewController.h"


#define RandRGB (arc4random()%255/255.0)
@interface MyStoryVC2 : UIViewController<SYPageViewControllerContentViewControllerProtocol>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@property (nonatomic,strong) UITableView *tableView;

@end

@interface ViewController ()<SYPageViewControllerDataSource,SYPageViewControllerDelegate,SYTitleSegmentViewDataSource>
@property (nonatomic,strong) SYTitleSegmentView *titleView;
@property (nonatomic,strong) SYPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@property (nonatomic,strong) NSMutableDictionary *viewControllerDic;

@property (nonatomic,strong) MyStoryVC2 *sVC;
@end

@implementation ViewController
- (IBAction)push:(id)sender {
    
    [self.navigationController pushViewController:[[NewsViewController alloc]init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    self.viewControllerDic = [NSMutableDictionary dictionary];
    
    [self.pageViewController addToParentViewController:self frame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 44)];
    [self.pageViewController showViewControllerWithPageNumber:3 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
    
    [self.titleView setSelectedItemAtIndex:3 animation:NO];
    __weak typeof(self) weakSelf = self;
    [self.titleView setDidSelectedItemBlock:^(NSUInteger selectedItemIndex) {
        [ weakSelf.pageViewController showViewControllerWithPageNumber:selectedItemIndex direction:selectedItemIndex > weakSelf.pageViewController.visiableViewControllerCurrenPageNumber ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animation:NO];
    }];
    
    
    [self.view bringSubviewToFront:self.pushButton];
    
}
#pragma mark - SYPageViewControllerDataSource
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController{
    MyStoryVC2 *svc= (MyStoryVC2 *)visiableViewController;
    svc.label.text = [NSString stringWithFormat:@"第%ld页:%@",svc.currenPageNumber + 1,_titleView.titleItems[svc.currenPageNumber]];
    return svc;
}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)willDisplayVisiableViewControllerWithPageNumber:(NSUInteger)pageNumber{
    if (![self.viewControllerDic objectForKey:@(pageNumber)]) {
        MyStoryVC2 *sVC = [[MyStoryVC2 alloc]init];
        sVC.currenPageNumber = pageNumber;
        [self.viewControllerDic setObject:sVC forKey:@(pageNumber)];
        return sVC;
    }
    return [self.viewControllerDic objectForKey:@(pageNumber)];
}
- (NSUInteger)maxPageCount{
    return self.titleView.titleItems.count;
}

- (NSUInteger)numberOfTitles{
    return self.titleView.titleItems.count;
}
- (NSString *)titleForSegmentViewAtIndex:(NSUInteger)index{
    return self.titleView.titleItems[index];
}
- (void)titleSegmentViewDidSelectedAnIndex:(NSUInteger)index{
    
}
#pragma mark - SYPageViewControllerDelegate
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView{
    
    [self.titleView setSelectedItemAtIndex:pageViewController.visiableViewControllerCurrenPageNumber animation:YES];
}
- (SYTitleSegmentView *)titleView{
    if (!_titleView) {
        _titleView = [[SYTitleSegmentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame),  CGRectGetWidth(self.view.bounds), 44)];
        _titleView.dataSource = self;
        _titleView.titleItems = @[@"测试1",@"测试2",@"测试3",@"测试4",@"测试5",@"测试6测试6",@"测试7",@"测试8",@"测试测试9",@"测试10",@"测试11",@"测测试12",@"测试",@"测试14",@"测试16",@"测试7",@"测试18",@"测试19",@"测试20"];
        _titleView.titleColor = [UIColor blackColor];
        _titleView.titleFont = [UIFont systemFontOfSize:15];
        _titleView.titleColorSelected = [UIColor redColor];
        _titleView.titleFontSelected = [UIFont systemFontOfSize:16];
        _titleView.titleItemMargin = 10.f;
        _titleView.titleItemColor = [UIColor yellowColor];
    }
    
    return  _titleView;
}

- (SYPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[SYPageViewController alloc]init];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}
@end
@interface MyStoryVC2 ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSArray *dataSource;
@end
@implementation MyStoryVC2

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"TableViewCell%@",number] forIndexPath:indexPath];//
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)pushButton:(id)sender {
}
@end

