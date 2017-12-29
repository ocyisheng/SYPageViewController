//
//  SYTitleScrollView.h
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTitleScrollView : UIView
@property (nonatomic,strong) NSArray *titleItems;
@property (nonatomic,copy) void (^didSelectedItemBlock)(NSUInteger selecedItemIndex);
- (void)setSelectedItemAtIndex:(NSUInteger)index animation:(BOOL)animation;
//- (void)setTitleColor:(UIColor *)titleColor selected:(BOOL)selected;
//- (void)setTitleFont:(UIFont *)titleFont selected:(BOOL)selected;
//- (void)setTitleItmeBackgroundColor:(UIColor *)itemBackgroundColor;
@end
