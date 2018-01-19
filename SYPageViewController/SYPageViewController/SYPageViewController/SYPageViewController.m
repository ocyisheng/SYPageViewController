//
//  SYPageViewController.m
//  PopTest
//
//  Created by 高春阳 on 2017/12/18.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "SYPageViewController.h"

@interface SYPageViewController ()<UIPageViewControllerDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,assign) UIPageViewControllerNavigationOrientation navigationOrientation;
@property (nonatomic,assign) CGFloat pageSpacing;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,assign) CGPoint contentOffset;
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSDictionary<NSNumber *,UIViewController<SYPageViewControllerContentViewControllerProtocol> *>*> *contentViewControllerDic;

@property (nonatomic,strong) NSMutableDictionary<NSNumber *,UIViewController<SYPageViewControllerContentViewControllerProtocol> *> *contentVCDic;
@end

@implementation SYPageViewController

- (instancetype)init{
    if (self = [super init]) {
        _navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        _pageSpacing = 8.f;
        _redisplayCurrentPage = NO;
    }
    return self;
}
- (instancetype)initWithNavigationOrientation:(UIPageViewControllerNavigationOrientation)orientation
                                  pageSpacing:(CGFloat)pageSpacing{
    if (self = [super init]) {
        _navigationOrientation = orientation;
        _pageSpacing = pageSpacing;
        _redisplayCurrentPage = NO;
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
    parentViewController.edgesForExtendedLayout = UIRectEdgeNone;
    //获取滚动视图
    [self contentScrollView];
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
        if (self.visiableViewController.currenPageNumber == pageNumber && _redisplayCurrentPage == NO) {
            return;
        }
        navDirection = (self.visiableViewController.currenPageNumber > pageNumber) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
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

- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)dequeueContentViewControllerWithClassName:(NSString *)className forPageNumber:(NSUInteger)pageNumber;{
    if (_contentVCDic == nil) {
        _contentVCDic = [NSMutableDictionary dictionary];
    }
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * vc = [self.contentVCDic objectForKey:@(pageNumber)];
    if (vc == nil) {
        vc  = [[[NSClassFromString(className) class] alloc]init];
        vc.currenPageNumber = pageNumber;
        [self.contentVCDic setObject:vc forKey:@(pageNumber)];
    }
    return vc;
}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)dequeueReusableContentViewControllerWithClassName:(NSString *)className forPageNumber:(NSUInteger)pageNumber{
    NSDictionary <NSNumber *,UIViewController<SYPageViewControllerContentViewControllerProtocol> *> * reusVCs = [self.contentViewControllerDic objectForKey:className];
    __block  UIViewController<SYPageViewControllerContentViewControllerProtocol> *reusVC = nil;
    [reusVCs enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController<SYPageViewControllerContentViewControllerProtocol> * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.isReusable == YES) {
            //1.是可复用的VC
            //2.只要和正在显示的不同就取出复用
            //3.不和正在显示的相邻
            //4.保证复用的vc最多有3个(实际个数 >= 3)
            if (obj != self.visiableViewController && abs((int)(key.unsignedIntegerValue - self.visiableViewControllerCurrenPageNumber)) >1) {
                reusVC = obj;
                *stop = YES;
            }
        }else{
            //不可复用的VC，根据key查找即可
            if (key.unsignedIntegerValue == pageNumber) {
                reusVC = obj;
                *stop = YES;
            }
        }
    }];
    if (reusVC == nil)
    {
        //没有找到可复用的该ClassName的VC,创建一个并保存
        reusVC = [[[NSClassFromString(className) class] alloc]init];
        NSMutableDictionary <NSNumber *,UIViewController<SYPageViewControllerContentViewControllerProtocol> *> * vcs = reusVCs == nil ? [NSMutableDictionary dictionary] : [reusVCs mutableCopy];
        [vcs setObject:reusVC forKey:@(pageNumber)];
        [self.contentViewControllerDic setObject:[vcs copy] forKey:className];
    }
    NSLog(@"currenPageNumber:%ld pageNumber:%ld",self.visiableViewControllerCurrenPageNumber,pageNumber);
   // NSLog(@"%@",self.contentViewControllerDic);
    reusVC.currenPageNumber = pageNumber;
    
    return reusVC;
}
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * currentVC = (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)viewController;
    if (currentVC.currenPageNumber > 0)
    {
       __block UIViewController<SYPageViewControllerContentViewControllerProtocol> *svc = [self.dataSource willDisplayVisiableViewControllerWithPageNumber:currentVC.currenPageNumber - 1];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //懒加载VC导致viewDidload方法在didDisplayVisiableViewController后调用！！！
            svc = [self.dataSource didDisplayVisiableViewController:svc];
        });
        NSLog(@"Before");
        return svc;
    }
    return nil;
}
- ( UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerContentViewControllerProtocol> * currentVC = (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)viewController;
    if (currentVC.currenPageNumber < [self.dataSource maxPageCount] -1)
    {
      __block  UIViewController<SYPageViewControllerContentViewControllerProtocol> *svc = [self.dataSource willDisplayVisiableViewControllerWithPageNumber:currentVC.currenPageNumber + 1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // 懒加载VC导致viewDidload方法在didDisplayVisiableViewController后调用！！！
            svc = [self.dataSource didDisplayVisiableViewController:svc];
        });
           NSLog(@"After");
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
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

- (NSMutableDictionary<NSString *,NSDictionary<NSNumber *,UIViewController<SYPageViewControllerContentViewControllerProtocol> *>*> *)contentViewControllerDic{
    if (_contentViewControllerDic == nil) {
        _contentViewControllerDic = [NSMutableDictionary dictionary];
    }
    return _contentViewControllerDic;
}
@end

