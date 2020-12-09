//
//  ViewController.m
//  iOS
//
//  Created by cyzone on 2019/6/5.
//  Copyright © 2019 CYZone. All rights reserved.
//

#import "ViewController.h"
#import "IOPSKeys.h"
#import "IOPowerSources.h"
#import <mach/mach.h>
#import "BlockViewController.h"

#define CPUMONITORRATE 90

@interface ViewController ()

@property(nonatomic, strong) NSTimer *timer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkAndMonitorBatteryLevel];
   
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateCPUInfo:) userInfo:nil repeats:YES];
}

#pragma mark - 监控CPU使用
- (void)updateCPUInfo:(NSTimer *)timer{
    
    thread_act_array_t  threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    //获取所有线程信息的数组
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    
    //查看cpu使用百分比
    if (kr != KERN_SUCCESS) {
        return;
    }
    
    for (int i = 0; i < threadCount; i ++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadCount)) {
            
            threadBaseInfo = (thread_basic_info_t)threadInfo;//获取线程信息
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10; // CPU最大usage为1000，因此除10即可获得CPU当前的利用率。
                if (cpuUsage > CPUMONITORRATE) { // 超过设定的阈值时，记录堆栈
                    //cup 消耗大于设置值时打印和记录堆栈
                    NSString *reStr = @"";
                    
                    //记录数据库中....
                    NSLog(@"CPU useage overload thread stack：\n%@",reStr);
                }
            }
        }
    }
    
}

/**
struct thread_basic_info {
    time_value_t    user_time;      user 运行的时间
    time_value_t    system_time;    系统运行的时间
    integer_t       cpu_usage;      CPU使用的百分比
    policy_t        policy;         有效的计划策略
    integer_t       run_state;      run state (see below)
    integer_t       flags;          various flags (see below)
    integer_t       suspend_count;  suspend count for thread
    integer_t       sleep_time;     休眠时间
};
**/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    double level = [self getBatteryLevel];
    NSLog(@"%f",level);
    
    BlockViewController *blockVc = [[BlockViewController alloc]init];
    [self.navigationController pushViewController:blockVc animated:YES];
}


#pragma mark - 电池电量获取及监控
- (void)checkAndMonitorBatteryLevel{
    
    //拿到当前设备
    UIDevice * device = [UIDevice currentDevice];
    
    //是否允许监测电池
    //要想获取电池电量信息和监控电池电量 必须允许
    device.batteryMonitoringEnabled = true;
    
    //1、check
    /*
     获取电池电量
     0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
     */
    float level = device.batteryLevel;
    NSLog(@"level = %lf",level);
    
    //2、monitor
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryLevel:) name:UIDeviceBatteryLevelDidChangeNotification object:device];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryState:) name:UIDeviceBatteryStateDidChangeNotification object:device];
    
}

// 电量变化
- (void)didChangeBatteryLevel:(id)sender{
    //电池电量发生改变时调用
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    float batteryLevel = [myDevice batteryLevel];
    NSLog(@"电池剩余比例：%@", [NSString stringWithFormat:@"%f",batteryLevel*100]);
}

///电池状态
- (void)didChangeBatteryState:(NSNotification *)notification{
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    NSLog(@"%ld",[myDevice batteryState]);
}


- (double)getBatteryLevel{
    
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    int numOfSources = (int)(CFArrayGetCount(sources));
    if (numOfSources == 0) {
        NSLog(@"Error in CFArrayGetCount!");
        return -1.0f;
    }
    
    for (int i = 0 ; i < numOfSources; i++) {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            NSLog(@"Error in IOPSGetPowerSourceDescription!");
            return -1.0f;
        }
        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
        
        int currentCapacity  = 0;
        int maxCapacity = 0;
        double percentage;
        int designCapacity = 0;
        
        psValue  =  CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &currentCapacity);
        
        psValue  =  CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        percentage = ((double)currentCapacity / (double)maxCapacity * 100.0f);
        
        NSLog(@"curCapacity:%d / maxCapacity:%d ,percentage:%.1f",currentCapacity,maxCapacity,percentage);
        
        
        //设计容量
//        psValue  =  CFDictionaryGetValue(pSource, CFSTR(kIOPSDesignCapacityKey));
//        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &designCapacity);
//        NSLog(@"设计容量: %d",designCapacity);
        
        //kIOPSNominalCapacityKey
        return percentage;
    }
    return -1;
}

//"Battery Provides Time Remaining" = 1;
//BatteryHealth = "Check Battery";
//"Current Capacity" = 93;
//"Is Charging" = 1;
//"Is Finishing Charge" = 0;
//"Is Present" = 1;
//"Max Capacity" = 100;
//Name = "InternalBattery-0";
//"Power Source ID" = 2162787;
//"Power Source State" = "AC Power";
//"Raw External Connected" = 1;
//"Show Charging UI" = 1;
//"Time to Empty" = 0;
//"Time to Full Charge" = 0;
//"Transport Type" = Internal;
//Type = InternalBattery;

- (void)dispatch_demo{
    
    //这种 QoS 系统会针对大的计算，I/O，网络以及复杂数据处理做电量优化。
    dispatch_block_t block = dispatch_block_create_with_qos_class(0, QOS_CLASS_UTILITY, 0, ^{
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}

@end
