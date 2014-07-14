//
//  WeCsrCtrViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "WeAppDelegate.h"
#import "WeToolButton.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "WeInfoedButton.h"
#import "WeCsrCosViewController.h"
#import "WeNavViewController.h"
#import "WeCsrJiaViewController.h"
#import "WeImageButton.h"

@interface WeCsrCtrViewController : UIViewController  <UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AVAudioRecorder * audioRecorder;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
@property (strong, nonatomic) WeFavorPatient * patientChating;

@end
