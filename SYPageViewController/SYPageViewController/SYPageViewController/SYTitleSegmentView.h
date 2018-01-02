//
//  SYTitleSegmentView.h
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTitleSegmentView : UIView

///标题数组
@property (nonatomic,strong) NSArray<NSString *> *titleItems;
///选中的回调
@property (nonatomic,copy) void (^didSelectedItemBlock)(NSUInteger selecedItemIndex);
///选中item
- (void)setSelectedItemAtIndex:(NSUInteger)index animation:(BOOL)animation;
///标题的font
@property (nonatomic,strong) UIFont *titleFont;
///选中标题
@property (nonatomic,strong) UIFont *titleFontSelected;
///标题的颜色
@property (nonatomic,strong) UIColor *titleColor;
///选中标题的颜色
@property (nonatomic,strong) UIColor *titleColorSelected;
///item的背景色
@property (nonatomic,strong) UIColor *titleItemColor;
///标题之间的间距
@property (nonatomic,assign) CGFloat titleItemMargin;
///滚动方向
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;
@end
