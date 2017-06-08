//
//  JWRefreshFooterView.m
//  平时测试
//
//  Created by 16 on 2017/5/31.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import "JWRefreshFooterView.h"

#define loading @"正在加载更多"
#define willLoad @"松手加载更多"
#define cancelLoad @"上拉加载更多"
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height

@interface JWRefreshFooterView()
// 标题
@property (nonatomic , strong) UILabel *title;
// 图片
@property (nonatomic , strong) UIImageView *img;
// 菊花
@property (nonatomic , strong) UIActivityIndicatorView *refreshView;
@end
@implementation JWRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatViews];
        [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)creatViews{
    
    if (self.title == nil) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(SW/3, 0, SW/3, 50)];
        [self addSubview:self.title];
    }
    if (self.img == nil) {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(SW/3-30, 10, 30, 30)];
        self.img.image = [UIImage imageNamed:@"jw_refresh"];
        [self addSubview:self.img];
    }
    if (self.refreshView == nil) {
        self.refreshView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshView.center = CGPointMake(SW/3-15, 25);
        self.refreshView.hidden = YES;
        [self addSubview:self.refreshView];
    }
    self.title.font = [UIFont systemFontOfSize:18];
    self.title.text = cancelLoad;
    self.title.textAlignment = NSTextAlignmentCenter;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"type"]) {
        self.title.text = [self getRefreshStatus:_type];
        if (_type == JW_LoadShowTypeWillLoad) {
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(M_PI);
            }];
        }else if (_type == JW_LoadShowTypeLoading) {
            self.img.hidden = YES;
            self.refreshView.hidden = NO;
            [self.refreshView startAnimating];
        }else{
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(0);
            }];
        }
    }

}
- (NSString *)getRefreshStatus:(JW_LoadShowType)status{
    
    switch (status) {
            
        case JW_LoadShowTypeWillLoad:
            return willLoad;
        case JW_LoadShowTypeLoading:
            return loading;
        case JW_LoadShowTypeCancelLoad:
            return cancelLoad;
        default:
            break;
    }
}

@end
