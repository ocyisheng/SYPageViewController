//
//  SYTitleScrollView.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "SYTitleScrollView.h"

@interface SYCollectionViewItem : UICollectionViewCell
@property (nonatomic,strong) UILabel *normalTitleLabel;
@property (nonatomic,strong) UILabel *selectedTitleLabel;
@end

@interface SYTitleScrollView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *contentCollectionView;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *buttonStateArray;
@property (nonatomic,assign) NSInteger currentSelectedIndex;
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;

@end
@implementation SYTitleScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self addSubview:self.contentCollectionView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentCollectionView.frame = self.bounds;
}
- (void)setTitleLabelColorWithSelectedInexPath:(NSIndexPath *)indexPath animation:(BOOL)animation{
    self.currentSelectedIndex = indexPath.row;
    SYCollectionViewItem *item = (SYCollectionViewItem *)[self.contentCollectionView  cellForItemAtIndexPath:indexPath];
    NSArray *items = [self.contentCollectionView visibleCells];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SYCollectionViewItem *currentItem = (SYCollectionViewItem *)obj;
        if (item == currentItem)
        {
            currentItem.selectedTitleLabel.hidden = NO;
            currentItem.normalTitleLabel.hidden = YES;
            
        }else
        {
            currentItem.selectedTitleLabel.hidden = YES;
            currentItem.normalTitleLabel.hidden = NO;
        }
    }];
    
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionCenteredHorizontally :UICollectionViewScrollPositionCenteredVertically animated:animation];
}

- (void)setSelectedItemAtIndex:(NSUInteger)index animation:(BOOL)animation{
    _currentSelectedIndex = index;
    [self setTitleLabelColorWithSelectedInexPath:[NSIndexPath indexPathForRow:index inSection:0] animation:animation];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = self.titleItems[indexPath.row];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]}].width;
    return CGSizeMake(width, CGRectGetHeight(self.bounds));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.contentCollectionView deselectItemAtIndexPath:indexPath animated:NO];

    [self setTitleLabelColorWithSelectedInexPath:indexPath animation:YES];
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
    item.normalTitleLabel.text = self.titleItems[indexPath.row];
    item.selectedTitleLabel.text = self.titleItems[indexPath.row];
    if (indexPath.row == self.currentSelectedIndex)
    {
        item.normalTitleLabel.hidden = YES;
        item.selectedTitleLabel.hidden = NO;
        
    }else
    {
        item.normalTitleLabel.hidden = NO;
        item.selectedTitleLabel.hidden = YES;
    }
    return item;
}

- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout*flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 4.f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator= NO;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 4.f, 0, 4.f);
        [_contentCollectionView registerClass:[SYCollectionViewItem class] forCellWithReuseIdentifier:NSStringFromClass([SYCollectionViewItem class])];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _contentCollectionView;
}

@end

@implementation SYCollectionViewItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _normalTitleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _normalTitleLabel.font = [UIFont systemFontOfSize:14.f];
        _normalTitleLabel.textColor = [UIColor blackColor];
        _normalTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_normalTitleLabel];
        _selectedTitleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _selectedTitleLabel.font = [UIFont systemFontOfSize:16.f];
         _selectedTitleLabel.textAlignment = NSTextAlignmentCenter;
        _selectedTitleLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_selectedTitleLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.normalTitleLabel.frame = self.contentView.bounds;
    self.selectedTitleLabel.frame = self.contentView.bounds;
}

@end


