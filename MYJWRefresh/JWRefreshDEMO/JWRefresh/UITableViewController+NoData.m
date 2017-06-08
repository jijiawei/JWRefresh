//
//  UITableViewController+NoData.m
//  JWRefreshDEMO
//
//  Created by 16 on 2017/6/5.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import "UITableViewController+NoData.h"
#import <objc/runtime.h>

@interface UITableView ()

@property (nonatomic , strong) UIView *noDataView;
@end

@implementation UITableView (NoData)
+(void)load{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method method1 = class_getInstanceMethod(self, @selector(reloadData));
        Method method2 = class_getInstanceMethod(self, @selector(jw_tableViewReloadData));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)setUpNoDataImg:(UIView *)imgView{

    if (self.noDataView) {
        self.noDataView = nil;
    }
    self.noDataView = imgView;
}

- (void)jw_tableViewReloadData{

    [self setUpfootView];
    [self jw_tableViewReloadData];
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 0;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    for (NSInteger i = 0; i < sections; ++i) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:sections];
        if (!rows) {
            if (self.tableHeaderView) {
                CGFloat y = self.tableHeaderView.frame.size.height;
                self.noDataView.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height-y);
                self.scrollEnabled = YES;
            }else{
                self.scrollEnabled = NO;
            }
            [self addSubview:self.noDataView];
        }else{
            self.scrollEnabled = YES;
            if (self.noDataView) {
                [self.noDataView removeFromSuperview];
            }
        };
    }
}

// 去除多余的cell
- (void)setUpfootView{
    if (!self.tableFooterView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.tableFooterView = view;
    }
}

// 利用runtime添加属性
- (void)setNoDataView:(UIView *)noDataView{
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)noDataView{
    return objc_getAssociatedObject(self, _cmd);
}

@end
