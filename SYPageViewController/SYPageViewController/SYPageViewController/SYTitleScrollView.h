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
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic,copy) void (^didSelectedItemBlock)(NSInteger selecedItemIndex);

@end
