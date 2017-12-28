//
//  PageViewController.m
//  PopTest
//
//  Created by 高春阳 on 2017/12/13.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "PageViewController.h"

#import "SYPageViewController.h"
@interface MyStoryVC : UIViewController<SYPageViewControllerProtocol>
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSUInteger currenPageNumber;
@end

@interface PageViewController ()<SYPageViewControllerDataSource>
@property (nonatomic,strong) SYPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pageViewController addToParentViewController:self];
    
    [self.view bringSubviewToFront:self.nextButton];
    [self.view bringSubviewToFront:self.lastButton];

}

- (UIViewController<SYPageViewControllerProtocol> *)didDisplayVisiableViewController:(UIViewController<SYPageViewControllerProtocol> *)visiableViewController{
    MyStoryVC *svc= (MyStoryVC *)visiableViewController;
    svc.label.text = [NSString stringWithFormat:@"这是第%ld页",svc.currenPageNumber];
    return svc;
}

- (IBAction)lastPage:(id)sender {
    [self.pageViewController showLastVisiableViewController];
}
- (IBAction)nextPage:(id)sender {
    [self.pageViewController showNextVisiableViewController];
}
- (SYPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[SYPageViewController alloc]initWithConformsProtocolViewControllerClass:[MyStoryVC class]];
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}
@end

@implementation MyStoryVC

- (void)viewDidLoad{
    [super viewDidLoad];

    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44)];

    self.label.backgroundColor = [UIColor grayColor];

    self.label.textColor = [UIColor blueColor];

    self.label.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:self.label];

}

@end






