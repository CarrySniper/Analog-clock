//
//  ViewController.m
//  绘制模拟时钟
//
//  Created by 陈家庆 on 15-2-10.
//  Copyright (c) 2015年 shikee_Chan. All rights reserved.
//

#import "ViewController.h"

#import "AnalogClock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"模拟时钟";
    
    //只能使用initWithFrame初始化方法
    AnalogClock *clock = [[AnalogClock alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width-20, self.view.frame.size.width-20)];
    [self.view addSubview:clock];
    
    //asdadasd15asda5d54d5ad45a
    ///4454354343
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
