//
//  ViewController.m
//  SYPageViewController
//
//  Created by 高春阳 on 2017/12/19.
//  Copyright © 2017年 gao. All rights reserved.
//

#import "ViewController.h"

#import "PageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushVC:(id)sender {
    PageViewController *pageVC = [[PageViewController alloc]initWithNibName:NSStringFromClass([PageViewController class]) bundle:nil];
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
