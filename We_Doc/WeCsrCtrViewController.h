//
//  WeCsrCtrViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeToolButton.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "WeInfoedButton.h"
#import "WeNavViewController.h"
#import "WeImageButton.h"
#import "WeConsultDetailViewController.h"
#import "WeCahIdxViewController.h"
#import "WeSupConnectImageView.h"
#import "WeDetailImageViewController.h"

@interface WeCsrCtrViewController : UIViewController  <UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AVAudioRecorder * audioRecorder;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
@property (strong, nonatomic) WeFavorPatient * patientChating;

@end
