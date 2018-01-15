//
//  SYNewsPageViewController.h
//  SYPageViewController
//
//  Created by 高春阳 on 2018/1/15.
//  Copyright © 2018年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYPageViewController.h"

@protocol SYNewsPageViewControllerContentViewControllerProtocol <SYPageViewControllerContentViewControllerProtocol>
@required
@property (nonatomic,assign,readonly) BOOL isReusable;
@optional
@end

@protocol SYNewsPageViewControllerDataSource <NSObject>
@required
- (NSUInteger)numberOfTitles;
- (NSString *)titleForSegmentViewAtIndex:(NSUInteger)index;
- (UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *)willDisplayContentViewControllerAtIndex:(NSUInteger)index;

@end

@interface SYNewsPageViewController : UIViewController
@property (nonatomic,weak) id<SYNewsPageViewControllerDataSource> dataSource;
- (UIViewController<SYNewsPageViewControllerContentViewControllerProtocol> *)dequeueReusableContentViewControllerWithClassName:(NSString *)className forIndex:(NSUInteger)index;
@end
