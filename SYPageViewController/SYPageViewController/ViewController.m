//
//  ViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "ViewController.h"

#import "PageViewController.h"

#import "SYPageViewController.h"
#import "SYTitleScrollView.h"

@interface MyStoryVC2 : UIViewController<SYPageViewControllerProtocol>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@end

@interface ViewController ()<SYPageViewControllerDataSource,SYPageViewControllerDelegate>
@property (nonatomic,strong) SYTitleScrollView *titleView;
@property (nonatomic,strong) SYPageViewController *pageViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.titleView];
    [self.pageViewController setMaxPages:self.titleView.titleItems.count];
    [self.pageViewController addToParentViewController:self frame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 40)];
    
    [self.titleView setSelectedItemAtIndex:18];
    
    __weak typeof(self) weakSelf = self;
    [self.titleView setDidSelectedItemBlock:^(NSUInteger selectedItemIndex) {
        [ weakSelf.pageViewController showViewControllerWithPageNumber:selectedItemIndex direction:selectedItemIndex > weakSelf.pageViewController.visiableViewControllerCurrenPageNumber ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animation:NO];
    }];
    
    [self.pageViewController showViewControllerWithPageNumber:18 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
    
}
#pragma mark - SYPageViewControllerDataSource
- (UIViewController<SYPageViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerProtocol> *)visiableViewController{
    MyStoryVC2 *svc= (MyStoryVC2 *)visiableViewController;
    svc.label.text = [NSString stringWithFormat:@"第%ld页:%@",svc.currenPageNumber + 1,_titleView.titleItems[svc.currenPageNumber]];
    return svc;
}
#pragma mark - SYPageViewControllerDelegate
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView{
     NSLog(@"begain--contentOffset:%@",NSStringFromCGPoint(contentScrollView.contentOffset));
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView{
    NSLog(@"contentOffset:%@",NSStringFromCGPoint(contentScrollView.contentOffset));
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView{
    
    [self.titleView setSelectedItemAtIndex:pageViewController.visiableViewControllerCurrenPageNumber];
}
- (SYTitleScrollView *)titleView{
    if (!_titleView) {
        _titleView = [[SYTitleScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame),  CGRectGetWidth(self.view.bounds), 40.f)];
        _titleView.titleItems = @[@"测试1",@"测试2",@"测试3",@"测试4测试4",@"测试5",@"测试6",@"测试7测试7",@"测试8",@"测试测试9",@"测试10",@"测试11",@"测试12",@"测试4测试13",@"测试14",@"测试16",@"测试7测试17",@"测试18",@"测试测试19",@"测试20"];
    }
    
   return  _titleView;
}

- (SYPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[SYPageViewController alloc]initWithConformsProtocolViewControllerClass:[MyStoryVC2 class]];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}
@end
@implementation MyStoryVC2

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];
    
    self.label.backgroundColor = [UIColor grayColor];
    
    self.label.textColor = [UIColor blueColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
