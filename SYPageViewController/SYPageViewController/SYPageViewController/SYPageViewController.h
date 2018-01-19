//
//  SYPageViewController.h
//  PopTest
//
//  Created by 高春阳 on 2017/12/18.
//  Copyright © 2017年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPageViewController;

@protocol SYPageViewControllerContentViewControllerProtocol <NSObject>
@required
//当前的位置 
@property (nonatomic,assign) NSUInteger currenPageNumber;
@optional
///是否可复用
@property (nonatomic,assign,readonly) BOOL isReusable;
@end

@protocol SYPageViewControllerDataSource <NSObject>
@required
/**
 visiableVC加载完毕；可以在这里更新VC的内容
 
 @param visiableViewController 遵守SYPageViewControllerContentViewControllerProtocol协议的VC
 @return visiableViewController
 */
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController;

/**
 返回对应pageNumber的VC；切记在这里给vc的currentPageNumber赋值
 
 @param pageNumber currentPageNumber
 @return visiableViewController
 */
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)willDisplayVisiableViewControllerWithPageNumber:(NSUInteger)pageNumber;

/**
最大vc的个数

 @return NSUInteger
 */
- (NSUInteger)maxPageCount;
@optional

@end

@protocol SYPageViewControllerDelegate <NSObject>
@optional
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView;
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView;
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView;

@end
@interface SYPageViewController : NSObject
@property (nonatomic,strong,readonly) UIViewController<SYPageViewControllerContentViewControllerProtocol> *visiableViewController;
@property (nonatomic,assign,readonly) NSUInteger visiableViewControllerCurrenPageNumber;
@property (nonatomic,strong,readonly) UIScrollView *contentScrollView;
///当前VC是否可重复刷新，默认是NO；YES时回调didDisplayVisiableViewController代理方法
@property (nonatomic,assign) BOOL redisplayCurrentPage;
@property (nonatomic,weak) id<SYPageViewControllerDataSource> dataSource;
@property (nonatomic,weak) id<SYPageViewControllerDelegate> delegate;

/**
 初始化 SYPageViewController；默认水平滚动，书脊宽为8.f
 
 @return self
 */
- (instancetype)init;

/**
 初始化 SYPageViewController
 
 @param orientation 滚动方向
 @param pageSpacing 书脊宽度
 @return self
 */
- (instancetype)initWithNavigationOrientation:(UIPageViewControllerNavigationOrientation)orientation
                                  pageSpacing:(CGFloat)pageSpacing;

/**
 将SYPageViewController添加到父VC上,默认frame与父VC的bounds相等
 
 @param parentViewController 父VC
 */
- (void)addToParentViewController:(UIViewController *)parentViewController;

/**
 将SYPageViewController添加到父VC上
 
 @param parentViewController 父VC
 @param pageViewFrame SYPageViewController.view.frame
 */
- (void)addToParentViewController:(UIViewController *)parentViewController
                            frame:(CGRect)pageViewFrame;

/**
 跳转上一页;
 */
- (void)showLastVisiableViewController;


/**
 跳转下一页面；
 */
- (void)showNextVisiableViewController;


/**
 跳转指定页面;
 
 @param pageNumber 指定页面
 @param direction UIPageViewControllerNavigationDirection
 @param animation 是否动画；
 */
- (void)showViewControllerWithPageNumber:(NSUInteger)pageNumber
                               direction:(UIPageViewControllerNavigationDirection)direction
                               animation:(BOOL)animation;


/**
 从复用池中去一个可用的VC

 @param className vc的类名
 @param pageNumber 位置
 @return 可用的VC
 */
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)dequeueReusableContentViewControllerWithClassName:(NSString *)className forPageNumber:(NSUInteger)pageNumber;

/**
 直接取出一个可用VC

 @param className vc的类名
 @param pageNumber pageNumber description位置
 @return 可用的VC
 */
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)dequeueContentViewControllerWithClassName:(NSString *)className forPageNumber:(NSUInteger)pageNumber;

@end

