//
//  CGXPageingListCollectionView.h
//  CGXPageListView-OC
//
//  Created by CGX on 2019/10/9.
//  Copyright © 2019 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGXPagerListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CGXPageingListCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource,CGXPagerListViewListViewDelegate>
@property (strong, nonatomic) UICollectionView *waterCollectionView;
@property (strong, nonatomic) NSMutableArray *imageArr;

@end

NS_ASSUME_NONNULL_END
