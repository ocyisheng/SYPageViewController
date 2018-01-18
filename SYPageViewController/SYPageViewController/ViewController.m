//
//  ViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "ViewController.h"


#import "SYPageViewController.h"
#import "SYTitleSegmentView.h"


#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "TableViewCell3.h"
#import "TableViewCell4.h"
#import "TableViewCell5.h"

#import "NewsViewController.h"


#define RandRGB (arc4random()%255/255.0)
@interface MyStoryVC2 : UIViewController<SYPageViewControllerContentViewControllerProtocol>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@property (nonatomic,strong) UITableView *tableView;

@end

@interface ViewController ()<SYPageViewControllerDataSource,SYPageViewControllerDelegate>
@property (nonatomic,strong) SYPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@property (nonatomic,strong) NSMutableDictionary *viewControllerDic;

@property (nonatomic,strong) MyStoryVC2 *sVC;
@end

@implementation ViewController
- (IBAction)push:(id)sender {
    
    [self.navigationController pushViewController:[[NewsViewController alloc]init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewControllerDic = [NSMutableDictionary dictionary];
    [self.pageViewController addToParentViewController:self frame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) , CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.pageViewController showViewControllerWithPageNumber:3 direction:UIPageViewControllerNavigationDirectionForward animation:NO];
    
    [self.view bringSubviewToFront:self.pushButton];
    
}
#pragma mark - SYPageViewControllerDataSource
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerContentViewControllerProtocol> *)visiableViewController{
    MyStoryVC2 *svc= (MyStoryVC2 *)visiableViewController;
    svc.label.text = [NSString stringWithFormat:@"第%ld页",svc.currenPageNumber + 1];
    return svc;
}
- (UIViewController<SYPageViewControllerContentViewControllerProtocol> *)willDisplayVisiableViewControllerWithPageNumber:(NSUInteger)pageNumber{
    return [self.pageViewController dequeueReusableContentViewControllerWithClassName:NSStringFromClass([MyStoryVC2 class]) forPageNumber:pageNumber];
}
- (NSUInteger)maxPageCount{
    return NSUIntegerMax;
}
#pragma mark - SYPageViewControllerDelegate
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewWillBeginScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidScroll:(UIScrollView *)contentScrollView{
}
- (void)pageViewController:(SYPageViewController *)pageViewController contentScrollViewDidEndScroll:(UIScrollView *)contentScrollView{
    
}

- (SYPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[SYPageViewController alloc]init];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}
@end
@interface MyStoryVC2 ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSArray *dataSource;
@end
@implementation MyStoryVC2

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self.view addSubview:self.tableView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];
    
    self.label.backgroundColor = [UIColor grayColor];
    
    self.label.textColor = [UIColor blueColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.label];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSource = @[@"1",@"3",@"2",@"2",@"4",@"4",@"4",@"1",@"1",@"1",@"1",@"5",@"2",@"2",@"2",@"2",@"2",@"3",@"3",@"5",@"5",@"5",@"5",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"1",@"3",@"2",@"2",@"3",@"1",@"4",@"4",@"4",@"4",@"5",@"1",@"2",@"2",@"2"];
    for (int i = 1; i < 6; i ++) {
        NSString *className = [NSString stringWithFormat:@"TableViewCell%d",i];
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
    
}
- (BOOL)isReusable{
    return YES;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
     NSLog(@"viewWillLayoutSubviews::%@",NSStringFromCGRect(self.view.bounds));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"TableViewCell%@",number] forIndexPath:indexPath];//
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)pushButton:(id)sender {
}
@end

