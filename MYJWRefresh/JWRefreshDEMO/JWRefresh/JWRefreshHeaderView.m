//
//  JWRefreshHeaderView.m
//  平时测试
//
//  Created by 16 on 2017/5/31.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import "JWRefreshHeaderView.h"
#define refreshing @"正在刷新数据"
#define willRefresh @"松手刷新数据"
#define cancelRefresh @"下拉刷新数据"
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height

@interface JWRefreshHeaderView()
// 标题
@property (nonatomic , strong) UILabel *title;
// 图片
@property (nonatomic , strong) UIImageView *img;
// 菊花
@property (nonatomic , strong) UIActivityIndicatorView *refreshView;
@end

@implementation JWRefreshHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -50, SW, 50);
        [self creatViews];
        [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

// 添加刷新视图
- (void)creatViews{
    
    if (self.title == nil) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(SW/3, 0, SW/3, 50)];
        [self addSubview:self.title];
    }
    if (self.img == nil) {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(SW/3-30, 10, 30, 30)];
        self.img.image = [UIImage imageNamed:@"jw_refresh"];
        self.img.transform=CGAffineTransformMakeRotation(M_PI);
        [self addSubview:self.img];
    }
    if (self.refreshView == nil) {
        self.refreshView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshView.center = CGPointMake(SW/3-15, 25);
        self.refreshView.hidden = YES;
        [self.refreshView startAnimating];
        [self addSubview:self.refreshView];
    }
    self.title.font = [UIFont systemFontOfSize:18];
    self.title.text = cancelRefresh;
    self.title.textAlignment = NSTextAlignmentCenter;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"type"]) {
        self.title.text = [self getRefreshStatus:_type];
        if (_type == JW_RefreshShowTypeWillRefresh) {
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(0);
            }];
        }else if (_type == JW_RefreshShowTypeRefreshing) {
            self.img.hidden = YES;
            self.refreshView.hidden = NO;
        }else{
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(M_PI);
            }];
        }
    }
}
- (NSString *)getRefreshStatus:(JW_RefreshShowType)status{
    
    switch (status) {
            
        case JW_RefreshShowTypeWillRefresh:
            return willRefresh;
        case JW_RefreshShowTypeRefreshing:
            return refreshing;
        case JW_RefreshShowTypeCancelRefresh:
            return cancelRefresh;
        default:
            break;
    }
}
@end
