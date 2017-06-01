//
//  JWRefreshHeaderView.h
//  平时测试
//
//  Created by 16 on 2017/5/31.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JW_RefreshShowType) {
    // 刷新状态
    JW_RefreshShowTypeWillRefresh = 0,
    JW_RefreshShowTypeRefreshing = 1,
    JW_RefreshShowTypeCancelRefresh = 2
};

@interface JWRefreshHeaderView : UIView

@property (nonatomic , assign) JW_RefreshShowType type;
@end
