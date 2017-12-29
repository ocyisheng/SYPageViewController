//
//  SYPageViewController.h
//  PopTest
//
//  Created by 高春阳 on 2017/12/18.
//  Copyright © 2017年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYPageViewController;
@protocol SYPageViewControllerProtocol <NSObject>
@required
@property (nonatomic,assign) NSUInteger currenPageNumber;
@end

@protocol SYPageViewControllerDataSource <NSObject>
@required

/**
 visiableVC加载完毕；可以在这里更新VC的内容

 @param visiableViewController 遵守SYPageViewControllerProtocol协议的VC
 @return visiableViewController
 */
- (UIViewController<SYPageViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerProtocol> *)visiableViewController;

@end

@protocol SYPageViewControllerDelegate <NSObject>
@optional
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView;
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView;
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView;

@end
@interface SYPageViewController : NSObject
@property (nonatomic,strong,readonly) UIViewController<SYPageViewControllerProtocol> *visiableViewController;
@property (nonatomic,assign,readonly) NSUInteger visiableViewControllerCurrenPageNumber;
@property (nonatomic,strong,readonly) UIScrollView *contentScrollView;
@property (nonatomic,weak) id<SYPageViewControllerDataSource> dataSource;
@property (nonatomic,weak) id<SYPageViewControllerDelegate> delegate;

/**
 初始化 SYPageViewController；默认水平滚动，书脊宽为8.f

 @param vcClass 遵循SYPageViewControllerProtocol协议，需要展示的VCName
 @return self
 */
- (instancetype)initWithConformsProtocolViewControllerClass:(Class )vcClass;

/**
 初始化 SYPageViewController

 @param vcClass 遵循SYPageViewControllerProtocol协议，需要展示的VC
 @param orientation 滚动方向
 @param pageSpacing 书脊宽度
 @return self
 */
- (instancetype)initWithConformsProtocolViewControllerClass:(Class )vcClass
                                 navigationOrientation:(UIPageViewControllerNavigationOrientation)orientation
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
 跳转上一页
 */
- (void)showLastVisiableViewController;


/**
 跳转下一页面
 */
- (void)showNextVisiableViewController;


/**
 设置最大页码数;

 @param maxPages 默认是NSUIntegerMax
 */
- (void)setMaxPages:(NSUInteger)maxPages;

/**
 跳转指定页面;默认显示第一个页面
 
 @param pageNumage 指定页面
 @param direction UIPageViewControllerNavigationDirection
 */
- (void)showViewControllerWithPageNumber:(NSUInteger)pageNumage
                               direction:(UIPageViewControllerNavigationDirection)direction;

@end
