//
//  ViewController.m
//  JWRefreshDEMO
//
//  Created by 16 on 2017/5/31.
//  Copyright © 2017年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JWRefresh.h"

#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
// 数据数组
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation ViewController
{
    NSArray *dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JWRefresh";
    dataAry = @[@"美今日将首次尝试洲际导弹拦截 明确称针对朝",@"揭秘：当年日本发动全面侵华战争前做了什么准",@"中国限制出口造岛用挖泥船：出于国家安全考虑",@"细数军校毕业综合演练中的那些感人瞬间",@"日“准航母”越造越大，欲冲破枷笼",@"中国095核潜艇采用喷水推进 或追平美水平",@"歼20发动机之谜揭晓，美俄大惊失色",@"中国095核潜艇有一性能 或能追平美海狼级核潜",@"众议苑 | 中东一团乱麻，特朗普凑啥热闹？",@"美国首次尝试洲际导弹拦截 明确针对朝导弹",@"IS成杜特尔特心腹大患 中俄2武器可助菲律宾",@"美：已邀中国参加2018年环太军演及准备会议",@"特朗普密友涉嫌逃税13亿 曾为其总统选举提供助力",@"明天起，一批新规将改变你我的生活",@"公安部部署机动车号牌管理改革：机动车号牌可网上选号",@"卖房离京去河北养老：燕郊养老试点九成为京籍老人",@"台军拟成立无人机侦察中队 或将执行军事侦察任务",@"国家赔偿新标准：侵犯人身自由权日赔258.89元",@"美军首次洲际弹道导弹拦截测试获得成功",@"央视记者携带防弹衣在泰国被拘 面临最高5年监禁",@"“男孩成长女性化”趋势明显：家长担心变成娘娘腔"];
    self.dataArray = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        int x = arc4random() % 20;
        [self.dataArray addObject:dataAry[x]];
    }
    self.navigationController.navigationBar.translucent = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 上拉加载，下拉刷新测试
    __weak typeof(self)weakSelf = self;
    [self.tableView jw_addHeaderRefreshWithBlock:^{
        [weakSelf refreshTest];
    }];
    [self.tableView jw_addFooterRefreshWithBlock:^{
        [weakSelf loadTest];
    }];
    
}
- (void)refreshTest{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            int x = arc4random() % 20;
            [self.dataArray addObject:dataAry[x]];
        }
        [self.tableView endHeaderRefresh];
        [self.tableView reloadData];
    });
}
- (void)loadTest{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 5; i++) {
            int x = arc4random() % 20;
            [self.dataArray addObject:dataAry[x]];
        }
        [self.tableView endFooterRefresh];
        [self.tableView reloadData];
    });
}
#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
