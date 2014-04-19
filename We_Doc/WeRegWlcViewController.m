//
//  WeWelcomeViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegWlcViewController.h"
#import "WeAppDelegate.h"

@interface WeRegWlcViewController ()

@end

@implementation WeRegWlcViewController

UITextField * user_phone_input;
UITextField * user_password_input;

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
    
    // view
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]];
    
    // Title
    UILabel * title_en = [[UILabel alloc] initWithFrame:CGRectMake(90, 28, 150, 100)];
    title_en.text = @"A+Dr!";
    [title_en setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:57]];
    [title_en setTextColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]];
    [title_en setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title_en];
    
    UILabel * title_zh = [[UILabel alloc] initWithFrame:CGRectMake(90, 77, 150, 100)];
    title_zh.text = @"医  家  人";
    [title_zh setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    [title_zh setTextColor:[UIColor colorWithRed:134.0/255 green:11.0/255 blue:38.0/255 alpha:0.9]];
    [title_zh setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title_zh];
    
    // user_phone_input
    user_phone_input = [[UITextField alloc] initWithFrame:CGRectMake(-1, 206, 322, 45)];
    user_phone_input.borderStyle = UITextBorderStyleRoundedRect;
    [user_phone_input setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    user_phone_input.layer.borderWidth = 0.2;
    user_phone_input.layer.borderColor=[[UIColor blackColor]CGColor];
    user_phone_input.placeholder = @"手机号码";
    UIImageView * user_phone_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    user_phone_input.leftView = user_phone_image;
    user_phone_input.leftViewMode = UITextFieldViewModeAlways;
    [user_phone_input addTarget:self action:@selector(user_phone_input_return:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:user_phone_input];
    
    // user_password_input
    user_password_input = [[UITextField alloc] initWithFrame:CGRectMake(-1, 250, 322, 45)];
    [user_password_input setSecureTextEntry:YES];
    user_password_input.borderStyle = UITextBorderStyleRoundedRect;
    user_password_input.layer.borderWidth = 0.2;
    user_password_input.layer.borderColor=[[UIColor blackColor]CGColor];
    user_password_input.placeholder = @"密码";
    UIImageView * user_password_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    user_password_input.leftView = user_password_image;
    user_password_input.leftViewMode = UITextFieldViewModeAlways;
    [user_password_input addTarget:self action:@selector(resignFirstResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:user_password_input];
    
    // user_login
    UIButton * user_login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [user_login setFrame:CGRectMake(-1, 314, 322, 45)];
    [user_login setTitle:@"登录" forState:UIControlStateNormal];
    [user_login setBackgroundColor:UIColorFromRGB(255, 255, 255, 1)];
    [user_login setTintColor:UIColorFromRGB(134, 11, 38, 1)];
    user_login.layer.borderWidth = 0.2;
    [user_login addTarget:self action:@selector(send_login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:user_login];
    
    // user_forgetpass
    UIButton * user_forgetpass = [UIButton buttonWithType:UIButtonTypeSystem];
    [user_forgetpass setFrame:CGRectMake(220, 354, 100, 45)];
    [user_forgetpass setTitle:@"忘记密码" forState:UIControlStateNormal];
    [user_forgetpass setBackgroundColor:[UIColor clearColor]];
    [user_forgetpass setTintColor:UIColorFromRGB(51, 51, 51, 1)];
    [user_forgetpass addTarget:self action:@selector(send_forgetpass:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:user_forgetpass];
    
    // user_register
    UIButton * user_register = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [user_register.layer setFrame:CGRectMake(-1, 411, 322, 45)];
    [user_register setTitle:@"初次使用？现在注册" forState:UIControlStateNormal];
    [user_register setBackgroundColor:UIColorFromRGB(134, 11, 38, 1)];
    [user_register setTintColor:UIColorFromRGB(255, 255, 255, 1)];
    [user_register addTarget:self action:@selector(send_register:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:user_register];
    
    // cancel_button
    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(segue_to_MapIdx:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)send_login:(id)sender {
    NSLog(@"%@ %@", user_phone_input.text, user_password_input.text);
    if (![self checkUserRights]) return;
    we_logined = YES;
    we_targetTabId = 2;
    //[self performSegueWithIdentifier:@"RegWlc2TabBar" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) checkUserRights {
    NSString *errorMessage = @"连接失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/login.action";
    NSString *md5pw = user_password_input.text;
    md5pw = [md5pw md5];
    NSString *parasString = [NSString stringWithFormat:@"phone=%@&password=%@", user_phone_input.text, md5pw];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            NSDictionary * response = [HTTPResponse objectForKey:@"response"];
            NSLog(@"%@", response);
            we_notice = [response objectForKey:@"notice"];
            return YES;
        }
        if ([result isEqualToString:@"2"]) {
            NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
            NSEnumerator *enumerator = [fields keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                NSString * tmp = [fields objectForKey:key];
                if (tmp != NULL) errorMessage = tmp;
            }
        }
        if ([result isEqualToString:@"3"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
        if ([result isEqualToString:@"4"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"登陆失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}

- (void)send_forgetpass:(id)sender {
    NSLog(@"forget password:");
}

- (void)send_register:(id)sender {
    NSLog(@"segue~~:");
    [self performSegueWithIdentifier:@"wlc2ipn" sender:self];
}

- (void)segue_to_MapIdx:(id)sender {
    NSLog(@"segue~~:");
    we_targetTabId = 0;
    //[self performSegueWithIdentifier:@"RegWlc2TabBar" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)user_phone_input_return:(id)sender {
    NSLog(@"user_phone_input_return:");
    [user_password_input becomeFirstResponder];
}

- (void)resignFirstResponder:(id)sender {
    NSLog(@"resignFirstResponder:");
    [sender resignFirstResponder];
}
@end
