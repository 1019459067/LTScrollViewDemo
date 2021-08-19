//
//  ViewController.m
//  LTScrollViewDemo
//
//  Created by HN on 2021/8/19.
//

#import "ViewController.h"
#import "LTSimpleTestOneVC.h"
#import "LTScrollViewDemo-Swift.h"
#import "MJRefresh.h"

#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface ViewController ()<LTSimpleScrollViewDelegate>

@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <LTButtonModel *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTSimpleManager *managerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubViews];
}


-(void)setupSubViews {
    
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

-(UILabel *)setupHeaderView {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 185)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.text = @"点击响应事件";
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [headerView addGestureRecognizer:gesture];
    return headerView;
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture");
}

-(void)glt_scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"---> %lf", scrollView.contentOffset.y);
}

-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = kIPhoneX ? 64 + 24.0 : 64.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, Y, self.view.bounds.size.width, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
        
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        
        /* 设置悬停位置 */
        //        _managerView.hoverY = 64;
        
        /* 点击切换滚动过程动画 */
        //        _managerView.isClickScrollAnimation = YES;
        
        /* 代码设置滚动到第几个位置 */
        //        [_managerView scrollToIndexWithIndex:self.viewControllers.count - 1];
        
    }
    return _managerView;
}


-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.bottomLineHeight = 4.0;
        _layout.bottomLineCornerRadius = 2.0;
        _layout.isAverage = YES;
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
    }
    return _layout;
}


- (NSArray <LTButtonModel *> *)titles {
    if (!_titles) {
        LTButtonModel *hotButton = [[LTButtonModel alloc]init];
        hotButton.title = @"作品";
        
        LTButtonModel *gameButton = [[LTButtonModel alloc]init];
        gameButton.title = @"点赞";

        _titles = @[hotButton, gameButton];
    }
    return _titles;
}


-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(LTButtonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LTSimpleTestOneVC *testVC = [[LTSimpleTestOneVC alloc] init];
        [testVCS addObject:testVC];
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
