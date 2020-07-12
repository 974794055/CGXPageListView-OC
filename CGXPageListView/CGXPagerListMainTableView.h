//
//  CGXPagingMainTableView.h
//  CGXPagingView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CGXPagerListMainTableViewGestureDelegate <NSObject>

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface CGXPagerListMainTableView : UITableView
@property (nonatomic, weak) id<CGXPagerListMainTableViewGestureDelegate> gestureDelegate;
@end
