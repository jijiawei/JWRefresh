//
//  UIScrollView+Refresh.m
//  平时测试
//
//  Created by 16 on 2017/5/26.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "JWRefreshHeaderView.h"
#import "JWRefreshFooterView.h"
#import <objc/runtime.h>

#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
@interface UIScrollView()

@property (nonatomic , strong) JWRefreshHeaderView *headerView;
@property (nonatomic , strong) JWRefreshFooterView *footerView;
@end

@implementation UIScrollView (Refresh)

// 下拉刷新
- (void)jw_addHeaderRefreshWithBlock:(headerRefresh)block{
    self.headerBlock = block;
    if (self.headerView == nil) {
        self.headerView = [[JWRefreshHeaderView alloc]initWithFrame:CGRectMake(0, -50, SW, 50)];
    }
    [self addSubview:self.headerView];
    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"RefreshStatu" options:NSKeyValueObservingOptionNew context:nil];
}

// 停止下拉刷新
- (void)endHeaderRefresh{
    [self getRefreshStatus:JW_RefreshStatusCancelRefresh];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

// 上拉加载
- (void)jw_addFooterRefreshWithBlock:(footerRefresh)block{
    
    self.footerBlock = block;
    if (self.footerView == nil) {
        self.footerView = [[JWRefreshFooterView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SW, 50)];
    }
    [self addSubview:self.footerView];

    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"RefreshStatu" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// 停止上拉加载
- (void)endFooterRefresh{
    [self getRefreshStatus:JW_RefreshStatusCancelLoad];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

// 设置刷新状态
- (void)getRefreshStatus:(JW_RefreshStatus)status{
    
    switch (status) {
            // 设置下拉刷新状态
        case JW_RefreshStatusWillRefresh:// 将要下拉刷新
            self.RefreshStatu = @"JW_RefreshStatusWillRefresh";
            self.headerView.type = JW_RefreshShowTypeWillRefresh
            ;
            break;
        case JW_RefreshStatusRefreshing:// 正在下拉刷新
            self.RefreshStatu = @"JW_RefreshStatusRefreshing";
            self.headerView.type = JW_RefreshShowTypeRefreshing;
            break;
        case JW_RefreshStatusCancelRefresh:// 取消下拉刷新
            self.RefreshStatu = @"JW_RefreshStatusCancelRefresh";
            self.headerView.type = JW_RefreshShowTypeCancelRefresh;
            break;
            // 设置上拉加载状态
        case JW_RefreshStatusWillLoad:// 将要上拉加载
            self.RefreshStatu = @"JW_RefreshStatusWillLoad";
            self.footerView.type = JW_LoadShowTypeWillLoad;
            break;
        case JW_RefreshStatusLoading:// 正在上拉加载
            self.RefreshStatu = @"JW_RefreshStatusLoading";
            self.footerView.type = JW_LoadShowTypeLoading;
            break;
        case JW_RefreshStatusCancelLoad:// 取消上拉加载
            self.RefreshStatu = @"JW_RefreshStatusCancelLoad";
            self.footerView.type = JW_LoadShowTypeCancelLoad;
            break;
        default:
            break;
    }
}
#pragma mark 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.dragging) {
            if (self.contentOffset.y < 0) {// 处理下拉刷新
                NSLog(@"%@",self.RefreshStatu);
                if (![self.RefreshStatu isEqualToString:@"JW_RefreshStatusRefreshing"]) {// 判断是否正在刷新
                    
                    if (self.contentOffset.y <= -50) {// 准备下拉刷新
                        [self getRefreshStatus:JW_RefreshStatusWillRefresh];
                    }else{// 取消下拉刷新
                        [self getRefreshStatus:JW_RefreshStatusCancelRefresh];}
                }
            }else{// 处理上拉加载
                
                if (![self.RefreshStatu isEqualToString:@"JW_RefreshStatusLoading"]) {// 判断是否处于上拉加载中
                    
                    CGPoint offset = self.contentOffset;
                    CGSize size = self.frame.size;
                    CGSize contentSize = self.contentSize;
                    float load_Y = offset.y + size.height - contentSize.height;// 根据这个值来判断是否到了tableView的最低点
                    if (load_Y > 50) {// 准备上拉加载
                        NSLog(@"准备上拉加载了吗?");
                        [self getRefreshStatus:JW_RefreshStatusWillLoad];
                    }else{// 取消上拉加载
                        [self getRefreshStatus:JW_RefreshStatusCancelLoad];
                    }
                }
            }
        }else if([self.RefreshStatu isEqualToString:@"JW_RefreshStatusWillRefresh"]){// 下拉刷新
            
            [self getRefreshStatus:JW_RefreshStatusRefreshing];
            self.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
            self.headerBlock();
        }else if ([self.RefreshStatu isEqualToString:@"JW_RefreshStatusWillLoad"]){// 上拉加载
            
            [self getRefreshStatus:JW_RefreshStatusLoading];
            self.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            self.footerBlock();
        }
    }
    if ([keyPath isEqualToString:@"JW_RefreshStatu"]) {
        if (!self.dragging) {
            if ([self.RefreshStatu isEqualToString:@"JW_RefreshStatusWillRefresh"]) {
                [self getRefreshStatus:JW_RefreshStatusRefreshing];
                self.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                self.headerBlock();
            }else if ([self.RefreshStatu isEqualToString:@"JW_RefreshStatusWillLoad"]) {
                [self getRefreshStatus:JW_RefreshStatusLoading];
                self.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
                self.footerBlock();
            }
        }
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.footerView) {
            CGSize contentSize = self.contentSize;
            float load_y = contentSize.height;
            self.footerView.frame = CGRectMake(0, load_y, SW, 50);
        }
    }
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"RefreshStatu"];
    [self removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark 动态添加属性
// 利用runtime来添加视图属性
- (void)setHeaderView:(JWRefreshHeaderView *)headerView{
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN);
}
- (JWRefreshHeaderView *)headerView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterView:(JWRefreshFooterView *)footerView{
    objc_setAssociatedObject(self, @selector(footerView), footerView, OBJC_ASSOCIATION_RETAIN);
}
- (JWRefreshFooterView *)footerView{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加block属性最好使用copy（栈block -> 堆block）
- (void)setHeaderBlock:(headerRefresh)headerBlock{
    objc_setAssociatedObject(self, @selector(headerBlock), headerBlock, OBJC_ASSOCIATION_COPY);
}
-(headerRefresh)headerBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterBlock:(footerRefresh)footerBlock{
    objc_setAssociatedObject(self, @selector(footerBlock), footerBlock, OBJC_ASSOCIATION_COPY);
}
- (footerRefresh)footerBlock{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加刷新状态属性
-(void)setRefreshStatu:(NSString *)RefreshStatu{
    objc_setAssociatedObject(self, @selector(RefreshStatu), RefreshStatu, OBJC_ASSOCIATION_COPY);
}
-(NSString *)RefreshStatu{
    return objc_getAssociatedObject(self, _cmd);
}
@end
