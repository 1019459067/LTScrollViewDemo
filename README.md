# AVPlayerDemo
用于抖音个人中心悬浮效果

* <strong>为了达到比较流利的播放效果</strong>

## 一、功能特性及使用

1、支持改变头部高度
```
    weakSelf.managerView.glt_headerHeight = 40;
```
2、支持悬浮tabbar按钮自定义
```
    LTButtonModel *hotButton = [[LTButtonModel alloc]init];
    hotButton.title = @"作品 (160)";

    LTButtonModel *gameButton = [[LTButtonModel alloc]init];
    gameButton.title = @"点赞";
    gameButton.showIcon = YES;
    gameButton.normalImageName = @"ICON_lock_unselected";
    gameButton.selectedImageName = @"ICON_lock_selected";
    weakSelf.managerView.titles = @[hotButton, gameButton];
```                

3、使用如下：
```
- (void)setupSubViews {
    
    [self.view addSubview:self.managerView];
    
    __weak typeof(self) weakSelf = self;
    
    //配置headerView
    [self.managerView configHeaderView:^UIView * _Nullable{
        return [weakSelf setupHeaderView];
    }];
    
    //pageView点击事件
    [self.managerView didSelectIndexHandle:^(NSInteger index) {
        NSLog(@"点击了 -> %ld", index);
    }];
    
    //控制器刷新事件
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.managerView.glt_headerHeight = 40;
                
                LTButtonModel *hotButton = [[LTButtonModel alloc]init];
                hotButton.title = @"作品 (160)";
                
                LTButtonModel *gameButton = [[LTButtonModel alloc]init];
                gameButton.title = @"点赞";
                gameButton.showIcon = YES;
                gameButton.normalImageName = @"ICON_lock_unselected";
                gameButton.selectedImageName = @"ICON_lock_selected";
                weakSelf.managerView.titles = @[hotButton, gameButton];
                NSLog(@"对应控制器的刷新自己玩吧，这里就不做处理了🙂-----%ld", index);
                [strongScrollView.mj_header endRefreshing];
            });
        }];
    }];
    
}
```
## 二、效果图
![](screenshots/2021-08-19.mp4)


## 三、文档参考

参考：[LTScrollView](https://github.com/czhen09/ScrollPlayVideo)

### 更多问题请issue me！！！
