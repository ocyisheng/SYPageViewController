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

@property (nonatomic,strong) NSMutableArray *conformsProtocolVCArray;

@property (nonatomic,copy) NSString *conformsProtocolViewControllerClassString;

@property (nonatomic,assign) NSUInteger maxPages;

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
- (instancetype)initWithConformsProtocolViewControllerClass:(Class)vcClass{
    if (self = [super init]) {
        _navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        _pageSpacing = 8.f;
        _conformsProtocolViewControllerClassString = NSStringFromClass(vcClass);
        _maxPages = NSUIntegerMax;
    }
    return self;
}
- (instancetype)initWithConformsProtocolViewControllerClass:(Class)vcClass
                                 navigationOrientation:(UIPageViewControllerNavigationOrientation)orientation
                                           pageSpacing:(CGFloat)pageSpacing{
    if (self = [super init]) {
        _navigationOrientation = orientation;
        _pageSpacing = pageSpacing;
       _conformsProtocolViewControllerClassString = NSStringFromClass(vcClass);
        _maxPages = NSUIntegerMax;
    }
    return self;
}
- (void)addToParentViewController:(UIViewController *)parentViewController{
    [self addToParentViewController:parentViewController frame:parentViewController.view.frame];
}
- (void)addToParentViewController:(UIViewController *)parentViewController frame:(CGRect)pageViewFrame{
    self.pageViewController.view.frame = pageViewFrame;
    [parentViewController addChildViewController:self.pageViewController];
    [parentViewController.view addSubview:self.pageViewController.view];
    //获取滚动视图
    [self contentScrollView];
}

- (void)showLastVisiableViewController{
    __weak typeof(self) weakSelf = self;
    [self showNextConformsProtocolViewControllerWithDirection:UIPageViewControllerNavigationDirectionReverse
                         animation:YES
                        completion:^(BOOL finished, UIViewController<SYPageViewControllerProtocol> *conformsProtocolViewController) {
                            [weakSelf.dataSource didDisplayVisiableViewController:conformsProtocolViewController];
                        }];
}
- (void)showNextVisiableViewController{
    __weak typeof(self) weakSelf = self;
    [self showNextConformsProtocolViewControllerWithDirection:UIPageViewControllerNavigationDirectionForward
                         animation:YES
                        completion:^(BOOL finished, UIViewController<SYPageViewControllerProtocol> *conformsProtocolViewController) {
                           [weakSelf.dataSource didDisplayVisiableViewController:conformsProtocolViewController];
                        }];
}

- (NSUInteger)visiableViewControllerCurrenPageNumber{
    UIViewController<SYPageViewControllerProtocol> *vc  = self.pageViewController.viewControllers.firstObject;
    return vc.currenPageNumber;
}
- (UIViewController <SYPageViewControllerProtocol> *)viewControllerWithPageNumber:(NSUInteger)pageNumber{
    for (UIViewController <SYPageViewControllerProtocol> *vc in self.conformsProtocolVCArray) {
        if (vc.currenPageNumber == pageNumber) {
            return vc;
        }
    }
    return nil;
}
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerProtocol> *svc = [self nextConformsProtocolViewControllerWithCurrentVC:(UIViewController<SYPageViewControllerProtocol> *)viewController direction:UIPageViewControllerNavigationDirectionReverse];
    return  [self.dataSource didDisplayVisiableViewController:svc];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIViewController<SYPageViewControllerProtocol> *svc = [self nextConformsProtocolViewControllerWithCurrentVC:(UIViewController<SYPageViewControllerProtocol> *)viewController direction:UIPageViewControllerNavigationDirectionForward];
    return  [self.dataSource didDisplayVisiableViewController:svc];
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
#pragma mark - Private method
- (void)showNextConformsProtocolViewControllerWithDirection:(UIPageViewControllerNavigationDirection)direction
                       animation:(BOOL)animation
                      completion:(void (^ __nullable)(BOOL finished,UIViewController<SYPageViewControllerProtocol> *conformsProtocolViewController))completion{
    
    UIViewController<SYPageViewControllerProtocol> *nextVC = [self nextConformsProtocolViewControllerWithCurrentVC:self.pageViewController.viewControllers.lastObject
                                               direction:direction];
    if (nextVC == nil) {
        completion(YES,nil);
        return;
    }
    [self.pageViewController setViewControllers:@[nextVC]
                          direction:direction
                           animated:animation
                         completion:^(BOOL finished) {
                             //调用块
                             completion(finished,nextVC);
                         }];
}

- (void)showViewControllerWithPageNumber:(NSUInteger)pageNumage direction:(UIPageViewControllerNavigationDirection)direction animation:(BOOL)animation {
    //每次都从第一个开始开始移动
    //依次查找对应currentPageNumber 左中右 vc
    //可以提前将对应currentPageNumber的，-1 currentPageNumber + 1 这三个VC的下标存储起来，减少循环次数
    
    NSUInteger maxCount = 0;
    for (int i = 0; i < self.conformsProtocolVCArray.count; i ++) {
      UIViewController<SYPageViewControllerProtocol> * pageNumberVC= self.conformsProtocolVCArray[i];
        pageNumberVC.currenPageNumber = i;
    }
    UIViewController <SYPageViewControllerProtocol > *nextVC =self.conformsProtocolVCArray[0];
    while (maxCount < self.maxPages) {
        if (maxCount == pageNumage) {
            break;
        }
       nextVC = [self nextConformsProtocolViewControllerWithCurrentVC:[self viewControllerWithPageNumber:maxCount] direction:UIPageViewControllerNavigationDirectionForward];
         maxCount ++;
    }
    __weak typeof(self) weakSelf  = self;
    [self.pageViewController setViewControllers:@[nextVC] direction:direction animated:animation completion:^(BOOL finished) {
        [weakSelf.dataSource didDisplayVisiableViewController:nextVC];
    }];
}
- (UIViewController<SYPageViewControllerProtocol> *)nextConformsProtocolViewControllerWithCurrentVC:(UIViewController<SYPageViewControllerProtocol> *)conformsProtocolViewController direction:(UIPageViewControllerNavigationDirection)direction{
    
    BOOL isAfter = (direction == UIPageViewControllerNavigationDirectionForward) ? YES : NO;
    
    if (conformsProtocolViewController == nil){
        return nil;
    }
    NSInteger currenPageNumber = conformsProtocolViewController.currenPageNumber;
    
    if (isAfter == YES && currenPageNumber >=self.maxPages- 1){
        //当前页面是最后一个时，向后滚动，则不再滚动
        return nil;
    }else if (isAfter == NO && currenPageNumber <= 0){
        //当前页面是第一个时，向前滚动，则不再滚动
        return nil;
    }
    
    NSUInteger vcIndex = [self.conformsProtocolVCArray indexOfObject:conformsProtocolViewController];
    if (isAfter) {
        if (vcIndex == self.conformsProtocolVCArray.count - 1) {
            vcIndex = 0;
        }else{
            //依次向后
            vcIndex ++;
        }
        //下一页码
        currenPageNumber ++;
    }else{
        if (vcIndex == 0) {
            vcIndex = self.conformsProtocolVCArray.count - 1;
        }else{
            //依次向前
            vcIndex --;
        }
        //下一页码
        currenPageNumber --;
    }
    UIViewController<SYPageViewControllerProtocol> *myVC  = [self.conformsProtocolVCArray objectAtIndex:vcIndex];
    myVC.currenPageNumber = currenPageNumber;
    return myVC;
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

- (NSMutableArray *)conformsProtocolVCArray{
    if (!_conformsProtocolVCArray) {
        _conformsProtocolVCArray = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
            UIViewController<SYPageViewControllerProtocol> *vc = [[[NSClassFromString(self.conformsProtocolViewControllerClassString) class] alloc]init];
            vc.currenPageNumber = i;
            vc.view.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:(1.f - i / 3.f)];
            [_conformsProtocolVCArray addObject:vc];
        }
    }
    return _conformsProtocolVCArray;
}
@end
