//
//  ViewController.m
//  CustomeTableView
//
//  Created by cyzone on 2020/12/10.
//

#import "ViewController.h"
#import "MyTableView.h"

@interface ViewController ()<MyTableViewDataSource>

@property(nonatomic, strong) MyTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView = [[MyTableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - MyTableViewDataSource
- (NSUInteger)numberOfRows{
    return 30;
}

- (UIView *)cellForRow:(NSUInteger)row{
    UITableViewCell * cell = (UITableViewCell *)[self.tableView dequeueReusableCell];
    cell.textLabel.text = [NSString stringWithFormat:@"row:%lu",(unsigned long)row];
    return cell;
}

- (CGFloat)rowHeight{
    return 55;
}


@end
