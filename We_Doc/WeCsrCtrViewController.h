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

@interface WeCsrCtrViewController : UIViewController  <UIBubbleTableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder * audioRecorder;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;

@end
