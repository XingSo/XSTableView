//
//  XSTableView.h
//  XSTableView
//
//  Created by XingSo on 14-3-11.
//  Copyright (c) 2014年 XingSo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSTableViewCellBtn : UIButton

@property NSInteger row;
@property NSInteger col;

@end

typedef NS_ENUM(NSInteger, XSTableViewScrollDirection) {
    XSTableViewScrollDirectionUp,
    XSTableViewScrollDirectionDown
};

@protocol XSTableViewDelegate <NSObject>

- (void)XSTableViewDidScrollToDirection:(XSTableViewScrollDirection)direction;
- (void)XSTableViewClickCellInRow:(NSInteger)row col:(NSInteger)col;

@end

@interface XSTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property NSArray * datas;// @[@[@"sdf",@"sdf",...],@[@"sdf",@"sdf",...],...]
@property NSArray * xLabels ; // @[@"",@"",..]
@property NSArray * yLabels ; // @[@"",@"",..]

@property id<XSTableViewDelegate> delegate;



- (id)initWithFrame:(CGRect)frame data:(NSArray *)data xLables:(NSArray *)xName yLabels:(NSArray *)yName;

@end
