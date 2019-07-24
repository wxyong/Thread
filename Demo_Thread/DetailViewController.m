  //
  //  DetailViewController.m
  //  Demo_Thread
  //
  //  Created by aimee on 2019/7/24.
  //  Copyright © 2019 taikang. All rights reserved.
  //

#import "DetailViewController.h"
#import "XYThread.h"

@interface DetailViewController ()
@property (nonatomic, strong) XYThread *thread;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL shouldRun;
@end

@implementation DetailViewController

- (void)dealloc {
  NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = UIColor.cyanColor;
  
  self.thread = [[XYThread alloc] initWithTarget:self selector:@selector(run:) object:@"123"];
  [self.thread start];
}

- (void)run:(id)object {
  NSLog(@"run %@ %@", object, [NSThread currentThread]);
  
  NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
  [currentRunLoop addPort:[NSPort port] forMode:NSRunLoopCommonModes]; // 添加 Port，RunLoop 保活
  
  NSLog(@"runloop run begin");
  
//  [currentRunLoop run]; // 这样无法停止
  self.shouldRun = YES;
  // 必须运行在 NSDefaultRunLoopMode 模式下。 NSRunLoopCommonModes 会导致 run 失败，直接走 runloop run over，后续添加到线程中的任务无法被执行，导致 RunLoop 无法停止， self 无法释放。
  while (self.shouldRun && [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
    NSLog(@"Running");
  };
  
  NSLog(@"runloop run over");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self performSelector:@selector(task) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)task {
  NSLog(@"alive");
//  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//    NSLog(@"timer running");
//  }];
//  [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
  CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  if (parent == nil) {
    [self.timer invalidate];
    self.shouldRun = NO;
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:NO];
  }
}

@end
