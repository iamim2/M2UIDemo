//
//  M2SimpleGalleryView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：B；
//  版本：1.0；
//  配套：M2SimpleGalleryViewCell；
//  特点：仿ScrollView的pagingEnabled功能，但支持按itemWidth翻页，而非ScrollView的width；

#import <UIKit/UIKit.h>
#import "M2SimpleGalleryViewCell.h"

@protocol M2SimpleGalleryViewDataSource;
@protocol M2SimpleGalleryViewDelegate;

@interface M2SimpleGalleryView : UIView
- (id)initWithFrame:(CGRect)frame itemWidth:(float)itemWidth;
@property (nonatomic, weak)     id<M2SimpleGalleryViewDataSource>   dataSource;
@property (nonatomic, weak)     id<M2SimpleGalleryViewDelegate>     delegete;
- (void)reloadData;
@end

@protocol M2SimpleGalleryViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInGalleryView:(M2SimpleGalleryView *)galleryView;
- (M2SimpleGalleryViewCell *)galleryView:(M2SimpleGalleryView *)galleryView itemAtIndex:(NSInteger)index;
@end

@protocol M2SimpleGalleryViewDelegate <NSObject>
- (void)galleryView:(M2SimpleGalleryView *)galleryView didSelectedItemAtIndex:(NSInteger)index;
@end
