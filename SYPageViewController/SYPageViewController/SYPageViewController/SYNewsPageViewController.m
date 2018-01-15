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
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSDictionary<NSNumber *,UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *>*> *contentViewControllerDic;
@end

@implementation SYNewsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.titleView];
    
    [self.pageViewController addToParentViewController:self frame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 44)];
    [self.pageViewController showViewControllerWithPageNumber:3 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
    
    [self.titleView setSelectedItemAtIndex:3 animation:NO];
    
}
- (UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *)dequeueReusableContentViewControllerWithClassName:(NSString *)className forIndex:(NSUInteger)index{
    
   NSDictionary <NSNumber *,UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *> *  reusVCs = [self.contentViewControllerDic objectForKey:className];
    __block  UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *reusVC = nil;
    //查找可用vc
    [reusVCs enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.isReusable == YES) {
            if (obj != self.pageViewController.visiableViewController) {
                reusVC = obj;
                *stop = YES;
            }
        }else{
            if (key.unsignedIntegerValue == index) {
                reusVC = obj;
                 *stop = YES;
            }
        }
    }];
    if (reusVC == nil)
    {
        //没有找到可复用的该ClassName的VC,创建一个并保存
        reusVC = [[[NSClassFromString(className) class] alloc]init];
        NSMutableDictionary <NSNumber *,UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *> * vcs = reusVCs == nil ? [NSMutableDictionary dictionary] : [reusVCs mutableCopy];
        [vcs setObject:reusVC forKey:@(index)];
        [self.contentViewControllerDic setObject:[vcs copy] forKey:className];
    }
    reusVC.currenPageNumber = index;
    return reusVC;
}

#pragma mark - SYPageViewControllerDataSource
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController{
    visiableViewController.view.backgroundColor = [UIColor whiteColor];
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
- (NSMutableDictionary<NSString *,NSDictionary<NSNumber *,UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *>*> *)contentViewControllerDic{
    if (_contentViewControllerDic == nil) {
        _contentViewControllerDic = [NSMutableDictionary dictionary];
    }
    return _contentViewControllerDic;
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
