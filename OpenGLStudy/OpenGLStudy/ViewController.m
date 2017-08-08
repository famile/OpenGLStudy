//
//  ViewController.m
//  OpenGLStudy
//
//  Created by 李涛 on 2017/8/4.
//  Copyright © 2017年 Tao_Lee. All rights reserved.
//

#import "ViewController.h"
#import "GLESView.h"


@interface ViewController ()
{
    GLESView *_glView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _glView = [[GLESView alloc] initWithFrame:(self.view.bounds)];
    [self.view addSubview:_glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
