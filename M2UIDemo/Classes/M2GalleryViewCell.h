//
//  M2GalleryViewCell.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：B；
//  版本：1.0；
//  配套：M2GalleryView；

#import <UIKit/UIKit.h>
@protocol M2GalleryViewCellDelegate;

@interface M2GalleryViewCell : UIView
// required：子类请实现image的getter方法；
@property (nonatomic) UIImage       *image;
// required：您需要在子类的image加载完毕后（类似self.customImageView.image = image之后），调用此方法；
- (void)didLoadImageFinish;

// optional：建议子类也提供imageView（承载上述image的view）的getter方法，M2GalleryView会调整其图片显示效果；
@property (nonatomic) UIImageView   *imageView;// optional

// 您不需求手动设置下面两个属性；
@property (nonatomic, weak)         id<M2GalleryViewCellDelegate> delegate;
@property (nonatomic) BOOL          isDidLoadImageFinish;

@end

@protocol M2GalleryViewCellDelegate <NSObject>
- (void)didLoadImageFinishByCell:(M2GalleryViewCell *)cell;
@end

/*
 * 一个M2GalleryViewCell子类的示例
 *
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _customImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_customImageView];
        
        // TODO：伪装image获取成功；
        [self performSelector:@selector(didLoadImageFinish) withObject:nil afterDelay:0.5 + arc4random() % 50 / 10.0];
    }
    return self;
}

#pragma mark - setter/getter
- (UIImage*)image{
    return _customImageView.image; // 1、required：mage的getter
}
- (UIImageView*)imageView{
    return _customImageView; // optional: 实现imageView的getter
}

#pragma mark -
- (void)didLoadImageFinish{
    // 设置image
    _customImageView.image = [UIImage imageNamed:self.imageName];
    // 2、required：调用父类didLoadImageFinish方法；
    [super didLoadImageFinish];
}
*/

