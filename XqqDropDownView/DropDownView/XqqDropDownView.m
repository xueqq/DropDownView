//
//  XqqDropDownView.m
//  XqqDropDownView
//
//  Created by xqq on 2018/10/23.
//  Copyright © 2018年 xqq. All rights reserved.
//

#import "XqqDropDownView.h"
@interface XqqDropdownListItem()
///是否选中(用于多选)
@property (nonatomic,assign)BOOL isSelect;
@end
@implementation XqqDropdownListItem
- (instancetype)initWithItem:(NSString*)itemId itemName:(NSString*)itemName {
    self = [super init];
    if (self) {
        _itemId = itemId;
        _itemName = itemName;
    }
    return self;
}
- (instancetype)initWithItemName:(NSString*)itemName {
    self = [super init];
    if (self) {
        _itemId = nil;
        _itemName = itemName;
    }
    return self;
}
@end
///cell的高度
static CGFloat const kItemCellHeight = 44;
///希望最小展示的cell个数(预算kItemCellHeight与自动计算的高度有出入,只能说是希望,除非cell高度主动计算,感觉没必要);
static CGFloat const kMinCount = 5;


@interface XqqDropDownView() <UITableViewDelegate,UITableViewDataSource>
///选择后显示的文本
@property (nonatomic, strong) UILabel *textLabel;
///右侧图标
@property (nonatomic, strong) UIImageView *arrowImg;
///下拉视图容器
@property (nonatomic, strong)UIView *contentView;
///下拉列表
@property (nonatomic,strong)UITableView *tableView;
///添加到window的临时背景图
@property (nonatomic, strong) UIView *backgroundView;
///搜索的数据
@property (nonatomic,strong)NSMutableArray *searchArr;
///显示到界面的数据
@property (nonatomic,strong)NSArray *showArr;
///多选选择的数据
@property (nonatomic,strong,readwrite)NSMutableArray *mutatleArr;

///初始值设置的高度
@property (nonatomic,assign)CGFloat originHeight;
@end
@implementation XqqDropDownView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
        [self setupProperty];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self setupProperty];
    }
    return self;
}
///自动适应好的
-(instancetype)initAutoAdaptHeightFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        _originHeight = frame.size.height;
        [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
        [self setupProperty];
    }
    return self;
}
///监听textLabel文本的改变
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
 
    NSString *str = change[@"new"];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(self.textLabel.frame.size.width , CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size.height + 1;
    NSLog(@"=============%@===%f===========",change,height);
    CGRect frame = self.frame;
    if (height > _originHeight) {
       
        frame.size.height = height;
        self.frame = frame;
    }
    else
    {
        frame.size.height = _originHeight;
        self.frame = frame;
    }
}
///设置UI
-(void)setUI
{
 
    self.userInteractionEnabled = YES;
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.textLabel];
    
    self.arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdownFlag"]];
    self.arrowImg.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.arrowImg];
    /********VFL约束***********/
//    NSString *vArrowVfl = @"V:[_arrowImg]";
//    NSArray *vArrowConstraints= [NSLayoutConstraint constraintsWithVisualFormat:vArrowVfl options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_arrowImg)];
//    [self addConstraints:vArrowConstraints];
    
    NSString *vTextLabelVfl = @"V:|[_textLabel]|";
    NSArray *vTextLabelConstraints= [NSLayoutConstraint constraintsWithVisualFormat:vTextLabelVfl options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)];
    [self addConstraints:vTextLabelConstraints];
    
    NSString *hVfl= @"H:|[_textLabel]-[_arrowImg(12)]-|";
    NSArray *hConstraints= [NSLayoutConstraint constraintsWithVisualFormat:hVfl options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_textLabel,_arrowImg)];
    [self addConstraints:hConstraints];
}
///设置默认属性
- (void)setupProperty {
    ///多选属性
    _isMultableSelect = NO;
    _mutatleArr = [NSMutableArray array];
    ///确定按钮属性
    _btnBackColor = [UIColor blueColor];
    _btnTextColor = [UIColor whiteColor];
    ///下拉框属性
    _listViewBackColor = [UIColor clearColor];
    _listViewtextColor = [UIColor blackColor];
    ///是否可筛选
    _isSearch = NO;
    ///显示view的属性(即选择后展示在界面的view)
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:15];
    _isSelectedFirst = NO;
    _textLabel.font = _font;
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.text = @"---请选择---";
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    _textLabel.userInteractionEnabled = YES;
    [_textLabel addGestureRecognizer:tapLabel];
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    _arrowImg.userInteractionEnabled = YES;
    [_arrowImg addGestureRecognizer:tapImg];
}
///设置字体
-(void)setFont:(UIFont *)font
{
    _font = font;
    self.textLabel.font = font;
}
-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    _showArr = dataSource;
}
///是否可以搜索
-(void)setIsSearch:(BOOL)isSearch
{
    _isSearch = isSearch;
    self.searchArr = [NSMutableArray array];
}
- (void)rotateArrowImage {
    // 旋转箭头图片
    _arrowImg.transform = CGAffineTransformRotate(_arrowImg.transform, M_PI);
}
#pragma mark - Events点击展开
-(void)tapViewExpand:(UITapGestureRecognizer *)sender {
    
    if (self.dataSource.count == 0) {
        NSLog(@"=============请先设置数据源==============");
        return;
    }
    if (self.isAlwaysNewDropView) {

        self.contentView = nil;
        _showArr = self.dataSource;
        ///将选择的数据标志清空
        for (XqqDropdownListItem *item in self.mutatleArr) {
            item.isSelect = NO;
        }

    }
    [self rotateArrowImage];

    ///显示cell的个数
    NSInteger count = _dataSource.count > kMinCount ? kMinCount : _dataSource.count;
    CGFloat viewHight = count * kItemCellHeight + (self.isSearch ? 36 :0);
    ///将视图添加到window上
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    [window addSubview:self.contentView];
    // 获取按钮在屏幕中的位置
    CGRect frame = [self convertRect:self.bounds toView:window];
    CGFloat viewY = frame.origin.y + frame.size.height;
    CGRect viewFrame;
    viewFrame.size.width = frame.size.width;
    viewFrame.size.height = viewHight;
    viewFrame.origin.x = frame.origin.x;
    if (viewY + viewHight < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        viewFrame.origin.y = viewY;
    }else {
        viewFrame.origin.y = frame.origin.y - viewHight;
        
    }
    /******简单的显示动画*********/
    CGRect rect = viewFrame;
    rect.size.height = 0;
    _contentView.frame = rect;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = viewFrame;
    }];

    UITapGestureRecognizer *tagBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewDismiss:)];
    [_backgroundView addGestureRecognizer:tagBackground];
}
///下拉容器
-(UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor colorWithRed:0xc8 / 255.0 green:0xc8 / 255.0 blue:0xc8 / 255.0 alpha:1.0];
        /********搜索框*********/
        UITextField *tf = [[UITextField alloc] init];
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        tf.placeholder = @"请输入搜索关键字";
        [_contentView addSubview:tf];
        tf.translatesAutoresizingMaskIntoConstraints = NO;
        /*******下拉列表*********/
        UITableView *tableView = [[UITableView alloc] init];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.shadowOffset = CGSizeMake(4, 4);
        tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        tableView.layer.shadowOpacity = 0.8;
        tableView.layer.shadowRadius = 4;
        tableView.layer.borderColor = [UIColor grayColor].CGColor;
        tableView.layer.borderWidth = 0.5;

        self.tableView = tableView;
        [_contentView addSubview:tableView];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        ///确定按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitleColor:_btnTextColor forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.backgroundColor = _btnBackColor;
        [button addTarget:self action:@selector(mutableSelectOK:) forControlEvents:UIControlEventTouchUpInside];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:button];

        
        NSDictionary *views = NSDictionaryOfVariableBindings(tf,tableView,button);
        /********VFL约束***********/
        NSString *vVfl = @"V:|-space-[tf(tfH)]-space-[tableView][button(btnH)]|";

        NSMutableDictionary *metrics = [NSMutableDictionary dictionary] ;
        if (_isSearch) {
            [metrics setObject:@(4) forKey:@"space"];
            [metrics setObject:@(36) forKey:@"tfH"];
        }
        else
        {
            [metrics setObject:@(0) forKey:@"space"];
            [metrics setObject:@(0) forKey:@"tfH"];
        }
        if (_isMultableSelect) {
            
            [metrics setObject:@(36) forKey:@"btnH"];
        }
        else
        {
            [metrics setObject:@(0) forKey:@"btnH"];
        }
        NSArray *vConstraints= [NSLayoutConstraint constraintsWithVisualFormat:vVfl options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views];
        [_contentView addConstraints:vConstraints];
        
        NSString *hTfVfl ;
        if (_isSearch) {
            hTfVfl = @"H:|-4-[tf]-4-|";
        }
        else
        {
            hTfVfl = @"H:|[tf]|";
        }
        NSArray *hTfConstraints= [NSLayoutConstraint constraintsWithVisualFormat:hTfVfl options:kNilOptions metrics:nil views:views];
        [_contentView addConstraints:hTfConstraints];
        
        NSString *hTableVfl = @"H:|[tableView(==button)]|";
        NSArray *hTableConstraints= [NSLayoutConstraint constraintsWithVisualFormat:hTableVfl options:kNilOptions metrics:nil views:views];
        [_contentView addConstraints:hTableConstraints];
        
    }
    return _contentView;
}
///确定按钮(多项选择)
-(void)mutableSelectOK:(UIButton *)btn
{
    ///点击确定移除下拉框
    [self removeBackgroundView];
    NSMutableArray *indexArr = [NSMutableArray arrayWithCapacity:self.mutatleArr.count];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:self.mutatleArr.count];
    for (XqqDropdownListItem *item in self.mutatleArr) {
        [indexArr addObject:@([self.dataSource indexOfObject:item])];
        [nameArr addObject:item.itemName];
    }
    self.textLabel.text = [nameArr componentsJoinedByString:@","];
    _textLabel.textColor = _textColor;

    if (_delegate) {
        [_delegate dropView:self didMutableSelectRowAtArray:indexArr];
    }
}
///搜索框文本改变
-(void)textChange:(UITextField*)tf
{
    NSLog(@"==========搜索%@==========",tf.text);
    if(tf.text.length == 0)
    {
        _showArr = self.dataSource;
        [self.tableView reloadData];
        return;
    }
    [_searchArr removeAllObjects];
    ///添加符合条件的搜索列表
    for (XqqDropdownListItem *item in self.dataSource) {
        
        if (NSClassFromString(@"UIAlertController")) { // 存在这个类
            // iOS 8.0 以上系统的处理
            if ([item.itemName containsString:tf.text]) {
                [_searchArr addObject:item];
            }
        } else {
            // iOS 8.0 以下系统的处理
            if ([item.itemName rangeOfString:tf.text].location != NSNotFound) {
                [_searchArr addObject:item];
            }
        }
   
    }
   
    ///刷新列表
    _showArr = _searchArr;
    [self.tableView reloadData];
}

- (UIView*)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tagBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewDismiss:)];
        [_backgroundView addGestureRecognizer:tagBackground];
    }
    return _backgroundView;
}
-(void)tapViewDismiss:(UITapGestureRecognizer *)sender {
    [self removeBackgroundView];
}
- (void)removeBackgroundView {

    [_backgroundView removeFromSuperview];

    [self.contentView removeFromSuperview];
    [self rotateArrowImage];
}

///单选选中
- (void)selectedItemAtIndex:(NSInteger)index {
   
    if (index < _showArr.count) {
        XqqDropdownListItem *item = _showArr[index];
        _selectedItem = item;
        _textLabel.text = item.itemName;
        _textLabel.textColor = _textColor;
    }
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = _listViewBackColor;
    cell.textLabel.font = _font;
    cell.textLabel.textColor = _textColor;
    XqqDropdownListItem *item = _showArr[indexPath.row];
    cell.textLabel.text = item.itemName;
    if (self.isMultableSelect) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (item.isSelect) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (_isMultableSelect) {
        ///多选
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        XqqDropdownListItem *item = _showArr[indexPath.row];
        item.isSelect = !item.isSelect;
        if (item.isSelect) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if ([_mutatleArr containsObject:item]) {
                return;
            }
            [_mutatleArr addObject:item];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_mutatleArr removeObject:item];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ///单选
        [self selectedItemAtIndex:indexPath.row];
        [self removeBackgroundView];
        if (self.delegate) {
            [_delegate dropView:self didSelectRowAtIndex:[self.dataSource indexOfObject:self.selectedItem]];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArr.count;
}


@end
