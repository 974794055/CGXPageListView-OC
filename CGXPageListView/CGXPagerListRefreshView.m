//
//  CGXPagerListRefreshView.m
//  CGXPagerView
//
//  Created by CGX on 2018/8/28.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import "CGXPagerListRefreshView.h"

@interface CGXPagerListRefreshView()
@property (nonatomic, assign) CGFloat lastScrollingListViewContentOffsetY;
@end

@implementation CGXPagerListRefreshView


- (void)initializeViews {
    [super initializeViews];
    
    self.mainTableView.bounces = NO;
}

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView {
    [super preferredProcessListViewDidScroll:scrollView];
    BOOL shouldProcess = YES;
    if (self.currentScrollingListView.contentOffset.y > self.lastScrollingListViewContentOffsetY) {
        //往上滚动
    }else {
        //往下滚动
        if (self.mainTableView.contentOffset.y == 0) {
            shouldProcess = NO;
        }else {
            if (self.mainTableView.contentOffset.y < [self.delegate listTableHeaderViewHeightInPagerView:self]) {
                //mainTableView的header还没有消失，让listScrollView一直为0
                if (self.currentList && [self.currentList respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
                    [self.currentList listScrollViewWillResetContentOffset];
                }
                self.currentScrollingListView.contentOffset = CGPointZero;
                self.currentScrollingListView.showsVerticalScrollIndicator = false;
            }
        }
    }
    if (shouldProcess) {
        if (self.mainTableView.contentOffset.y < [self.delegate listTableHeaderViewHeightInPagerView:self]) {
            //处于下拉刷新的状态，scrollView.contentOffset.y为负数，就重置为0
            if (self.currentScrollingListView.contentOffset.y > 0) {
                //mainTableView的header还没有消失，让listScrollView一直为0
                if (self.currentList && [self.currentList respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
                    [self.currentList listScrollViewWillResetContentOffset];
                }
                self.currentScrollingListView.contentOffset = CGPointZero;
                self.currentScrollingListView.showsVerticalScrollIndicator = false;
            }
        } else {
            //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
            self.mainTableView.contentOffset = CGPointMake(0, [self.delegate listTableHeaderViewHeightInPagerView:self]);
            self.currentScrollingListView.showsVerticalScrollIndicator = true;
        }
    }
    self.lastScrollingListViewContentOffsetY = self.currentScrollingListView.contentOffset.y;
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView
{
    [super preferredProcessMainTableViewDidScroll:scrollView];
    if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
        //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate listTableHeaderViewHeightInPagerView:self]);
    }
    
    if (scrollView.contentOffset.y < [self.delegate listTableHeaderViewHeightInPagerView:self]) {
        //mainTableView已经显示了header，listView的contentOffset需要重置
        for (id<CGXPagerListViewListViewDelegate> list in self.validListDict.allValues) {
            //正在下拉刷新时，不需要重置
            UIScrollView *listScrollView = [list listScrollView];
            if (listScrollView.contentOffset.y > 0) {
                if ([list respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
                    [list listScrollViewWillResetContentOffset];
                }
                listScrollView.contentOffset = CGPointZero;
            }
        }
    }
}


@end
