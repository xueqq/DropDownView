//
//  ViewController.m
//  XqqDropDownView
//
//  Created by xqq on 2018/10/23.
//  Copyright © 2018年 xqq. All rights reserved.
//

#import "ViewController.h"
#import "XqqDropDownView.h"
@interface ViewController ()<XqqDropDownViewDelete>
@property (weak, nonatomic) IBOutlet XqqDropDownView *dropDown;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XqqDropdownListItem *item1 = [[XqqDropdownListItem alloc] initWithItem:@"1" itemName:@"item1"];
    XqqDropdownListItem *item2 = [[XqqDropdownListItem alloc] initWithItem:@"2" itemName:@"item2"];
    XqqDropdownListItem *item3 = [[XqqDropdownListItem alloc] initWithItem:@"3" itemName:@"item3"];
    XqqDropdownListItem *item4 = [[XqqDropdownListItem alloc] initWithItem:@"4" itemName:@"item4"];

    _dropDown.dataSource = @[item1, item2, item3, item4];
    _dropDown.isSearch = YES;
    _dropDown.isAlwaysNewDropView = YES;
    _dropDown.isMultableSelect = YES;
    _dropDown.delegate = self;
    
    /*******代码创建控件********/
    XqqDropdownListItem *item5 = [[XqqDropdownListItem alloc] initWithItem:@"1" itemName:@"选项q123456789item1234567890"];
    XqqDropdownListItem *item6 = [[XqqDropdownListItem alloc] initWithItem:@"2" itemName:@"选项q123456789item1234567890"];
    XqqDropdownListItem *item7 = [[XqqDropdownListItem alloc] initWithItem:@"3" itemName:@"选项q123456789item1234567890"];
    XqqDropdownListItem *item8 = [[XqqDropdownListItem alloc] initWithItem:@"4" itemName:@"选项q123456789item1234567890"];
    XqqDropDownView *drop = [[XqqDropDownView alloc] initAutoAdaptHeightFrame:CGRectMake(50, 90, 200, 50)];
    drop.dataSource =@[item5, item6, item7, item8];
    drop.isAlwaysNewDropView = YES;
    drop.isMultableSelect = YES;
    [self.view addSubview:drop];
}
- (void)dropView:(XqqDropDownView *)dropView didMutableSelectRowAtArray:(NSArray<NSNumber*>*)array
{
    NSLog(@"%@",array);
}
- (void)dropView:(XqqDropDownView *)dropView didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}
@end
