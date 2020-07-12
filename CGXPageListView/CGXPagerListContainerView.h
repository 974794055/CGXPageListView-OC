//
//  CGXPagingListContainerView.h
//  CGXPagingView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGXPagerListMainTableView;
@class CGXPagerListContainerView;
@class CGXPagerListContainerCollectionView;

@protocol CGXPagerListContainerCollectionViewGestureDelegate <NSObject>
- (BOOL)pagerListContainerCollectionViewGestureRecognizerShouldBegin:(CGXPagerListContainerCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface CGXPagerListContainerCollectionView: UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<CGXPagerListContainerCollectionViewGestureDelegate> gestureDelegate;
@end

@protocol CGXPagerListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(CGXPagerListContainerView *)listContainerView;

- (UIView *)listContainerView:(CGXPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(CGXPagerListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

- (void)listContainerView:(CGXPagerListContainerView *)listContainerView didEndDisplayingCellAtRow:(NSInteger)row;
@end


@interface CGXPagerListContainerView : UIView

@property (nonatomic, strong, readonly) CGXPagerListContainerCollectionView *collectionView;
@property (nonatomic, weak) id<CGXPagerListContainerViewDelegate> delegate;
@property (nonatomic, weak) CGXPagerListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<CGXPagerListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

- (void)deviceOrientationDidChanged;

@end


