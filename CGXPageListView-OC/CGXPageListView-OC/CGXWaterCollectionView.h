//
//  CGXWaterCollectionView.h
//  CGXWaterUIcollectionView
//
//  Created by CGX on 2017/9/15.
//  Copyright © 2017年 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGXWaterCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSString *titleStr;
@end
