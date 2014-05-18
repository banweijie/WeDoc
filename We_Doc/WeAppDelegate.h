//
//  WeAppDelegate.h
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

#import "WeUser.h"
#import "WeDoctor.h"
#import "WeFavorDoctor.h"
#import "WePatient.h"
#import "WeFavorPatient.h"
#import "WeMessage.h"

@interface WeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
+ (NSData *)sendPhoneNumberToServer:(NSString *)urlString paras:(NSString *)parasString;
//+ (NSData *)post:(NSString *)urlString paras:(NSString *)parasString;
+ (NSData *)postToServer:(NSString *)urlString withParas:(NSString *)parasString;
+ (NSData *)postToServer:(NSString *)urlString withDictionaryParas:(NSDictionary *)paras;
+ (NSString *)toString:(id)unkown;
+ (NSString *)transitionDayOfWeekFromChar:(NSString *)dayOfWeek;
+ (NSString *)transitionPeriodOfDayFromChar:(NSString *)PeriodOfDay;
+ (NSString *)transitionTypeOfPeriodFromChar:(NSString *)TypeOfPeriod;
+ (NSString *)transitionTitleFromChar:(NSString *)TypeOfPeriod;
+ (NSString *)transitionGenderFromChar:(NSString *)TypeOfPeriod;
+ (NSString *)transition:(NSString *)code asin:(NSString *)type;
+ (NSString *)transitionToDateFromSecond:(long long)s;
+ (void)DownloadImageWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id))success;
+ (void)refreshUserData;
@end

// Global Variables
WeDoctor * currentUser;
NSMutableDictionary * favorPatients;

// user defaults
NSUserDefaults * userDefaults;

BOOL we_logined;
int we_targetTabId;
NSString * we_vericode_type;
int we_expToModify_id;
int we_wkpTOModify_id;

NSString * we_wkp_dayOfWeek;
NSString * we_wkp_periodOfDay;
NSString * we_wkp_typeOfPeriod;
NSString * we_pea_gender;
NSString * we_patient_chating;

NSMutableDictionary * we_avatars;
NSMutableDictionary * we_patients;
NSMutableDictionary * we_messagesWithPatient;

// app data
NSDictionary * we_codings;
NSDictionary * we_imagePaths;

// user data
NSString * we_phone_onReg;
NSString * we_workPeriod_save;

UIImage * we_avatar;

NSMutableArray * we_msgs;
NSMutableArray * user_exps;
NSMutableDictionary * we_msgsForPatient;
NSMutableDictionary * we_hospitalList;
NSMutableDictionary * we_sectionList;

@interface NSString (WeDelegate)
- (NSString *)urlencode;
- (NSString *)md5;
@end

@interface NSData (WeDelegate)
- (NSString*)md5;
@end

// 后台轮询的时间间隔
#define refreshInterval 5

#define yijiarenServer @"http://115.28.222.1/yijiaren"
#define yijiarenUrl(field, action) [NSString stringWithFormat:@"%@/%@/%@.action", yijiarenServer, field, action]
#define yijiarenImageServer we_imagePaths[@"imgServer"]
#define yijiarenAvatarUrl(fileName) [NSString stringWithFormat:@"%@%@%@", yijiarenImageServer, we_imagePaths[@"avatarPath"], fileName]
#define yijiarenCertUrl(fileName) [NSString stringWithFormat:@"%@%@%@", yijiarenImageServer, we_imagePaths[@"certPath"], fileName]
#define yijiarenImageUrl(fileName) [NSString stringWithFormat:@"%@%@%@", yijiarenImageServer, we_imagePaths[@"imagePath"], fileName]

#define UIColorFromRGB0x(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define We_font_textfield_zh_cn [UIFont fontWithName:@"Heiti SC" size:14]
#define We_font_textfield_en_us [UIFont fontWithName:@"Helvetica" size:14]
#define We_font_button_zh_cn [UIFont fontWithName:@"Heiti SC" size:14]
#define We_font_textfield_small_zh_cn [UIFont fontWithName:@"Heiti SC" size:11]


#define We_background_cell_general UIColorFromRGB(255, 255, 255, 0.85)
#define We_background_general UIColorFromRGB(237, 237, 237, 1)
#define We_background_red_general UIColorFromRGB(134, 11, 38, 0.9)
#define We_background_red_tableviewcell UIColorFromRGB(134, 11, 38, 0.85)
#define We_foreground_white_general UIColorFromRGB(255, 255, 255, 1)
#define We_foreground_gray_general UIColorFromRGB(146, 146, 146, 1)
#define We_foreground_black_general UIColorFromRGB(51, 51, 51, 1)
#define We_foreground_red_general UIColorFromRGB(134, 11, 38, 1)

#define We_frame_textFieldInCell_general CGRectMake(100, 8, 205, 30)
#define We_frame_labelInCell_general CGRectMake(100, 9, 180, 30)
#define We_frame_textFieldInCell_forInput CGRectMake(15, 8, 290, 30)
#define We_frame_textView_huge CGRectMake(10, 10, 300, 180)
#define We_frame_detailImageInCell_general CGRectMake(255, 7, 30, 30)
#define We_alpha_cell_general 0.85

#define We_init_textFieldInCell_general(tf, _text, _font) tf = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];tf.text = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentRight;tf.delegate = self;
#define We_init_textFieldInCell_forInput(tf, _text, _placeholder, _font) tf = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_forInput];tf.text = _text;tf.placeholder = _placeholder;tf.font = _font;tf.textAlignment = NSTextAlignmentCenter;tf.delegate = self;
#define We_init_textFieldInCell_pholder(tf, _text, _font) tf = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];tf.placeholder = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentRight;tf.delegate = self;

#define We_init_labelInCell_general(lb, _text, _font) lb = [[UILabel alloc] initWithFrame:We_frame_labelInCell_general];lb.text = _text;lb.font = _font;lb.textAlignment = NSTextAlignmentRight;

#define We_init_textView_huge(tf, _text, _font) tf = [[UITextView alloc] initWithFrame:We_frame_textView_huge];tf.text = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentLeft;tf.delegate = self;tf.scrollEnabled = NO;