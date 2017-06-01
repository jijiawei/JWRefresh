//
//  JWRefreshFooterView.h
//  平时测试
//
//  Created by 16 on 2017/5/31.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JW_LoadShowType) {
    // 刷新状态
    JW_LoadShowTypeWillLoad = 0,
    JW_LoadShowTypeLoading = 1,
    JW_LoadShowTypeCancelLoad = 2
};

@interface JWRefreshFooterView : UIView

@property (nonatomic , assign) JW_LoadShowType type;
@end
