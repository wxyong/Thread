//
//  ViewController.m
//  Demo_Thread
//
//  Created by aimee on 2019/7/24.
//  Copyright © 2019 taikang. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = UIColor.greenColor;
}
  
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  DetailViewController *vc = [DetailViewController new];
  [self.navigationController pushViewController:vc animated:true];
}


@end
