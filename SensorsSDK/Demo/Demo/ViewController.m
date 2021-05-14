//
//  ViewController.m
//  Demo
//
//  Created by hx on 2021/2/7.
//

#import "ViewController.h"
#import "TargetProxy.h"


@interface ViewController ()

@end

@implementation ViewController


//·使用Storyboard。 ·使用Nib文件。 ·使用代码，即重写-loadView。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 120, 40)];
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.text = @"购买";
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame), 120, 40)];
    label.text = @"登录";
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick)];
    [label addGestureRecognizer:tap];
}

- (void)buttonClick{
    
}

- (void)labelClick{
   
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"124";
        cell.detailTextLabel.text = @"ssss";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self testTargetProxy];
}

- (void)testTargetProxy {
    
    // 创建一个NSMutableString的对象
    NSMutableString *string = [NSMutableString string]; // 创建一个NSMutableArray的对象
    NSMutableArray *array = [NSMutableArray array];
    
    // 创建一个委托对象来包装真实的对象
    id proxy = [[TargetProxy alloc] initWithObject1:string object2:array]; // 通过委托对象调用NSMutableString类的方法
    [proxy appendString:@"This "];
    [proxy appendString:@"is "];
    
    // 通过委托对象调用NSMutableArray类的方法
    [proxy addObject:string];
    [proxy appendString:@"a "];
    [proxy appendString:@"test!"];
    
    // 使用valueForKey: 方法获取字符串的长度
    NSLog(@"The string's length is: %@", [proxy valueForKey:@"length"]);
    NSLog(@"count should be 1, it is: %ld", [proxy count]);
    
    if ([[proxy objectAtIndex:0] isEqualToString:@"This is a test!"]) {
        NSLog(@"Appending successful.");
    } else {
        NSLog(@"Appending failed, got: '%@'", proxy);
    }
        
}
//UIGestureRecognizer是 一个手势识别器的抽象基类，它定义了一组手势识别器常见行为，还支持 通过设置委托(即实现UIGestureRecognizerDelegate协议的对象)，对某些 行为进行更细粒度的定制。
//手势识别器也使用了Target-Action设 计模式。当我们为一个手势识别器添加一个或多个Target-Action后，在视 图上进行触摸操作时，一旦系统识别了该手势，就会向所有的Target(对 象)发送消息，并执行Action(方法)。虽然手势操作和UIControl类一 样，都使用了Target-Action设计模式，但是手势识别器并不会将消息交由 UIApplication对象来发送。
//因此，我们无法使用与UIControl控件相同的处 理方式，即无法通过响应者链的方式来实现手势操作的全埋点。
//UIGestureRecognizer是一个抽象基类，所以它并不会处理具体的 手势。因此，对于轻拍(UITapGestureRecognizer)、长按 (UILongPressGestureRecognizer)等具体的手势触摸事件，需要使用相应 的子类即具体的手势识别器进行处理。
//常见的具体手势识别器有如下几类。
//·UITapGestureRecognizer:轻拍手势
//·UILongPressGestureRecognizer:长按手势
//·UIPinchGestureRecognizer:捏合(缩放)手势
//·UIRotationGestureRecognizer:旋转手势
//·UISwipeGestureRecognizer:轻扫手势
//·UIPanGestureRecognizer:平移手势
//·UIScreenEdgePanGestureRecognizer:屏幕边缘平移手势

//对于任何一个手势，其实都有不同的状态，比如:
//·UIGestureRecognizerStateBegan ·UIGestureRecognizerStateChanged ·UIGestureRecognizerStateEnded




//使用Method Swizzling交换方法，其实就是修改了objc_method 结构体中的mthod_imp，即改变了method_name和method_imp的映 射关系

@end

/*
 Background Modes
 后台刷新功能,系统会触发APP启动并同时让其进入后台运行(被动启动)
 
 ·Location updates:在该模式下，由于地理位 置变化而触发应用程序启动。
 ·Newsstand downloads:该模式只针对报刊杂 志类应用程序，当有新的报刊可下载时，触发应 用程序启动。
 ·External accessory communication:在该模式 下，一些MFi外设通过蓝牙或者Lightning接头等方 式与iOS设备连接，从而可在外设给应用程序发送 消息时，触发对应的应用程序启动。
 ·Uses Bluetooth LE accessories:该模式与 External Accessory communication类似，只是无须 限制MFi外设，而需要Bluetooth LE(低功耗蓝 牙)设备。
 ·Acts as a Bluetooth LE accessory:在该模式 下，iPhone设备作为一个蓝牙外设连接，可以触发 应用程序启动。
 ·Background fetch:在该模式下，iOS系统会 在一定的时间间隔内触发应用程序启动，进而获 取应用程序数据。
 ·Remote notifications:该模式支持静默推送， 当应用程序收到静默推送后，不会有任何界面提 示，但会触发应用程序启动。
 
 */
