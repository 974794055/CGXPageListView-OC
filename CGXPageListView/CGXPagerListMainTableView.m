//
//  CGXPagerListMainTableView.m
//  CGXPagerView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import "CGXPagerListMainTableView.h"

@interface CGXPagerListMainTableView ()<UIGestureRecognizerDelegate>

@end

@implementation CGXPagerListMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(mainTableViewGestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate mainTableViewGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }else {
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    }
}

@end
