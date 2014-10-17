//
//  WeAboutUsViewController.m
//  AplusDr
//
//  Created by ejren on 14-10-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeAboutUsViewController.h"
#import "WeAppDelegate.h"
#import "WeNavViewController.h"
#import "WeAboutDownViewController.h"
#import "WeUserAgreeViewController.h"

@interface WeAboutUsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *aboutTableview;
    NSString *appVersion ;
}
@end

@implementation WeAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=@"关于医家仁";
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    aboutTableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    aboutTableview.backgroundColor=[UIColor clearColor];
    aboutTableview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    aboutTableview.delegate = self;
    aboutTableview.dataSource = self;
    aboutTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    aboutTableview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:aboutTableview];
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    headview.backgroundColor=[UIColor clearColor];
    //Icon-40
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 25, 60, 60)];
    icon.image=[UIImage imageNamed:@"Untitled-1"];
    
    UILabel *labe=[[UILabel alloc]initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, 45)];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    labe.text=[NSString stringWithFormat:@"医家仁医生版 %@",appVersion];
    labe.textAlignment=NSTextAlignmentCenter;
    labe.textColor=We_foreground_black_general;
    labe.font=[UIFont systemFontOfSize:20];
    [headview addSubview:icon];
    [headview addSubview:labe];
    
    
    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    bottomview.backgroundColor=[UIColor clearColor];
    
    UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame=CGRectMake(self.view.frame.size.width/2-80, 40, 160, 20);
    [butt setFont:[UIFont systemFontOfSize:14]];
    [butt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [butt setTitle:@"医家仁隐私条款" forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(yinsitiaokuan) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:butt];
    
    UILabel *la1=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 80)];
    la1.textColor=[UIColor grayColor];
    la1.font=[UIFont systemFontOfSize:15];
    la1.textAlignment=NSTextAlignmentCenter;
    [bottomview addSubview:la1];
    la1.numberOfLines=0;
    la1.text=@"睿医惠众信息咨询有限公司 版权所有\n© 2014 ejren.com A+Dr. All rights reserved.";
    
    aboutTableview.tableHeaderView=headview;
    aboutTableview.tableFooterView=bottomview;
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"附近好友下载";
            break;
        case 1:
            cell.textLabel.text=@"检查更新";
            break;
        case 2:
            cell.textLabel.text=@"关于我们";
            break;
            
        default:
            break;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        WeAboutDownViewController *down=[[WeAboutDownViewController alloc]init];
        WeNavViewController *nav=[[WeNavViewController alloc]initWithRootViewController:down];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    }
    if (indexPath.row==1) {
        if (![we_appVersion isEqualToString:appVersion]) {
            UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"有新版本，是否现在更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [alter show];
        }
        else
        {
            UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最新的版本" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alter show];

        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)yinsitiaokuan
{
    WeUserAgreeViewController *useraggree=[[WeUserAgreeViewController alloc]init];
    useraggree.aggreeUrl=@"http://www.ejren.com/docs/privacy.txt";
    useraggree.title=@"隐私条款";
    WeNavViewController *nav=[[WeNavViewController alloc]initWithRootViewController:useraggree];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/yi-jia-ren-yi-sheng-ban/id909355061";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
@end
