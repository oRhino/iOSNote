//
//  ViewController.m
//  XCConfigModel
//
//  Created by hx on 2021/2/20.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//Scheme Target Project Configuration Workspace


//1.Configuration的创建
//command + n 搜索 config 选择进行创建

//2.Configuration的设置
//选中Project/Info 默认有debug/release 可以进行添加(scheme),每个schema可以选择对应的configuration文件



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"APURL"]);
    NSLog(@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"APPNAME"]);
    
}


@end
