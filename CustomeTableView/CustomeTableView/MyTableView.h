//
//  MyTableView.h
//  CustomeTableView
//
//  Created by cyzone on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MyTableViewDataSource <NSObject>

@required
- (NSUInteger)numberOfRows;
- (UIView *)cellForRow:(NSUInteger)row;

@optional
- (CGFloat)rowHeight;

@end

@interface MyTableView : UIScrollView

//数据源
@property(nonatomic, weak) id <MyTableViewDataSource>dataSource;

/// 获取一个重用的单元格
- (UIView *)dequeueReusableCell;

@end

NS_ASSUME_NONNULL_END
