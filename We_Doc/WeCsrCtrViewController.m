
//
//  WeCsrCtrViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrCtrViewController.h"
#import "WeAppDelegate.h"
#import "UIBubbleTableView.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@interface WeCsrCtrViewController () {
    UIBubbleTableView * bubbletTableView;
    NSMutableArray * bubbleData;
    NSTimer * timer;
    UIImage * patientAvatar;
    UIImage * doctorAvatar;
    UITextField * inputTextField;
}

@end

@implementation WeCsrCtrViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)refreshPatientAvatar:(UIImage *) avatar {
    for (int i = 0; i < [bubbleData count]; i++) {
        NSBubbleData * bd = bubbleData[i];
        if (bd.type == BubbleTypeSomeoneElse) {
            bd.avatar = avatar;
        }
    }
    [bubbletTableView reloadData];
}

- (void)refreshDoctorAvatar:(UIImage *) avatar {
    for (int i = 0; i < [bubbleData count]; i++) {
        NSBubbleData * bd = bubbleData[i];
        if (bd.type == BubbleTypeMine) {
            bd.avatar = avatar;
        }
    }
    [bubbletTableView reloadData];
}

- (void)refreshMessage:(id)sender {
    bubbleData = [[NSMutableArray alloc] init];
    //NSLog(@"!!! %@ %@", we_messagesWithPatient, we_patient_chating);
    NSLog(@"%ul", [we_messagesWithPatient[we_patient_chating] count]);
    for (int i = 0; i < [we_messagesWithPatient[we_patient_chating] count]; i++) {
        long long t = [we_messagesWithPatient[we_patient_chating][i][@"time"] longLongValue] / 100;
        NSBubbleData * bubble ;
        if ([[NSString stringWithFormat:@"%@", we_messagesWithPatient[we_patient_chating][i][@"senderId"]] isEqualToString:we_patient_chating]) {
            bubble = [NSBubbleData dataWithText:we_messagesWithPatient[we_patient_chating][i][@"content"] date:[NSDate dateWithTimeIntervalSince1970:t] type:BubbleTypeSomeoneElse];
            bubble.avatar = patientAvatar;
        }
        else {
            bubble = [NSBubbleData dataWithText:we_messagesWithPatient[we_patient_chating][i][@"content"] date:[NSDate dateWithTimeIntervalSince1970:t] type:BubbleTypeMine];
            bubble.avatar = doctorAvatar;
        }
        [bubbleData addObject:bubble];
    }
    [bubbletTableView reloadData];
    [bubbletTableView scrollBubbleViewToBottomAnimated:YES];
}

- (void)sendMessage:(id)sender {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:yijiarenUrl(@"message", @"postMsg") parameters:@{@"m.receiverId":we_patient_chating, @"m.content":inputTextField.text, @"m.type":@"T"}
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             if ([result isEqualToString:@"1"]) {
                 NSLog(@"response : %@", HTTPResponse[@"response"]);
                 //NSLog(@"we_patients : %@", we_patients);
                 NSMutableDictionary * tmp = [[NSMutableDictionary alloc] initWithDictionary:HTTPResponse[@"response"]];
                 tmp[@"time"] = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970] * 100];
                 NSLog(@"%@", tmp);
                 [we_messagesWithPatient[we_patient_chating] addObject:tmp];
                 inputTextField.text = @"";
                 return;
             }
             if ([result isEqualToString:@"2"]) {
                 NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
                 NSEnumerator *enumerator = [fields keyEnumerator];
                 id key;
                 while ((key = [enumerator nextObject])) {
                     NSString * tmp1 = [fields objectForKey:key];
                     if (tmp1 != NULL) errorMessage = tmp1;
                 }
             }
             if ([result isEqualToString:@"3"]) {
                 errorMessage = [HTTPResponse objectForKey:@"info"];
             }
             if ([result isEqualToString:@"4"]) {
                 errorMessage = [HTTPResponse objectForKey:@"info"];
             }
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"发送信息失败"
                                          message:errorMessage
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"发送信息失败"
                                          message:@"未能连接服务器，请重试"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
     ];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    we_patient_chating = [NSString stringWithFormat:@"%@", we_patient_chating];
    
    // Setup freshings
    UIImageView * tmpImageView = [[UIImageView alloc] init];
    [tmpImageView setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:yijiarenAvatarUrl(we_patients[we_patient_chating][@"avatar"])]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self refreshPatientAvatar:image];
        patientAvatar = image;
    } failure:nil];
    
    UIImageView * tmpImageView1 = [[UIImageView alloc] init];
    [tmpImageView1 setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentUser.avatarPath)]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self refreshDoctorAvatar:image];
        doctorAvatar = image;
    } failure:nil];
    
    // Setup Timer
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshMessage:) userInfo:nil repeats:YES];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // Title
    self.navigationItem.title = we_patients[we_patient_chating][@"name"];
    
    // Invisible of tab bar
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    // sys_tableView
    bubbletTableView = [[UIBubbleTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 40 - 10) style:UITableViewStyleGrouped];
    bubbletTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bubbletTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bubbletTableView];
    
    [self refreshMessage:self];
    bubbletTableView.bubbleDataSource = self;
    bubbletTableView.showAvatars = YES;
    
    [bubbletTableView reloadData];
    
    [bubbletTableView scrollBubbleViewToBottomAnimated:YES];
    
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    inputView.backgroundColor = We_background_general;
    
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 240, 26)];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.font = We_font_textfield_zh_cn;
    inputTextField.clipsToBounds = YES;
    inputTextField.layer.cornerRadius = 3.0f;
    
    UIButton * panel1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel1 setFrame:CGRectMake(270, 7, 40, 26)];
    [panel1 setTitle:@"发送" forState:UIControlStateNormal];
    [panel1 addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    panel1.tintColor = We_foreground_white_general;
    panel1.backgroundColor = We_foreground_red_general;
    panel1.titleLabel.font = We_font_textfield_zh_cn;
    panel1.clipsToBounds = YES;
    panel1.layer.cornerRadius = 4.0f;
    [inputView addSubview:panel1];
    
    [inputView addSubview:inputTextField];
    inputTextField.delegate = self;
    
    [self.view addSubview:inputView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    rect.origin.y -= 250;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    rect.origin.y += 250;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

@end
