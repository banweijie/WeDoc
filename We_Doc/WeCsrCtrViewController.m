//
//  WeCsrCtrViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrCtrViewController.h"

@interface WeCsrCtrViewController () {
    UIBubbleTableView * bubbletTableView;
    NSMutableArray * bubbleData;
    NSTimer * timer;
    UITextField * inputTextField;
    NSInteger currentCount;
    UIButton * sendButton;
    UIButton * inputMoreButton;
    UIView * inputView;
    UIView * unionView;
    UIView * moreInputView;
    int currentKeyboardState;
}

@end

@implementation WeCsrCtrViewController

// Action Sheet 按钮样式
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
            button.titleLabel.font = We_font_textfield_zh_cn;
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;//设置代理
            picker.allowsEditing = YES;//设置照片可编辑
            picker.sourceType = sourceType;
            //picker.showsCameraControls = NO;//默认为YES
            //创建叠加层
            UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
            //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
            UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
            UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
            [overLayView addSubview:bgImageView];
            picker.cameraOverlayView=overLayView;
            picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        else {
            NSLog(@"该设备无相机");
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 将图片上传至服务器
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:yijiarenUrl(@"message", @"postFileMsg") parameters:@{
                                                                          @"receiverId":we_patient_chating,
                                                                          @"content":inputTextField.text,
                                                                          @"fileFileName":@"a.jpeg",
                                                                          @"type":@"I",
                                                                          }
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
         }
             success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
                 NSString * errorMessage;
                 
                 NSString *result = [HTTPResponse objectForKey:@"result"];
                 result = [NSString stringWithFormat:@"%@", result];
                 if ([result isEqualToString:@"1"]) {
                     NSLog(@"response : %@", HTTPResponse[@"response"]);
                     WeMessage * newMessage = [[WeMessage alloc] initWithNSDictionary:HTTPResponse[@"response"]];
                     newMessage.imageContent = image;
                     newMessage.loading = NO;
                     [we_messagesWithPatient[we_patient_chating] addObject:newMessage];
                     inputTextField.text = @"";
                     [self textFieldDidChange:self];
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
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)refreshMessage:(id)sender {
    // 根据信息数量判断是否需要刷新
    NSLog(@"\n msg amount : %u", [we_messagesWithPatient[we_patient_chating] count]);
    if ([we_messagesWithPatient[we_patient_chating] count] == currentCount) return;
    currentCount = [we_messagesWithPatient[we_patient_chating] count];
    
    // 初始化信息数组
    bubbleData = [[NSMutableArray alloc] init];
    
    // 依次访问每条信息
    for (int i = 0; i < [we_messagesWithPatient[we_patient_chating] count]; i++) {
        // 提取当前处理的信息
        WeMessage * message = (WeMessage *) we_messagesWithPatient[we_patient_chating][i];
        
        // 判断是否仍在后续读取中
        if (message.loading) continue;
        
        // 判断发送方
        NSBubbleType senderType;
        UIImage * senderAvatar;
        if ([message.senderId isEqualToString:we_patient_chating]) {
            senderType = BubbleTypeSomeoneElse;
            senderAvatar = [(WeFavorPatient *)favorPatients[we_patient_chating] avatar];
        }
        else {
            senderType = BubbleTypeMine;
            senderAvatar = currentUser.avatar;
        }
        
        // 判断信息类型
        NSBubbleData * bubble;
        
        if ([message.messageType isEqualToString:@"T"]) {
            bubble = [NSBubbleData dataWithText:message.content date:[NSDate dateWithTimeIntervalSince1970:message.time] type:senderType];
        }
        else if ([message.messageType isEqualToString:@"I"]) {
            bubble = [NSBubbleData dataWithImage:message.imageContent date:[NSDate dateWithTimeIntervalSince1970:message.time] type:senderType];
        }
        else {
            bubble = [NSBubbleData dataWithText:message.content date:[NSDate dateWithTimeIntervalSince1970:message.time] type:senderType];
        }
        bubble.avatar = senderAvatar;
        
        // 添加到数组中
        [bubbleData addObject:bubble];
    }
    
    // 重载数据并滑至最底
    [bubbletTableView reloadData];
    [bubbletTableView scrollBubbleViewToBottomAnimated:YES];
}

- (void)sendMessage:(id)sender {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:yijiarenUrl(@"message", @"postMsg") parameters:@{@"m.receiverId":we_patient_chating, @"m.content":inputTextField.text, @"m.type":@"T"}
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             if ([result isEqualToString:@"1"]) {
                 NSLog(@"response : %@", HTTPResponse[@"response"]);
                 WeMessage * newMessage = [[WeMessage alloc] initWithNSDictionary:HTTPResponse[@"response"]];
                 newMessage.loading = NO;
                 [we_messagesWithPatient[we_patient_chating] addObject:newMessage];
                 inputTextField.text = @"";
                 [self textFieldDidChange:self];
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
    NSLog(@"!!!!!!!!");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    we_patient_chating = [NSString stringWithFormat:@"%@", we_patient_chating];
    currentKeyboardState = 0;
    // Setup Timer
    
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // Title
    self.navigationItem.title = ((WeFavorPatient *) favorPatients[we_patient_chating]).userName;
    
    // Invisible of tab bar
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    // unionView
    unionView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:unionView];
    
    // sys_tableView
    bubbletTableView = [[UIBubbleTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
    bubbletTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bubbletTableView.backgroundColor = [UIColor clearColor];
    
    [unionView addSubview:bubbletTableView];
    
    [self refreshMessage:self];
    bubbletTableView.bubbleDataSource = self;
    bubbletTableView.showAvatars = YES;
    [bubbletTableView reloadData];
    [bubbletTableView scrollBubbleViewToBottomAnimated:YES];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    inputView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:228 / 255.0 blue:223 / 255.0 alpha:0.9];
    
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 7, 240, 26)];
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.font = We_font_textfield_zh_cn;
    //inputTextField.clipsToBounds = YES;
    inputTextField.layer.cornerRadius = 3.0f;
    [inputTextField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    inputTextField.delegate = self;
    [inputView addSubview:inputTextField];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setFrame:CGRectMake(270, 7, 40, 26)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.tintColor = We_foreground_white_general;
    sendButton.backgroundColor = We_foreground_red_general;
    sendButton.titleLabel.font = We_font_textfield_zh_cn;
    sendButton.clipsToBounds = YES;
    sendButton.layer.cornerRadius = 4.0f;
    sendButton.hidden = YES;
    [inputView addSubview:sendButton];
    
    inputMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [inputMoreButton setFrame:CGRectMake(280, 0, 40, 40)];
    [inputMoreButton setImage:[UIImage imageNamed:@"chatroom-inputmore"] forState:UIControlStateNormal];
    [inputMoreButton setTintColor:We_foreground_red_general];
    [inputMoreButton addTarget:self action:@selector(inputMore:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:inputMoreButton];
    
    UIButton * sendAudioButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendAudioButton setFrame:CGRectMake(0, 0, 40, 40)];
    [sendAudioButton setImage:[UIImage imageNamed:@"chatroom-sendaudio"] forState:UIControlStateNormal];
    [sendAudioButton setTintColor:We_foreground_red_general];
    //[inputMoreButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendAudioButton];
    
    // moreInputView
    moreInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 100)];
    moreInputView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:228 / 255.0 blue:223 / 255.0 alpha:0.9];
    [self.view addSubview:moreInputView];
    
    WeToolButton * uploadPicButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadPicButton setFrame:CGRectMake(0, 0, 80, 100)];
    [uploadPicButton setTitle:@"上传图片" forState:UIControlStateNormal];
    [uploadPicButton setImage:[UIImage imageNamed:@"chatroom-sendphoto"] forState:UIControlStateNormal];
    [uploadPicButton addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    uploadPicButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadPicButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:uploadPicButton];
    
    WeToolButton * uploadHiButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadHiButton setFrame:CGRectMake(80, 0, 80, 100)];
    [uploadHiButton setTitle:@"上传病例" forState:UIControlStateNormal];
    [uploadHiButton setImage:[UIImage imageNamed:@"chatroom-sendcasehistory"] forState:UIControlStateNormal];
    uploadHiButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadHiButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:uploadHiButton];
    
    WeToolButton * uploadVedioButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [uploadVedioButton setFrame:CGRectMake(160, 0, 80, 100)];
    [uploadVedioButton setTitle:@"上传视频" forState:UIControlStateNormal];
    [uploadVedioButton setImage:[UIImage imageNamed:@"chatroom-sendvideo"] forState:UIControlStateNormal];
    uploadVedioButton.titleLabel.font = We_font_textfield_zh_cn;
    uploadVedioButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:uploadVedioButton];
    
    WeToolButton * jiahaoButton = [WeToolButton buttonWithType:UIButtonTypeRoundedRect];
    [jiahaoButton setFrame:CGRectMake(240, 0, 80, 100)];
    [jiahaoButton setTitle:@"我要加号" forState:UIControlStateNormal];
    [jiahaoButton setImage:[UIImage imageNamed:@"chatroom-makeappointment"] forState:UIControlStateNormal];
    jiahaoButton.titleLabel.font = We_font_textfield_zh_cn;
    jiahaoButton.tintColor = We_foreground_red_general;
    [moreInputView addSubview:jiahaoButton];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [unionView addSubview:inputView];
    
}

- (void)uploadPic:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"选择本地图片",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSValue * keyboardBoundsValue = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    CGRect keyboardBounds = [keyboardBoundsValue CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:KeyboardAnimationDurationUserInfoKey];
    
    CGRect rect = unionView.frame;
    rect.origin.y = self.view.frame.origin.y - keyboardBounds.size.height;
    unionView.frame = rect;
    
    if (currentKeyboardState == 2) {
        rect = moreInputView.frame;
        rect.origin.y += 100;
        moreInputView.frame = rect;
    }
    
    [UIView commitAnimations];
    
    currentKeyboardState = 1;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    currentKeyboardState = 0;
    CGFloat KeyboardAnimationDurationUserInfoKey = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:KeyboardAnimationDurationUserInfoKey];
    
    CGRect rect = unionView.frame;
    rect.origin.y = self.view.frame.origin.y;
    unionView.frame = rect;
    
    [UIView commitAnimations];
}

- (void)inputMore:(id)sender {
    if (currentKeyboardState == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        
        CGRect rect = moreInputView.frame;
        rect.origin.y -= 100;
        moreInputView.frame = rect;
        
        rect = unionView.frame;
        rect.origin.y = self.view.frame.origin.y - 100;
        unionView.frame = rect;
        
        [UIView commitAnimations];
        currentKeyboardState = 2;
    }
    else
        if (currentKeyboardState == 1) {
            [inputTextField resignFirstResponder];
            currentKeyboardState = 2;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            
            CGRect rect = moreInputView.frame;
            rect.origin.y -= 100;
            moreInputView.frame = rect;
            
            rect = unionView.frame;
            rect.origin.y = self.view.frame.origin.y - 100;
            unionView.frame = rect;
            
            [UIView commitAnimations];
        }
        else
            if (currentKeyboardState == 2) {
                [inputTextField becomeFirstResponder];
            }
}

- (void)textFieldDidChange:(id)sender {
    if ([inputTextField.text isEqualToString:@""]) {
        sendButton.hidden = YES;
        inputMoreButton.hidden = NO;
        [inputTextField setFrame:CGRectMake(40, 7, 240, 26)];
    }
    else {
        sendButton.hidden = NO;
        inputMoreButton.hidden = YES;
        [inputTextField setFrame:CGRectMake(40, 7, 220, 26)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshMessage:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
    timer = nil;
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
