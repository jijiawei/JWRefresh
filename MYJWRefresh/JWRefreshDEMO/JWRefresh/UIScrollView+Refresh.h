//
//  UIScrollView+Refresh.h
//  平时测试
//
//  Created by 16 on 2017/5/26.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWRefreshHeaderView;
@class JWRefreshFooterView;

typedef NS_ENUM(NSInteger , JW_RefreshStatus) {

    // 刷新状态
    JW_RefreshStatusWillRefresh = 0,
    JW_RefreshStatusRefreshing = 1,
    JW_RefreshStatusCancelRefresh = 2,
    JW_RefreshStatusWillLoad = 3,
    JW_RefreshStatusLoading = 4,
    JW_RefreshStatusCancelLoad
};
// 刷新的回调
typedef void(^headerRefresh)();
typedef void(^footerRefresh)();
@interface UIScrollView (Refresh)

@property (nonatomic , copy) headerRefresh headerBlock;
@property (nonatomic , copy) footerRefresh footerBlock;
@property (nonatomic , copy) NSString *RefreshStatu;

// 下拉刷新
- (void)jw_addHeaderRefreshWithBlock:(headerRefresh)block;
- (void)endHeaderRefresh;

// 上拉加载
- (void)jw_addFooterRefreshWithBlock:(footerRefresh)block;
- (void)endFooterRefresh;
@end
