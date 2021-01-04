//
//  TestViewController.m
//  Demo
//
//  Created by hx on 2020/12/31.
//

#import "TestViewController.h"
#import "SPSVGAPlayerView.h"

@interface TestViewController ()<SPSVGAPlayerParserProtocol>

@property(nonatomic, strong) SPSVGAPlayerView *player;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI{
    
    self.player = [[SPSVGAPlayerView alloc]initWithFrame:CGRectMake(20, 200, UIScreen.mainScreen.bounds.size.width - 40, 400) parseWithNamed:@"heartbeat" loops:0];
    self.player.parseDelegate = self;
    [self.view addSubview:self.player];
    
    
}

- (void)spsvgaPlayerParserWillParser:(SPSVGAPlayerView *)player{
    
    NSLog(@"spsvgaPlayerParserWillParser");
}

- (void)spsvgaPlayerParserLoadFailureParser:(SPSVGAPlayerView *)player error:(NSError *)error{
    
    NSLog(@"spsvgaPlayerParserLoadFailureParser:");
}

- (void)spsvgaPlayerParserDidLoadParser:(SPSVGAPlayerView *)player{
    
    NSLog(@"spsvgaPlayerParserDidLoadParser:");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.player setAnimationNamed:@"c"];
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
