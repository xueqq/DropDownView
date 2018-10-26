//
//  XqqDropDownView.h
//  XqqDropDownView
//
//  Created by xqq on 2018/10/23.
//  Copyright © 2018年 xqq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*********下拉框数据类**************/
@interface XqqDropdownListItem : NSObject
@property (nonatomic, copy, readonly) NSString * __nullable itemId;
@property (nonatomic, copy, readonly) NSString *itemName;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithItem:(NSString*)itemId itemName:(NSString*)itemName NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItemName:(NSString*)itemName NS_DESIGNATED_INITIALIZER;
@end

@class XqqDropDownView;
@protocol XqqDropDownViewDelete <NSObject>

@optional
///下来框点击回调
- (void)dropView:(XqqDropDownView *)dropView didSelectRowAtIndex:(NSInteger)index;
- (void)dropView:(XqqDropDownView *)dropView didMutableSelectRowAtArray:(NSArray<NSNumber*>*)array;

@end
@interface XqqDropDownView : UIView

///下拉框背景色
@property (nonatomic, strong) UIColor *listViewBackColor;
// 下拉框字体颜色，默认 blackColor
@property (nonatomic, strong) UIColor *listViewtextColor;
///确定按钮文本颜色
@property (nonatomic, strong) UIColor *btnTextColor;
///确定按钮背景颜色
@property (nonatomic, strong) UIColor *btnBackColor;
// 字体颜色，默认 blackColor
@property (nonatomic, strong) UIColor *textColor;
// 字体默认15
@property (nonatomic, strong) UIFont *font;
// 数据源
@property (nonatomic, strong) NSArray *dataSource;
// 是否默认选中第一个
@property (nonatomic, assign) BOOL isSelectedFirst;
// 是否有搜索框
@property (nonatomic, assign) BOOL isSearch;

// 当前选中的DropdownListItem
@property (nonatomic, strong, readonly) XqqDropdownListItem *selectedItem;
///多选选择的数据
@property (nonatomic, strong, readonly)NSMutableArray<XqqDropdownListItem*> *mutatleArr;
///点击代理
@property (nonatomic,weak)id<XqqDropDownViewDelete>delegate;
////是否每次点击显示的下拉框都是原始状态
@property (nonatomic,assign)BOOL isAlwaysNewDropView;

///是否支持多选
@property (nonatomic,assign)BOOL isMultableSelect;

///自动适应高度
-(instancetype)initAutoAdaptHeightFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
