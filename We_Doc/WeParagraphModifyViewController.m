//
//  WeParagraphModifyViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeParagraphModifyViewController.h"

@interface WeParagraphModifyViewController () {
    UITextView * textView;
}

@end

@implementation WeParagraphModifyViewController

@synthesize stringToModify;
@synthesize stringToPlaceHolder;
@synthesize stringToBeTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 初始化输入框
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + 20, 320, 200)];
    textView.text = stringToModify;
    textView.font = We_font_textfield_zh_cn;
    [self.view addSubview:textView];
    
    // 保存按钮
    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton_onPress:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // 标题
    self.navigationItem.title = stringToBeTitle;
    
    [textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButton_onPress:(id)sender {
    [stringToModify setString:textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
