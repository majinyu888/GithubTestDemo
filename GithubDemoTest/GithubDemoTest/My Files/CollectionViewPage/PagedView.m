//
//  PageCollectionView.m
//  GithubDemoTest
//
//  Created by hb on 16/9/20.
//  Copyright © 2016年 com.bm.hb. All rights reserved.
//

#import "PagedView.h"
#import "PageCollectionViewFlowLayout.h"
#import "PageCollectionViewCell.h"

@interface PagedView()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>{
    NSInteger itemCountOnePage;//每页能显示多少个item
    NSInteger currentPage;/// 默认是0
}

/// 网格视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/// 分页视图
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/// CollectionView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consCollectionViewHeight;

@end

@implementation PagedView

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultSetting];
}

- (void)defaultSetting
{
    _maCates = [NSMutableArray array];
    _itemHeight = [UIScreen mainScreen].bounds.size.width/4;
    _itemWidth = [UIScreen mainScreen].bounds.size.width/4;
    _itemSpageH = 0.f;
    _itemSpageV = 0.f;
    _itemCountPerRow = 4;
    _rowCount = 2;
    itemCountOnePage = _itemCountPerRow * _rowCount;
    currentPage = 0;
    
    PageCollectionViewFlowLayout *layout = [[PageCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemCountPerRow = _itemCountPerRow;
    layout.rowCount = _rowCount;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PageCollectionViewCell class])];
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.collectionViewLayout = layout;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    _pageControl.currentPage = currentPage;
    _pageControl.numberOfPages = _maCates.count % itemCountOnePage == 0 ? _maCates.count / itemCountOnePage : (_maCates.count / itemCountOnePage)+ 1;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.defersCurrentPageDisplay = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.pageControl.frame.origin.y + self.pageControl.frame.size.height);
}

#pragma mark - Setters

- (void)setMaCates:(NSMutableArray *)maCates
{
    if (maCates.count == 0 || !maCates) {
        return;
    } else {
        _maCates = maCates;
        
        [_collectionView reloadData];
        _pageControl.currentPage = currentPage;
        _pageControl.numberOfPages = _maCates.count % itemCountOnePage == 0 ? _maCates.count / itemCountOnePage : (_maCates.count / itemCountOnePage)+ 1;
    }
}

#pragma mark - CollectionView Datasource

//Cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.maCates.count % itemCountOnePage == 0 ?  self.maCates.count : (1 + (self.maCates.count/itemCountOnePage)) * itemCountOnePage;
}

//Cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PageCollectionViewCell class]) forIndexPath:indexPath];
    if (self.maCates.count > indexPath.item) {
        cell.userInteractionEnabled = YES;
        cell.lbl.text = self.maCates[indexPath.item];
    } else {
        cell.userInteractionEnabled = NO;
        cell.lbl.text = nil;
    }
    return cell;
}

//每组之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.itemSpageV;
}

//Cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.itemSpageH;
}

//Header Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
//Footer Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
//重用的 Header 或者 Footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - CollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.maCates.count > indexPath.item) {
        return YES;
    } else {
        return NO;
    }
}

//Cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
        // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
        currentPage = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        //根据scrollView 的位置对page 的当前页赋值
        _pageControl.currentPage = currentPage;
    }
}

@end
