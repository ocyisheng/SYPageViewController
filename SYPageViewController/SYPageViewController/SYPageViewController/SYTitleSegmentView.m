//
//  SYTitleSegmentView.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "SYTitleSegmentView.h"

@interface SYCollectionViewItem : UICollectionViewCell
@property (nonatomic,strong) UILabel *normalTitleLabel;
@property (nonatomic,strong) UILabel *selectedTitleLabel;
- (void)hiddenSelectTitleLable:(BOOL)hidden;
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedColor
       titleFont:(UIFont *)titleFont selectedTitleFont:(UIFont *)selectedFont;
@end

@interface SYTitleSegmentView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *contentCollectionView;
@property (nonatomic,strong) NSMutableSet<SYCollectionViewItem *> *allResumeItems;//储存所有的item
@property (nonatomic,strong) NSIndexPath *currentSelectedIndexPath;

@end
@implementation SYTitleSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         _scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont systemFontOfSize:15];
        _titleColorSelected = [UIColor redColor];
        _titleFontSelected = [UIFont systemFontOfSize:16];
        _titleItemColor = [UIColor whiteColor];
        _titleItemMargin = 4.;
        [self addSubview:self.contentCollectionView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentCollectionView.frame = self.bounds;
}
- (void)setTitleLabelColorWithSelectedInexPath:(NSIndexPath *)indexPath animation:(BOOL)animation{
    if (indexPath.item != self.currentSelectedIndexPath.item && self.currentSelectedIndexPath) {
        SYCollectionViewItem *currentItem = (SYCollectionViewItem *)[self.contentCollectionView  cellForItemAtIndexPath:indexPath];
        //不同的indexpath 可以获取同一个item
        //通过储存item，获取当前选中的，其他都都是正常的
        [self.allResumeItems enumerateObjectsUsingBlock:^(SYCollectionViewItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj == currentItem ? [obj hiddenSelectTitleLable:NO] : [obj hiddenSelectTitleLable:YES];
        }];
        
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionCenteredHorizontally :UICollectionViewScrollPositionCenteredVertically animated:animation];
    }
     self.currentSelectedIndexPath = indexPath;
}

- (void)setSelectedItemAtIndex:(NSUInteger)index animation:(BOOL)animation{
    [self setTitleLabelColorWithSelectedInexPath:[NSIndexPath indexPathForItem:index inSection:0] animation:animation];
}

- (void)setTitleItemColor:(UIColor *)titleItemColor{
    _titleItemColor = titleItemColor;
    self.contentCollectionView.backgroundColor = titleItemColor;
}
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = scrollDirection;
}
- (void)setTitleItemMargin:(CGFloat)titleItemMargin{
    _titleItemMargin = titleItemMargin;
    
    self.flowLayout.minimumInteritemSpacing= 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? (self.flowLayout.minimumInteritemSpacing = titleItemMargin): (self.flowLayout.minimumLineSpacing = titleItemMargin);
    (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? (self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, titleItemMargin, 0, titleItemMargin)): (self.contentCollectionView.contentInset = UIEdgeInsetsMake(titleItemMargin, 0, titleItemMargin,0));
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = self.titleItems ? self.titleItems[indexPath.row] : [self.dataSource titleForSegmentViewAtIndex:indexPath.row];;
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:self.titleFontSelected}].width;
    return CGSizeMake(width, CGRectGetHeight(self.bounds));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    [self setTitleLabelColorWithSelectedInexPath:indexPath animation:YES];
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(indexPath.row);
    }
    if (self.dataSource &&[self.dataSource respondsToSelector:@selector(titleSegmentViewDidSelectedAnIndex:)]) {
        [self.dataSource titleSegmentViewDidSelectedAnIndex:indexPath.row];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleItems ? self.titleItems.count : [self.dataSource numberOfTitles];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYCollectionViewItem *item = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class]) forIndexPath:indexPath];
    [item setTitle:(self.titleItems ? self.titleItems[indexPath.row] : [self.dataSource titleForSegmentViewAtIndex:indexPath.row])
        titleColor:self.titleColor selectedTitleColor:self.titleColorSelected
         titleFont:self.titleFont selectedTitleFont:self.titleFontSelected];
    indexPath == self.currentSelectedIndexPath ? [item hiddenSelectTitleLable:NO] :[item hiddenSelectTitleLable:YES];
    //保存所有重用cell
    [self.allResumeItems addObject:item];
    return item;
}

- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
         _contentCollectionView.contentInset = UIEdgeInsetsMake(0, _titleItemMargin, 0, _titleItemMargin);
        _contentCollectionView.backgroundColor = _titleItemColor;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator= NO;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        [_contentCollectionView registerClass:[SYCollectionViewItem class] forCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class])];
    }
    return _contentCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = _titleItemMargin;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
- (NSMutableSet <SYCollectionViewItem *> *)allResumeItems{
    if (!_allResumeItems) {
        _allResumeItems = [NSMutableSet set];
    }
    return _allResumeItems;
}
@end

@implementation SYCollectionViewItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _normalTitleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _normalTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_normalTitleLabel];
        
        _selectedTitleLabel = [[UILabel alloc]initWithFrame:self.bounds];
         _selectedTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_selectedTitleLabel];
    }
    return self;
}
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedColor
       titleFont:(UIFont *)titleFont selectedTitleFont:(UIFont *)selectedFont{
    self.normalTitleLabel.text = title;
    self.normalTitleLabel.font = titleFont;
    self.normalTitleLabel.textColor = titleColor;
    
    self.selectedTitleLabel.text = title;
    self.selectedTitleLabel.font = selectedFont;
    self.selectedTitleLabel.textColor = selectedColor;
}
- (void)hiddenSelectTitleLable:(BOOL)hidden{
    self.normalTitleLabel.hidden = !hidden;
    self.selectedTitleLabel.hidden = hidden;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.normalTitleLabel.frame = self.contentView.bounds;
    self.selectedTitleLabel.frame = self.contentView.bounds;
}

@end


