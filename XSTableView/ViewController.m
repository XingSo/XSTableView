//
//  ViewController.m
//  XSTableView
//
//  Created by XingSo on 14-3-11.
//  Copyright (c) 2014年 XingSo. All rights reserved.
//

#import "ViewController.h"
#import "XSTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray * data = [NSMutableArray array];
    for (int i = 0 ; i < 5 ; i ++){
        NSMutableArray * row = [NSMutableArray array];
        for (int j = 0 ; j < 5 ; j ++){
            [row addObject:[NSString stringWithFormat:@"%d-%d",i,j]];
        }
        [data addObject:row];
    }
    
    XSTableView * table = [[XSTableView alloc] initWithFrame:CGRectMake(0, 40, 320, 320) data:data xLables:@[@"1",@"2",@"3",@"4",@"5"] yLabels:@[@"a",@"b",@"c",@"d",@"e"]];
    [self.view addSubview:table];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
