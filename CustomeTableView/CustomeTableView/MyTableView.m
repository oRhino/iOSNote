//
//  MyTableView.m
//  CustomeTableView
//
//  Created by cyzone on 2020/12/10.
//

#import "MyTableView.h"

@interface MyTableView(){
    NSMutableSet *_reuseCells; //复用池中的cell
    NSMutableSet *_usedCells;  //使用中的cell
}

@end

@implementation MyTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _reuseCells = [NSMutableSet new];
        _usedCells = [NSMutableSet new];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshView];
}


- (void)refreshView{
    
    //内容视图总大小
    self.contentSize = CGSizeMake(self.bounds.size.width, [self getRowHeight] * [self.dataSource numberOfRows]);
    
    for (UIView *cell in [self cellSubViews]) {
        //滑出顶部的cell
        if (cell.frame.origin.y + cell.frame.size.height < self.contentOffset.y) {
            [self recycleCell:cell]; //回收到复用池
        }
        //底部没有出现的cell
        if (cell.frame.origin.y > self.contentOffset.y + self.frame.size.height) {
            [self recycleCell:cell]; //回收到复用池
        }
    }
    
    //确保每一行都有一个单元格
    //可见范围
    int firstVisibleIndex = MAX(0, floor(self.contentOffset.y / [self getRowHeight]));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisibleIndex + 1 + ceil(self.frame.size.height / [self getRowHeight]));
    
    
    //添加cell
    for (int row = firstVisibleIndex; row < lastVisibleIndex; row ++) {
        //获得cell
        UIView * cell = [self cellForRow:row];
        
        if (!cell) {
            //如果cell不存在（没有复用的cell），则创建一个新的cell添加到scrollView中
            UIView *cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * [self getRowHeight];
            cell.frame = CGRectMake(0, topEdgeForRow, self.frame.size.width, [self getRowHeight]);
            [self insertSubview:cell atIndex:0];
        }
    }
}


- (NSArray *)cellSubViews{
    return _usedCells.allObjects;
}

//通过添加一组复用单元格，并从视图中删除它来循环单元格
- (void)recycleCell:(UIView *)cell{
    [_reuseCells addObject:cell];
    [_usedCells removeObject:cell];
    [cell removeFromSuperview];
}


- (UIView *)cellForRow:(NSInteger)row{
    
    float topEdgeForRow = row * [self getRowHeight];
    for (UIView * cell in [self cellSubViews]) {
        if (cell.frame.origin.y == topEdgeForRow) {
            return cell;
        }
    }
    return nil;
}

- (UIView *)dequeueReusableCell{
    //从复用池里面获取
    UIView *cell = [_reuseCells anyObject];
    if (cell) {
        [_reuseCells removeObject:cell];
    }else{
        //没有就新建
        cell = [[UITableViewCell alloc]initWithFrame:CGRectZero];
    }
    [_usedCells addObject:cell];
    return cell;
}

/// 单元格高度
- (CGFloat)getRowHeight{
    CGFloat height = 44.0f;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(rowHeight)]) {
        height = [self.dataSource rowHeight];
    }
    return height;
}


- (void)setDataSource:(id<MyTableViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self refreshView];
}


@end

//1.自定义UIScollview的子类,添加数据源协议,返回几个cell,获取cell的方法等.
//2.内部维护一个复用池,每次创建cell都优先从复用池里面取,如果没有就新建.
//3.当试图滚动或者刷新的时候,根据UIScollview的offset偏移量计算屏幕顶部之外和屏幕底部之外的cell,将其回收到复用池中,并添加新的cell到可见范围.

