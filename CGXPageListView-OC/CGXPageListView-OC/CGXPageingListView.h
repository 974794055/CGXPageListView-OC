//
//  CGXPageingListView.h
//  CGXCategoryView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGXPagerListView.h"

@interface CGXPageingListView : UIView <CGXPagerListViewListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *dataSource;

@end
