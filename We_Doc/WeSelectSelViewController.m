//
//  WeSelectSelViewController.m
//  We_Doc
//
//  Created by ejren on 14-9-29.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeSelectSelViewController.h"
#import "WeAppDelegate.h"
@interface WeSelectSelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *sys_tableView;
    NSArray *dataArray;
    
    NSDictionary * dataDic;
}
@end

@implementation WeSelectSelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    we_codings[@"doctorCategory"];
//    currentUser.category
//    currentUser.title
    dataDic=we_codings[@"doctorCategory"][currentUser.category][@"title"];
    dataArray=[we_codings[@"doctorCategory"][currentUser.category][@"title"] allKeys];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-49) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifi=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifi];
    cell.contentView.backgroundColor = We_background_cell_general;
    cell.textLabel.font = We_font_textfield_zh_cn;
    cell.textLabel.textColor = We_foreground_black_general;
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifi];
    }
    cell.textLabel.text=dataDic[dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegrate respondsToSelector:@selector(selectInTableView:sele:)]) {
        [self.delegrate selectInTableView:dataDic[dataArray[indexPath.row]] sele:dataArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
