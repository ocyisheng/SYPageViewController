//
//  SYPageViewController.m
//  PopTest
//
//  Created by 高春阳 on 2017/12/18.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "SYPageViewController.h"

@interface SYPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,assign) UIPageViewControllerNavigationOrientation navigationOrientation;
@property (nonatomic,assign) CGFloat pageSpacing;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,assign) CGPoint contentOffset;
@end

@implementation SYPageViewController

- (void)dealloc
{
    self.pageViewController.dataSource = nil;
    self.pageViewController.delegate = nil;
    self.contentScrollView.delegate = nil;
}
- (instancetype)init{
    if (self = [super init]) {
        _navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        _pageSpacing = 8.f;
    }
    return self;
}
- (instancetype)initWithNavigationOrientation:(UIPageViewControllerNavigationOrientation)orientation
                                  pageSpacing:(CGFloat)pageSpacing{
    if (self = [super init]) {
        _navigationOrientation = orientation;
        _pageSpacing = pageSpacing;
    }
    return self;
}
#pragma mark - Public method
- (void)addToParentViewController:(UIViewController *)parentViewController{
    [self addToParentViewController:parentViewController frame:parentViewController.view.frame];
}
- (void)addToParentViewController:(UIViewController *)parentViewController frame:(CGRect)pageViewFrame{
    self.pageViewController.view.frame = pageViewFrame;
    [parentViewController addChildViewController:self.pageViewController];
    [parentViewController.view addSubview:self.pageViewController.view];
    //获取滚动视图
    [self contentScrollView];
    //默认显示第一个
    [self showViewControllerWithPageNumber:0 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
}

- (void)showLastVisiableViewController{
    if (self.visiableViewController) {
        [self showViewControllerWithPageNumber:self.visiableViewController.currenPageNumber-1 direction:UIPageViewControllerNavigationDirectionReverse animation:YES];
    }
}
- (void)showNextVisiableViewController{
    if (self.visiableViewController) {
        [self showViewControllerWithPageNumber:self.visiableViewController.currenPageNumber+1 direction:UIPageViewControllerNavigationDirectionForward animation:YES];
    }
}

- (void)showViewControllerWithPageNumber:(NSUInteger)pageNumber direction:(UIPageViewControllerNavigationDirection)direction animation:(BOOL)animation{
    if (pageNumber > [self.dataSource maxPageCount] - 1) {
        return;
    }
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * nextVC = [self.dataSource willDisplayVisiableViewControllerWithPageNumber:pageNumber];
    nextVC.currenPageNumber = pageNumber;
    UIPageViewControllerNavigationDirection navDirection = UIPageViewControllerNavigationDirectionForward;
    if (self.visiableViewController) {
        if (self.visiableViewController.currenPageNumber == pageNumber) {
            //如果是同一个不进行操作
            [self.dataSource didDisplayVisiableViewController:self.visiableViewController];
            return;
        }
        navDirection =  (self.visiableViewController.currenPageNumber > pageNumber) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    }
    __weak typeof(self) weakSelf = self;
    [self.pageViewController setViewControllers:@[nextVC] direction:navDirection animated:animation completion:^(BOOL finished) {
        [weakSelf.dataSource didDisplayVisiableViewController:nextVC];
    }];
}

- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController{
    return self.pageViewController.viewControllers.firstObject;
}
- (NSUInteger)visiableViewControllerCurrenPageNumber{
    UIViewController<SYPageViewControllerContentViewControllerProtocol> *vc  = self.pageViewController.viewControllers.firstObject;
    return vc.currenPageNumber;
}
#pragma mark - UIPageViewControllerDataSource
- ( UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * currentVC = (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)viewController;
    if (currentVC.currenPageNumber > 0) {
       __block UIViewController<SYPageViewControllerContentViewControllerProtocol> *svc = [self.dataSource willDisplayVisiableViewControllerWithPageNumber:currentVC.currenPageNumber - 1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //懒加载VC导致viewDidload方法在didDisplayVisiableViewController后调用！！！
            svc = [self.dataSource didDisplayVisiableViewController:svc];
        });
        return svc;
    }
    return nil;
    
}
- ( UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * currentVC = (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)viewController;
    if (currentVC.currenPageNumber < [self.dataSource maxPageCount] -1) {
      __block  UIViewController<SYPageViewControllerContentViewControllerProtocol> *svc = [self.dataSource willDisplayVisiableViewControllerWithPageNumber:currentVC.currenPageNumber + 1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // 懒加载VC导致viewDidload方法在didDisplayVisiableViewController后调用！！！
            svc = [self.dataSource didDisplayVisiableViewController:svc];
        });
        return svc;
    }
    //最后一个
    return nil;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //当pageViewController初始化时，获取偏移量
        self.contentOffset = self.contentScrollView.contentOffset;
    });
    if (self.contentOffset.x != self.contentScrollView.contentOffset.x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentScrollViewDidScroll:)]) {
            [self.delegate pageViewController:self contentScrollViewDidScroll:self.contentScrollView];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentScrollViewWillBeginScroll:)]) {
        [self.delegate pageViewController:self contentScrollViewWillBeginScroll:self.contentScrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentScrollViewDidEndScroll:)]) {
        [self.delegate pageViewController:self contentScrollViewDidEndScroll:self.contentScrollView];
    }
}

#pragma mark - Getter method

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        [self.pageViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIScrollView class]]) {
                _contentScrollView = obj;
                _contentScrollView.delegate = self;
                *stop = YES;
            }
        }];
    }
    return _contentScrollView;
}
- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        NSDictionary *option = @{UIPageViewControllerOptionInterPageSpacingKey:@(self.pageSpacing)};
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:self.navigationOrientation options:option];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

@end

