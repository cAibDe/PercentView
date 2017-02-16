//
//  ViewController.m
//  PercentView
//
//  Created by 张鹏 on 16/7/5.
//  Copyright © 2016年 robu. All rights reserved.
//

#import "ViewController.h"
#import "ZPPercentView.h"
@interface ViewController ()
@property (nonatomic, strong) ZPPercentView *percentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor redColor];
    [self percentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZPPercentView *)percentView{
    if (!_percentView) {
         CGFloat width = 150;
        _percentView = [[ZPPercentView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 150, width, width)];
        [_percentView updateZPPercent:@(80.0).floatValue openAnimation:YES];
        [self.view addSubview:_percentView];
    }
    return _percentView;

}
@end
