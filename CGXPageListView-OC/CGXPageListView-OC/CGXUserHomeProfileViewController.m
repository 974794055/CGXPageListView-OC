//
//  CGXUserHomeProfileViewController.m
//  CGXPageListView-OC
//
//  Created by CGX on 2019/9/26.
//  Copyright © 2019 CGX. All rights reserved.
//

#import "CGXUserHomeProfileViewController.h"
#import "CGXPagerListView.h"
#import "CGXPagingHeaderView.h"
#import "CGXPageingListView.h"
#import "CGXPagerListRefreshView.h"

#import "CGXPageingListCollectionView.h"

static const CGFloat CGXTableHeaderViewHeight = 200;
static const CGFloat CGXheightForHeaderInSection = 50;

@interface CGXUserHomeProfileViewController () <CGXPagerListViewDelegate,CGXCategoryViewDelegate>
@property (nonatomic, strong) CGXPagerListView *pagingView;
@property (nonatomic, strong) CGXPagingHeaderView *userHeaderView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, strong) CGXCategoryTitleView *categoryView;

@end

@implementation CGXUserHomeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"个人中心";
    _titles = @[@"资料", @"作品", @"爱好"];
    
    _userHeaderView = [[CGXPagingHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGXTableHeaderViewHeight)];
    
    self.categoryView = [[CGXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGXheightForHeaderInSection)];
    self.categoryView.titleArray = [NSMutableArray arrayWithArray:self.titles];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    
    CGXCategoryIndicatorLineView *lineView = [[CGXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorLineWidth = 20;
    self.categoryView.indicators = @[lineView];
    
    _pagingView = [[CGXPagerListView alloc] initWithDelegate:self];
    self.pagingView.frame = CGRectMake(0, 0, ScreenWidth, kVCHeight);
    [self.view addSubview:self.pagingView];
    
    //FIXME:如果和CGXPagingView联动
    self.categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
}
- (UIView *)listTableHeaderViewInPagerView:(CGXPagerListView *)pagerView {
    return self.userHeaderView;
}
- (NSUInteger)listTableHeaderViewHeightInPagerView:(CGXPagerListView *)pagerView {
    return CGXTableHeaderViewHeight;
}

- (NSUInteger)listHeightForPinSectionHeaderInPagerView:(CGXPagerListView *)pagerView {
    return CGXheightForHeaderInSection;
}

- (UIView *)listViewForPinSectionHeaderInPagerView:(CGXPagerListView *)pagerView {
    return self.categoryView;
}

- (NSInteger)listNumberOfListsInPagerView:(CGXPagerListView *)pagerView {
    return self.titles.count;
}

- (id<CGXPagerListViewListViewDelegate>)listPagerView:(CGXPagerListView *)pagerView initListAtIndex:(NSInteger)index {
    CGXPageingListView *list = [[CGXPageingListView alloc] init];
    if (index == 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i= 0 ; i<arc4random() % 20+10; i++) {
            [arr addObject:[NSString stringWithFormat:@"%@",_titles[index]]];
        }
        list.dataSource = arr;
    }else if (index == 1) {
        CGXPageingListCollectionView *listCollView = [[CGXPageingListCollectionView alloc] init];
        return listCollView;
    }else if (index == 2) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i= 0 ; i<arc4random() % 20+10; i++) {
            [arr addObject:[NSString stringWithFormat:@"%@",_titles[index]]];
        }
        list.dataSource = arr;
    }
    return list;
}

- (void)listScrollViewWillResetContentOffset
{
    NSLog(@"哈哈哈");
}
- (void)listMainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}
- (void)categoryView:(CGXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
