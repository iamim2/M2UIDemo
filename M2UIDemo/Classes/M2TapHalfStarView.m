//
//  M2TapHalfStarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2TapHalfStarView.h"

@interface M2TapHalfStarView()
@property (nonatomic) UIImage           *leftNormalImage;
@property (nonatomic) UIImage           *leftSelectedImage;
@property (nonatomic) UIImage           *rightNormalImage;
@property (nonatomic) UIImage           *rightSelectedImage;
@property (nonatomic) NSInteger         physicalCount;
@property (nonatomic) NSMutableArray    *items;
@end

@implementation M2TapHalfStarView
- (id)initWithFrame:(CGRect)frame{
    return [self initWithStarCount:M2THSV_DefaultStarCount];
}

- (id)initWithStarCount:(NSInteger)starCount{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (starCount <= 0) {
            starCount = M2THSV_DefaultStarCount;
        }
        //
        _physicalCount = starCount * 2;
        
        // items
        _items = [NSMutableArray arrayWithCapacity:_physicalCount];
        UIImageView *imgView = nil;
        for (int i = 0; i < _physicalCount; i++) {
            imgView = [UIImageView new];
            if (i % 2 == 0) {
                imgView.contentMode = UIViewContentModeRight;
            }else{
                imgView.contentMode = UIViewContentModeLeft;
            }
            [self addSubview:imgView];
            [_items addObject:imgView];
        }
        
        // tap event
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRec];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
leftNormalImageName:(NSString*)leftNormalImageName
leftSelectedImageName:(NSString*)leftSelectedImageName
rightNormalImageName:(NSString*)rightNormalImageName
rightSelectedImageName:(NSString*)rightSelectedImageName
          starCount:(NSInteger)starCount{
    self = [self initWithStarCount:starCount];
    if (self) {
        [self setupWithFrame:frame
         LeftNormalImageName:leftNormalImageName
       leftSelectedImageName:leftSelectedImageName
        rightNormalImageName:rightNormalImageName
      rightSelectedImageName:rightSelectedImageName];
    }
    
    return self;
}

#pragma mark - public
- (void)setupWithFrame:(CGRect)frame
   LeftNormalImageName:(NSString*)leftNormalImageName
 leftSelectedImageName:(NSString*)leftSelectedImageName
  rightNormalImageName:(NSString*)rightNormalImageName
rightSelectedImageName:(NSString*)rightSelectedImageName{
    self.frame = frame;
    //
    _leftNormalImage = [UIImage imageNamed:leftNormalImageName];
    _leftSelectedImage = [UIImage imageNamed:leftSelectedImageName];
    _rightNormalImage = [UIImage imageNamed:rightNormalImageName];
    _rightSelectedImage = [UIImage imageNamed:rightSelectedImageName];
    //
    float itemWidth = CGRectGetWidth(frame) / _physicalCount;
    float itemHeight = self.bounds.size.height;
    UIImageView *imageView = nil;
    for (NSInteger i = 0; i < _physicalCount; i++) {
        imageView = [_items objectAtIndex:i];
        imageView.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        if (i % 2 == 0) {
            imageView.image = _leftNormalImage;
        }else{
            imageView.image = _rightNormalImage;
        }
    }
}

#pragma mark - tap event
- (void)onTap:(UITapGestureRecognizer*)tapRec{
    if (tapRec.state == UIGestureRecognizerStateEnded) {
        // UI
        CGPoint point = [tapRec locationInView:tapRec.view];
        float itemWidth = CGRectGetWidth(self.bounds) / _physicalCount;
        self.grade = ceil(point.x / itemWidth) / 2.0;
        // delegate
        if (_delegate && [_delegate respondsToSelector:@selector(halfStarView:didSelectedForGrade:)]) {
            [_delegate halfStarView:self didSelectedForGrade:_grade];
        }
    }
}

#pragma mark - setter
- (void)setGrade:(float)grade{
    _grade = grade;
    if (_grade < 0) {
        _grade = 0;
    }else if (_grade > _physicalCount / 2.0){
        _grade = _physicalCount / 2.0;
    }
    
    UIImageView *imgView = nil;
    NSInteger selectTailIndex = round(_grade * 2) - 1;
    for (NSInteger i = 0; i < _physicalCount; i++) {
        imgView = [_items objectAtIndex:i];
        if (i <= selectTailIndex) {
            imgView.image = (i % 2 == 0 ? _leftSelectedImage : _rightSelectedImage);
        }else{
            imgView.image = (i % 2 == 0 ? _leftNormalImage : _rightNormalImage);
        }
    }
}

@end
