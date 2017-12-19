//
//  SYTitleScrollView.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "SYTitleScrollView.h"


@interface SYCollectionViewItem : UICollectionViewCell
@property (nonatomic,strong,readonly) UIButton *titleButton;
@end

@interface SYTitleScrollView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *contentCollectionView;
@end
@implementation SYTitleScrollView
/*
 //选中selectedItem，记录indexPath
 //字体放大
 //
 
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentCollectionView];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentCollectionView.frame = self.bounds;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    return CGSizeMake(0, CGRectGetHeight(self.bounds));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.contentCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    SYCollectionViewItem *item = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class]) forIndexPath:indexPath];
    item.titleButton.selected = YES;
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(indexPath.row);
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleItems.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYCollectionViewItem *item = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class]) forIndexPath:indexPath];
    item.titleButton.titleLabel.text = self.titleItems[indexPath.row];
    return item;
}
- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout*flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentCollectionView.dataSource = self;
        [_contentCollectionView registerClass:[SYCollectionViewItem class] forCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class])];
    }
    return _contentCollectionView;
}

@end

@implementation SYCollectionViewItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [self.backgroundView addSubview:self.titleButton];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleButton.frame = self.backgroundView.bounds;
}

@end


