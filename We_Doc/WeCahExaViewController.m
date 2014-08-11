//
//  WeCahExaViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahExaViewController.h"

@interface WeCahExaViewController () {
    UITableView * sys_tableView;
    UITextField * user_date_input;
    UITextField * user_hospital_input;
    UITextView * user_result_input;
    UIActivityIndicatorView * sys_pendingView;
    UIView * sys_imageView;
    UIActionSheet * deleteImage_actionSheet;
    
    WeTextCoding * imageToDelete;
    WeTextCoding * imageToDemo;
}

@end

@implementation WeCahExaViewController

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
    if (actionSheet == deleteImage_actionSheet) {
        [self removeExaminationImage:self];
        return;
    }
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
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 将图片上传至服务器
        [sys_pendingView startAnimating];
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:yijiarenUrl(@"patient", @"addExaminationImage") parameters:@{
                                                                           @"examinationId":examinationChanging.examId,
                                                                           @"fileFileName":@"a.jpg",
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
                      WeTextCoding * newImage = [[WeTextCoding alloc] initWithNSDictionary:HTTPResponse[@"response"]];
                      [examinationChanging.images addObject:newImage];
                      [self refreshImageView:self];
                      [sys_tableView reloadData];
                      
                      [sys_pendingView stopAnimating];
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
/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 将展示某个Cell触发的事件
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (tv == sys_tableView) {
        if (path.section == 0 && path.row == 0) {
            [user_date_input becomeFirstResponder];
        }
        if (path.section == 0 && path.row == 1) {
            [user_hospital_input becomeFirstResponder];
        }
        if (path.section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            if ([examinationChanging.items count] > 0) {
                itemChanging = examinationChanging.items[path.row];
                WeCahExaAddIteViewController * vc = [[WeCahExaAddIteViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if (path.section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            if ([examinationChanging.items count] > 0) {
                itemChanging = examinationChanging.items[path.row];
                WeCahExaAddIteViewController * vc = [[WeCahExaAddIteViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (path.section == 2 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            itemChanging = nil;
            
            WeNavViewController * nav = [[WeNavViewController alloc] init];
            WeCahExaAddIteViewController * vc = [[WeCahExaAddIteViewController alloc] init];
            
            [nav pushViewController:vc animated:NO];
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (path.section == 3 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            itemChanging = nil;
            
            WeNavViewController * nav = [[WeNavViewController alloc] init];
            WeCahExaAddIteViewController * vc = [[WeCahExaAddIteViewController alloc] init];
            
            [nav pushViewController:vc animated:NO];
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (path.section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            [self removeExamination:self];
        }
        if (path.section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) {
            [self removeExamination:self];
        }
        if (path.section == 4) {
            [self removeExamination:self];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) {
        return 20 + ([examinationChanging.images count] / 3 + 1) * 100;
    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 21 + 64;
    if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return 40;
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return 40;
    if (section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) return 40;
    if (section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) return 40;
    if (section == 4) return 40;
    return 10;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return @"报告单照片";
    if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return @"条目组";
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return @"条目组";
    if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return @"检查结果";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 111;
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    //if (section == 1) return sys_countDown_demo;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    if (tv == sys_tableView) {
        if ([examinationChanging.typeParent isEqualToString:@"P"]) return 4;
        if ([examinationChanging.typeParent isEqualToString:@"C"]) return 5;
        if ([examinationChanging.typeParent isEqualToString:@"I"]) return 4;
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == sys_tableView) {
        if (section == 0) return 2;
        if (section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) return MAX([examinationChanging.items count], 1);
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) return MAX([examinationChanging.items count], 1);
        if (section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"C"]) return 1;
        if (section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) return 1;
        if (section == 4) return 1;
    }
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    if (tv == sys_tableView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"检查时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_date_input];
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"检查地点";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_hospital_input];
        }
        if (indexPath.section == 1 && ![examinationChanging.typeParent isEqualToString:@"P"]) {
            [cell.contentView addSubview:sys_imageView];
        }
        if (indexPath.section == 1 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            if ([examinationChanging.items count] == 0) {
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = @"目前尚未有检查条目";
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
            }
            if ([examinationChanging.items count] > 0) {
                NSLog(@"!!!");
                WeExaminationItem * item = examinationChanging.items[indexPath.row];
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = item.config.name;
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.value, item.config.unit];
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加检查项目";
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            if ([examinationChanging.items count] == 0) {
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = @"目前尚未有检查条目";
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
            }
            if ([examinationChanging.items count] > 0) {
                NSLog(@"!!!");
                WeExaminationItem * item = examinationChanging.items[indexPath.row];
                cell.backgroundColor = We_foreground_white_general;
                cell.textLabel.text = item.config.name;
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.value, item.config.unit];
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
        if (indexPath.section == 2 && [examinationChanging.typeParent isEqualToString:@"I"]) {
            cell.backgroundColor = We_foreground_white_general;
            [cell.contentView addSubview:user_result_input];
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"P"]) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"C"]) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加检查项目";
        }
        if (indexPath.section == 3 && [examinationChanging.typeParent isEqualToString:@"I"]) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
        if (indexPath.section == 4) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
    }
    return cell;
}

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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情", we_codings[@"examinationType"][examinationChanging.typeParent]];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 更新图片集
    [self refreshImageView:self];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 输入框初始化
    
    We_init_textFieldInCell_general(user_date_input, examinationChanging.date, We_font_textfield_en_us);
    We_init_textFieldInCell_general(user_hospital_input, examinationChanging.hospital, We_font_textfield_zh_cn);
    We_init_textView_huge(user_result_input, examinationChanging.result, We_font_textfield_zh_cn)
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 保存按键
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onPress:)];
    self.navigationItem.rightBarButtonItem = user_save;
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)refreshImageView:(id)sender {
    sys_imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20 + (([examinationChanging.images count] + 1) / 3 + 1) * 100)];
    for (int i = 0; i <= [examinationChanging.images count]; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (i % 3) * 100, 20 + (i / 3) * 100, 80, 80)];
        WeInfoedButton * imageButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
        [imageButton setFrame:CGRectMake(20 + (i % 3) * 100, 20 + (i / 3) * 100, 80, 80)];
        
        [sys_imageView addSubview:imageView];
        [sys_imageView addSubview:imageButton];
        
        if (i < [examinationChanging.images count]) {
            [imageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(((WeTextCoding *)examinationChanging.images[i]).objName)]];
            WeInfoedButton * deleteButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
            [deleteButton setFrame:CGRectMake(10 + (i % 3) * 100, 10 + (i / 3) * 100, 20, 20)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"casehistory-deleteimage"] forState:UIControlStateNormal];
            [deleteButton setUserData:examinationChanging.images[i]];
            [deleteButton addTarget:self action:@selector(deleteButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
            [sys_imageView addSubview:deleteButton];
            
            // 点击图片放大
            [imageButton setUserData:examinationChanging.images[i]];
            [imageButton addTarget:self action:@selector(demoImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"casehistory-addimage"]];
            [imageButton addTarget:self action:@selector(addExaminationImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        //NSLog(@"%@", yijiarenImageUrl(((WeTextCoding *)examinationChanging.images[i]).objName));
    }
}

- (void)demoImage:(WeInfoedButton *)sender {
    WeTextCoding * image = sender.userData;
    WeImageViewerViewController * vc = [[WeImageViewerViewController alloc] init];
    vc.imageToDemoPath = yijiarenImageUrl(image.objName);
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)deleteButton_onPress:(WeInfoedButton *)sender {
    imageToDelete = sender.userData;
    deleteImage_actionSheet = [[UIActionSheet alloc]
                    initWithTitle:nil
                    delegate:self
                    cancelButtonTitle:@"取消"
                    destructiveButtonTitle:nil
                    otherButtonTitles:@"确认删除",nil];
    deleteImage_actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [deleteImage_actionSheet showInView:self.view];
}

- (void)addExaminationImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"选择本地图片",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)removeExaminationImage:(id)sender {
    [sys_pendingView startAnimating];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"removeExaminationImage") parameters:@{
                                                                               @"eiId":imageToDelete.objId
                                                                               }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  NSLog(@"response : %@", HTTPResponse[@"response"]);
                  [examinationChanging.images removeObject:imageToDelete];
                  [self refreshImageView:self];
                  [sys_tableView reloadData];
                  
                  [sys_pendingView stopAnimating];
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
                                           initWithTitle:@"删除图片失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"删除图片失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (void)user_save_onPress:(id)sender {
    [self updateExamination:self];
}

- (void)updateExamination:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"updateExamination") parameters:@{
                                                                        @"examination.date":user_date_input.text,
                                                                        @"examination.hospital":user_hospital_input.text,
                                                                        @"examination.result":user_result_input.text,
                                                                        @"examination.id":examinationChanging.examId
                                                                        }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  examinationChanging.date = user_date_input.text;
                  examinationChanging.hospital = user_hospital_input.text;
                  examinationChanging.result = user_result_input.text;
                  
                  [self.navigationController popViewControllerAnimated:YES];
                  
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
              [sys_pendingView stopAnimating];
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
              [sys_pendingView stopAnimating];
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

- (void)removeExamination:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"removeExamination") parameters:@{
                                                                        @"ExaminationId":examinationChanging.examId
                                                                        }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  [examinations removeObject:examinationChanging];
                  
                  [self.navigationController popViewControllerAnimated:YES];
                  
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
              [sys_pendingView stopAnimating];
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
              [sys_pendingView stopAnimating];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
