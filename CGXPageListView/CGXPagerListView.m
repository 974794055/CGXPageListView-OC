//
//  CGXPagerListView.m
//  CGXPagerListView
//
//  Created by CGX on 2018/8/27.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import "CGXPagerListView.h"

@interface CGXPagerListView () <UITableViewDataSource, UITableViewDelegate, CGXPagerListContainerViewDelegate>

@property (nonatomic, strong) CGXPagerListMainTableView *mainTableView;
@property (nonatomic, strong) CGXPagerListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) id<CGXPagerListViewListViewDelegate> currentList;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, id<CGXPagerListViewListViewDelegate>> *validListDict;

@property (nonatomic, assign) UIDeviceOrientation currentDeviceOrientation;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation CGXPagerListView

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDelegate:(id<CGXPagerListViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = delegate;
        self.validListDict = [NSMutableDictionary dictionary];
        [self initializeViews];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeViews];
}
- (void)initializeViews {
    
     _validListDict = [NSMutableDictionary dictionary];
    
    _mainTableView = [[CGXPagerListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.scrollsToTop = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = [self.delegate listTableHeaderViewInPagerView:self];
    _listContainerView = [[CGXPagerListContainerView alloc] initWithDelegate:self];
    self.listContainerView.mainTableView = self.mainTableView;

    self.isListHorizontalScrollEnabled = YES;

    self.currentDeviceOrientation = [UIDevice currentDevice].orientation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.mainTableView.frame = self.bounds;
}

- (void)setIsListHorizontalScrollEnabled:(BOOL)isListHorizontalScrollEnabled {
    _isListHorizontalScrollEnabled = isListHorizontalScrollEnabled;

    self.listContainerView.collectionView.scrollEnabled = isListHorizontalScrollEnabled;
}

- (void)reloadData {
    self.currentList = nil;
    self.currentScrollingListView = nil;

    for (id<CGXPagerListViewListViewDelegate> list in self.validListDict.allValues) {
        [list.listView removeFromSuperview];
    }
    [_validListDict removeAllObjects];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(listTableHeaderViewInPagerView:)]) {
        self.mainTableView.tableHeaderView = [self.delegate listTableHeaderViewInPagerView:self];
//    }
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}
- (void)currentListDidAppear {
    [self listDidAppear:self.currentIndex];
}

- (void)currentListDidDisappear {
    [self listDidDisappear:self.currentIndex];
}
- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView {
    if (self.mainTableView.contentOffset.y < [self.delegate listTableHeaderViewHeightInPagerView:self]) {
        //mainTableView的header还没有消失，让listScrollView一直为0
        if (self.currentList && [self.currentList respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
            [self.currentList listScrollViewWillResetContentOffset];
        }
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate listTableHeaderViewHeightInPagerView:self]);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
        //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate listTableHeaderViewHeightInPagerView:self]);
    }

    if (scrollView.contentOffset.y < [self.delegate listTableHeaderViewHeightInPagerView:self]) {
        //mainTableView已经显示了header，listView的contentOffset需要重置
        for (id<CGXPagerListViewListViewDelegate> list in self.validListDict.allValues) {
            if ([list respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
                [list listScrollViewWillResetContentOffset];
            }
            [list listScrollView].contentOffset = CGPointZero;
        }
    }

    if (scrollView.contentOffset.y > [self.delegate listTableHeaderViewHeightInPagerView:self] && self.currentScrollingListView.contentOffset.y == 0) {
        //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate listTableHeaderViewHeightInPagerView:self]);
    }
}

#pragma mark - Private

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;

    [self preferredProcessListViewDidScroll:scrollView];
}

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notification {
    if (self.currentDeviceOrientation != [UIDevice currentDevice].orientation) {
        self.currentDeviceOrientation = [UIDevice currentDevice].orientation;
        //前后台切换也会触发该通知，所以不相同的时候才处理
        [self.mainTableView reloadData];
        [self.listContainerView deviceOrientationDidChanged];
        [self.listContainerView reloadData];
    }
}

- (void)listDidAppear:(NSInteger)index {
    NSUInteger count = [self.delegate listNumberOfListsInPagerView:self];
    if (count <= 0 || index >= count) {
        return;
    }
    self.currentIndex = index;

    id<CGXPagerListViewListViewDelegate> list = _validListDict[@(index)];
    if (list && [list respondsToSelector:@selector(listDidAppear)]) {
        [list listDidAppear];
    }
}

- (void)listDidDisappear:(NSInteger)index {
    NSUInteger count = [self.delegate listNumberOfListsInPagerView:self];
    if (count <= 0 || index >= count) {
        return;
    }
    id<CGXPagerListViewListViewDelegate> list = _validListDict[@(index)];
    if (list && [list respondsToSelector:@selector(listDidDisappear)]) {
        [list listDidDisappear];
    }
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.height - [self.delegate listHeightForPinSectionHeaderInPagerView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.listContainerView.frame = cell.bounds;
    [cell.contentView addSubview:self.listContainerView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listHeightForPinSectionHeaderInPagerView:)]) {
        return [self.delegate listHeightForPinSectionHeaderInPagerView:self];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewForPinSectionHeaderInPagerView:)]) {
           return  [self.delegate listViewForPinSectionHeaderInPagerView:self];
       }
    UITableViewHeaderFooterView *headerView  =[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    }
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listHeightForPinSectionFooterInPagerView:)]) {
          return [self.delegate listHeightForPinSectionFooterInPagerView:self];
      }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewForPinSectionFooterInPagerView:)]) {
           return  [self.delegate listViewForPinSectionFooterInPagerView:self];
       }
    UITableViewHeaderFooterView *footerView  =[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    if (footerView == nil) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    }
    footerView.contentView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(listMainTableViewDidScroll:)]) {
        [self.delegate listMainTableViewDidScroll:scrollView];
    }
    if (scrollView.isTracking && self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = NO;
    }
    [self preferredProcessMainTableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
}
#pragma mark - CGXPagingListContainerViewDelegate
- (NSInteger)numberOfRowsInListContainerView:(CGXPagerListContainerView *)listContainerView {
    return [self.delegate listNumberOfListsInPagerView:self];
}
- (UIView *)listContainerView:(CGXPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    id<CGXPagerListViewListViewDelegate> list = self.validListDict[@(row)];
    if (list == nil) {
        list = [self.delegate listPagerView:self initListAtIndex:row];
        __weak typeof(self)weakSelf = self;
        __weak typeof(id<CGXPagerListViewListViewDelegate>) weakList = list;
        [list listViewDidScrollCallback:^(UIScrollView *scrollView) {
            weakSelf.currentList = weakList;
            [weakSelf listViewDidScroll:scrollView];
        }];
        _validListDict[@(row)] = list;
    }
    for (id<CGXPagerListViewListViewDelegate> listItem in self.validListDict.allValues) {
        if (listItem == list) {
            [listItem listScrollView].scrollsToTop = YES;
        }else {
            [listItem listScrollView].scrollsToTop = NO;
        }
    }
    return [list listView];
}

- (void)listContainerView:(CGXPagerListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    [self listDidAppear:row];
    self.currentScrollingListView = [self.validListDict[@(row)] listScrollView];
}

- (void)listContainerView:(CGXPagerListContainerView *)listContainerView didEndDisplayingCellAtRow:(NSInteger)row {
    [self listDidDisappear:row];
}
@end
