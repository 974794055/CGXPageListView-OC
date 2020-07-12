//
//  CGXPagingHeaderView.m
//  CGXCategoryView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import "CGXPagingHeaderView.h"

@interface CGXPagingHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@end

@implementation CGXPagingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CGXHomePageback"]];
        self.imageView.clipsToBounds = YES;
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        self.imageViewFrame = self.imageView.frame;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - 30, 200, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.text = @"在天愿作比翼鸟";
        label.textColor = [UIColor redColor];
        [self addSubview:label];
    }
    return self;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.imageViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.imageView.frame = frame;
}


@end
