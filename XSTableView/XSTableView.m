//
//  XSTableView.m
//  XSTableView
//
//  Created by XingSo on 14-3-11.
//  Copyright (c) 2014年 XingSo. All rights reserved.
//

#import "XSTableView.h"

#define XSTableViewCellWidth 80
#define XSTableViewCellHeight 40

@implementation XSTableViewCellBtn

- (id)init
{
    self = [super init];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


@end


@implementation XSTableView
{
    UIScrollView * _rightScrollView;
    UITableView * _rightTableView;
    UITableView * _leftTableView;
    
    float _lastScrollOffset;
    XSTableViewScrollDirection _lastScrollDirection;
}

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data xLables:(NSArray *)xName yLabels:(NSArray *)yName
{
    self = [super initWithFrame:frame];
    if (self) {
        //init data
        _datas = data;
        _xLabels = xName;
        _yLabels = yName;
        
        [self initChildTable];
        
    }
    return self;
}

- (void)initChildTable{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSTableViewCellWidth, self.frame.size.height) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_leftTableView];
    
    
    
    _rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(XSTableViewCellWidth, 0, self.frame.size.width - XSTableViewCellWidth, self.frame.size.height)];
    [self addSubview:_rightScrollView];
    
    
    int maxRowCount = 0;
    for (NSArray * row in self.datas){
        if (maxRowCount < row.count)
            maxRowCount = row.count;
    }
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSTableViewCellWidth * maxRowCount, self.frame.size.height) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightScrollView addSubview:_rightTableView];
    [_rightScrollView setContentSize:_rightTableView.frame.size];
}

- (UIView *)leftTableCellViewInRow:(NSInteger)row{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  _leftTableView.frame.size.width - 5, XSTableViewCellHeight - 2)];
    [btn setTitle:[self.yLabels objectAtIndex:row] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.shadowOffset = CGSizeMake(0,0);
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.2;
    btn.layer.shadowRadius = 3;
    
    return btn;
}

- (UIView *)rightTableCellViewInRow:(NSInteger)row{
    UIView * rightRowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightTableView.frame.size.width, XSTableViewCellHeight)];
    NSArray * rowData = [self.datas objectAtIndex:row];
    
    for (int i = 0 ; i < rowData.count ; i ++){
        XSTableViewCellBtn * btn = [[XSTableViewCellBtn alloc] initWithFrame:CGRectMake(i*XSTableViewCellWidth, 0, XSTableViewCellWidth, XSTableViewCellHeight)];
        btn.row = row;
        btn.col = i;
        [btn setTitle:[rowData objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightRowView addSubview:btn];
    }
    return rightRowView;
}

- (void)clickCellBtn:(XSTableViewCellBtn *)btn{
    NSLog(@"点击了%d行%d列",btn.row,btn.col);
    if ([self.delegate respondsToSelector:@selector(XSTableViewClickCellInRow:col:)]){
        [self.delegate XSTableViewClickCellInRow:btn.row col:btn.col];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView * v in cell.contentView.subviews){
        [v removeFromSuperview];
    }
    
    if ([tableView isEqual:_leftTableView]){
        [cell.contentView addSubview:[self leftTableCellViewInRow:indexPath.row]];
    }
    else{
        [cell.contentView addSubview:[self rightTableCellViewInRow:indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return XSTableViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_leftTableView]){
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _leftTableView.frame.size.width, XSTableViewCellHeight)];
        l.text = @"表头";
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l.backgroundColor = [UIColor colorWithRed:0.5059 green:0.5098 blue:0.5961 alpha:1];
        return l;
    }
    else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightScrollView.frame.size.width, XSTableViewCellHeight)];
        for (int i = 0 ; i < self.xLabels.count ; i ++) {
            UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(XSTableViewCellWidth * i, 0, XSTableViewCellWidth, XSTableViewCellHeight)];
            l.text = [self.xLabels objectAtIndex:i];
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor whiteColor];
            view.backgroundColor = [UIColor colorWithRed:0.5059 green:0.5098 blue:0.5961 alpha:1];
            [view addSubview:l];
        }
        return view;
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scroll direction
    //    NSLog(@"%0.1f - %0.1f",scrollView.contentOffset.y,);
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
        if (_lastScrollOffset < scrollView.contentOffset.y - 5){
            //        NSLog(@"UP");
            if (_lastScrollDirection != XSTableViewScrollDirectionUp){
                //send
                if ([self.delegate respondsToSelector:@selector(XSTableViewDidScrollToDirection:)])
                {
                    [self.delegate XSTableViewDidScrollToDirection:XSTableViewScrollDirectionUp];
                }
                _lastScrollDirection = XSTableViewScrollDirectionUp;
            }
            _lastScrollOffset = scrollView.contentOffset.y;
        }
        else if (_lastScrollOffset > scrollView.contentOffset.y + 5){
            //        NSLog(@"DOWN");
            if (_lastScrollDirection != XSTableViewScrollDirectionDown){
                if ([self.delegate respondsToSelector:@selector(XSTableViewDidScrollToDirection:)])
                {
                    [self.delegate XSTableViewDidScrollToDirection:XSTableViewScrollDirectionDown];
                }
                _lastScrollDirection = XSTableViewScrollDirectionDown;
            }
            _lastScrollOffset = scrollView.contentOffset.y - 5;
        }
    }
    
    
    //synchronize
    if ([scrollView isEqual:_leftTableView]){
        _rightTableView.contentOffset = _leftTableView.contentOffset;
    }
    else{
        _leftTableView.contentOffset = _rightTableView.contentOffset;
    }
}



@end
