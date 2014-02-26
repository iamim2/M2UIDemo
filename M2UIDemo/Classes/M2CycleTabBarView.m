//
//  M2CycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleTabBarView.h"

#define M2CTBV_ItemTagOffset 6000

@interface M2CycleTabBarView()<UIScrollViewDelegate>{
    UIScrollView    *_scrollView;
    float           _itemWidth;
    NSInteger       _itemsCountInPage;
    NSInteger       _logicCount;
    NSInteger       _physicalCount;
    NSMutableArray  *_physicalItems;
    NSInteger       _selectedPhysicalIndex;
    BOOL            _isScrollFromSynchronizeMsg;
}
@property (nonatomic) UIColor   *unSelectedTextColor;
@property (nonatomic) UIFont    *unSelectedFont;
@property (nonatomic) UIColor   *selectedTextColor;
@property (nonatomic) UIFont    *selectedFont;
@end

@implementation M2CycleTabBarView

- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 参数
        _itemsCountInPage = itemsCountPerPage;
        if (_itemsCountInPage <= 3) {
            _itemsCountInPage = 3;
        }
        
        // TODO:暂时只支持奇数个元素可见
        if (_itemsCountInPage % 2 == 0) {
            _itemsCountInPage -= 1;
        }
        
        // UI
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        // 样式 //TODO
        _unSelectedTextColor = [UIColor grayColor];
        _unSelectedFont = [UIFont systemFontOfSize:13];
        _selectedTextColor = [UIColor redColor];
        _selectedFont = [UIFont systemFontOfSize:16];
    }
    
    return self;
}

#pragma mark - setter
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    // 初始化items
    _logicCount = [_titles count];
    _physicalCount = _logicCount * 3;
    _physicalItems = [NSMutableArray arrayWithCapacity:_physicalCount];
    UIView *item = nil;
    _itemWidth = CGRectGetWidth(_scrollView.bounds) / _itemsCountInPage;
    float itemHeight = CGRectGetHeight(_scrollView.bounds);
    for (NSInteger i = 0; i < _physicalCount; i++) {
        item = [self itemWithPhysicalIndex:i];
        item.frame = CGRectMake(_itemWidth * i, 0, _itemWidth, itemHeight);
        [_scrollView addSubview:item];
        [_physicalItems addObject:item];
    }
    _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
    // 选中的第一个逻辑item
    _selectedPhysicalIndex = _logicCount;
    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:_selectedPhysicalIndex];
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:NO];//TODO 注意不要触发didScroll中的逻辑
}

#pragma mark - 定制item样式
- (UIView*)itemWithPhysicalIndex:(NSInteger)physicalIndex{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
    button.titleLabel.font = _unSelectedFont;
    [button setTitle:[_titles objectAtIndex:[self logicIndexByPhysicalIndex:physicalIndex]] forState:UIControlStateNormal];
    button.tag = physicalIndex + M2CTBV_ItemTagOffset;
    [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_isScrollFromSynchronizeMsg && _synchronizeObserver && [_synchronizeObserver respondsToSelector:@selector(view:didScrollOffsetX:itemWidth:itemsCountPerPage:)]) {
        [_synchronizeObserver view:self didScrollOffsetX:scrollView.contentOffset.x itemWidth:_itemWidth itemsCountPerPage:_itemsCountInPage];
    }
    _isScrollFromSynchronizeMsg = NO;
    
    NSInteger curLeftPhysicalIndex = [self leftPhysicalIndexWhenOffsetX:scrollView.contentOffset.x];
    NSInteger curPhysicalIndex = [self physicalIndexByLeftPhysicalIndex:curLeftPhysicalIndex];

    if (curPhysicalIndex == _selectedPhysicalIndex) {
        return;
    }
//    NSLog(@"~~physicalIndex从(%d)变为(%d)  @@%s", _selectedPhysicalIndex, curPhysicalIndex, __func__);

    float offsetX = scrollView.contentOffset.x;
    BOOL isNeedModifyOffset = NO;
    if (curPhysicalIndex - ((_itemsCountInPage - 1) / 2) == 0) {
        NSLog(@"( 到达左边缘  @@%s", __func__);
        curLeftPhysicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }else if (curPhysicalIndex + ((_itemsCountInPage - 1) / 2) == _physicalCount - 1){
        NSLog(@") 到达右边缘  @@%s", __func__);
        curLeftPhysicalIndex -= _logicCount;
        offsetX -= _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }
    

    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:curPhysicalIndex];
    _selectedPhysicalIndex = curPhysicalIndex;
    if (isNeedModifyOffset) {
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        return;
    }
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}

#pragma mark - 点击item
- (void)onTapItem:(UIButton *)sender{
    NSInteger physicalIndex = sender.tag - M2CTBV_ItemTagOffset;
    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:physicalIndex];
    _selectedPhysicalIndex = physicalIndex;
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}

#pragma mark - index换算
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger logicIndex = physicalIndex % _logicCount;
    return logicIndex;
}
- (NSInteger)leftPhysicalIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger leftPhysicalIndex = physicalIndex - ((_itemsCountInPage - 1) / 2);
    return leftPhysicalIndex;
}
- (NSInteger)physicalIndexByLeftPhysicalIndex:(NSInteger)leftPhysicalIndex{
    NSInteger physicalIndex = leftPhysicalIndex + ((_itemsCountInPage - 1) / 2);
    return physicalIndex;
}

#pragma mark - 修改选中item的样式、位置等
- (void)modifyStylePrePhysicalIndex:(NSInteger)prePhysicalIndex curPhysicalIndex:(NSInteger)curPhysicalIndex{
    if (prePhysicalIndex != curPhysicalIndex) {
        UIButton *preItem = [_physicalItems objectAtIndex:prePhysicalIndex];
        [preItem setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
        preItem.titleLabel.font = _unSelectedFont;
    }
    UIButton *curItem = [_physicalItems objectAtIndex:curPhysicalIndex];
    [curItem setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    curItem.titleLabel.font = _selectedFont;
}
- (void)modifyOffsetXByPhysicalIndex:(NSInteger)physicalIndex animated:(BOOL)animated{
    float offsetX = _itemWidth * [self leftPhysicalIndexByPhysicalIndex:physicalIndex];
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
}

#pragma mark - 
- (NSInteger)leftPhysicalIndexWhenOffsetX:(float)offsetX{
    float quotient = offsetX / _itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - _itemWidth * index;
    if (remainder / _itemWidth >= 0.5) {
        index++;
    }
    return index;
}

#pragma mark - M2CycleScrollSynchronizeProtocol
- (void)view:(UIView *)view didScrollOffsetX:(float)offsetX itemWidth:(float)itemWidth itemsCountPerPage:(NSInteger)itemsCountPerPage{
//    NSLog(@")))tabBarView接到同步通知offsetX(%f)  @@%s", offsetX, __func__);
    _isScrollFromSynchronizeMsg = YES;
    NSInteger deltaCount = ((_itemsCountInPage - 1) / 2) - ((itemsCountPerPage - 1) / 2);
    float myOffsetX = offsetX * (_itemWidth / itemWidth) - (_itemWidth * deltaCount);
    [_scrollView setContentOffset:CGPointMake(myOffsetX, 0)];
}

@end
