//
//  BlockViewController.m
//  iOS
//
//  Created by cyzone on 2020/1/7.
//  Copyright © 2020 CYZone. All rights reserved.
//

#import "BlockViewController.h"





@interface BlockViewController ()

@property(nonatomic, strong) dispatch_semaphore_t semaphore;

@end


@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"%@",[NSThread currentThread]);
    
    [self testDispatchBlock];
}



- (void)testDispatchBlock{
    
    //使用信号量实现任务依赖
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t  sema = dispatch_semaphore_create(0);//初始值为0
    //任务A:
    dispatch_async(queue, ^{
        NSLog(@"Task A begin");
        sleep(1);
        NSLog(@"Task A finished!");
        dispatch_semaphore_signal(sema); //释放信号量
    });
    
    //任务B
    dispatch_async(queue, ^{
        //等待任务A释放信号量
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSLog(@"Task B begin");
        sleep(1);
        NSLog(@"Task B finished!");
    });
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    for (int i = 0; i < 10; i ++) {
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//            sleep(3);
//            NSLog(@"%d finished!",i);
//            dispatch_semaphore_signal(self.semaphore);
//        });
//    }
//
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //重新赋值或者重置为nil,都会造成崩溃,因为信号量还在使用中.
//    sema = dispatch_semaphore_create(0);
//    sema = nil;
    
    
}



@end
