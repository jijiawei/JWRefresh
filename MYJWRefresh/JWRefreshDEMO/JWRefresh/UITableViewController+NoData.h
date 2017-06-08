//
//  UITableViewController+NoData.h
//  JWRefreshDEMO
//
//  Created by 16 on 2017/6/5.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoData)

/**
 设置无数据时图片控件
 */
- (void)setUpNoDataImg:(UIView *)imgView;

/**
 刷新tableView
 */
- (void)jw_tableViewReloadData;
@end
