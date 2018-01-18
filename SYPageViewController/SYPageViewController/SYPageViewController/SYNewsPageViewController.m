//
//  SYNewsPageViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2018/1/15.
//  Copyright © 2018年 gao. All rights reserved.
//

#import "SYNewsPageViewController.h"

#import "SYPageViewController.h"
#import "SYTitleSegmentView.h"
@interface SYNewsPageViewController ()<SYPageViewControllerDataSource,SYPageViewControllerDelegate,SYTitleSegmentViewDataSource>
@property (nonatomic,strong) SYTitleSegmentView *titleView;
@property (nonatomic,strong) SYPageViewController *pageViewController;
@end

@implementation SYNewsPageViewController
- (void)dealloc{
    self.titleView.dataSource = nil;
    self.pageViewController.dataSource = nil;
    self.pageViewController.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    [self.pageViewController addToParentViewController:self frame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) -  CGRectGetMaxY(self.navigationController.navigationBar.frame) - 44 - CGRectGetHeight(self.tabBarController.tabBar.frame) )];
    
    [self.pageViewController showViewControllerWithPageNumber:0 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
    
    [self.titleView setSelectedItemAtIndex:0 animation:NO];

}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)dequeueReusableContentViewControllerWithClassName:(NSString *)className forPageNumber:(NSUInteger)pageNumber{
    return   [self.pageViewController dequeueReusableContentViewControllerWithClassName:className forPageNumber:pageNumber];
}

#pragma mark - SYPageViewControllerDataSource
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController{
    return visiableViewController;
}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)willDisplayVisiableViewControllerWithPageNumber:(NSUInteger)pageNumber{
    
    return [self.dataSource willDisplayContentViewControllerAtIndex:pageNumber];
}
- (NSUInteger)maxPageCount{
    return [self.dataSource numberOfTitles];
}
#pragma mark - SYPageViewControllerDelegate
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView{
    
    [self.titleView setSelectedItemAtIndex:pageViewController.visiableViewControllerCurrenPageNumber animation:YES];
}
#pragma mark - SYTitleSegmentViewDataSource
- (NSUInteger)numberOfTitles{
    return [self.dataSource numberOfTitles];
}
- (NSString *)titleForSegmentViewAtIndex:(NSUInteger)index{
    return [self.dataSource titleForSegmentViewAtIndex:index];
}
- (void)titleSegmentViewDidSelectedAnIndex:(NSUInteger)index{
    [self.pageViewController showViewControllerWithPageNumber:index direction:index > self.pageViewController.visiableViewControllerCurrenPageNumber ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animation:NO];
}
- (SYTitleSegmentView *)titleView{
    if (!_titleView) {
        _titleView = [[SYTitleSegmentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame),  CGRectGetWidth(self.view.bounds), 44)];
        _titleView.dataSource = self;
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
