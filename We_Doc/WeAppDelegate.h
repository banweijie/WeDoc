//
//  WeAppDelegate.h
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "VoiceConverter.h"
#import <sqlite3.h>
#import <LKDBHelper.h>

#import "WeUser.h"
#import "WeDoctor.h"
#import "WeFavorDoctor.h"
#import "WePatient.h"
#import "WeFavorPatient.h"
#import "WeMessage.h"
#import "WeConsult.h"
#import "WeFunding.h"
#import "WeCaseRecord.h"
#import "WeExamination.h"

@interface WeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, atomic) WeUser * currentUser;

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
+ (NSString *)deCodeOfLanguages:(NSString *)languages;
+ (NSInteger)calcDaysByYear:(NSInteger)year andMonth:(NSInteger)month;
+ (UIImage *)imageWithColor:(UIColor *)color;

// AFNetworking 网络连接通用方法
+ (void)postToServerWithField:(NSString *)field action:(NSString *)action parameters:(NSDictionary *)parameters success:(void (^__strong)(__strong id))success failure:(void (^__strong)(__strong NSString *))failure;
+ (void)postToServerWithField:(NSString *)field action:(NSString *)action parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^)(id))success failure:(void (^)(NSString *))failure;
+ (void)DownloadImageWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id)) success;
+ (void)DownloadFileWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id)) success;

// 编码转换
+ (NSString *)transitionOfFundingType:(NSString *)type;

// 计算文本高度
+ (CGSize)calcSizeForString:(NSString *)text Font:(UIFont *)font expectWidth:(int)width;
@end

// 数据库
LKDBHelper * globalHelper;

// 全局变量
WeDoctor * currentUser;
long long lastMessageId;
NSMutableDictionary * favorPatientList;
NSMutableArray * caseRecords;
NSMutableArray * examinations;


WeCaseRecord * caseRecordChanging;
WeRecordDrug * recordDrugChanging;
WeExamination * examinationChanging;
WeExaminationItem * itemChanging;

NSString * we_workPeriod_save;

// user defaults
NSUserDefaults * userDefaults;

// Consulting room - selection - condition
NSString * condition_provinceId;
NSString * condition_provinceName;
NSString * condition_provinceId_tmp;
NSString * condition_provinceName_tmp;
NSString * condition_cityId;
NSString * condition_cityName;
NSString * condition_hospitalId;
NSString * condition_hospitalName;
NSString * condition_topSectionId;
NSString * condition_topSectionId_tmp;
NSString * condition_topSectionName;
NSString * condition_topSectionName_tmp;
NSString * condition_sectionId;
NSString * condition_sectionName;
NSString * condition_category;
NSString * condition_category_tmp;
NSString * condition_title;
NSString * condition_order;

// Consulting room - selection
BOOL selection_changed;
NSString * selection_provinceId;
NSString * selection_cityId;
NSString * selection_hospitalId;
NSString * selection_topSectionId;
NSString * selection_sectionId;
NSString * selection_category;
NSString * selection_title;
NSString * selection_recommend;
NSString * selection_keyword;

// Consulting room - new consult - condition
NSString * csrcos_selected_gender;

// Case History
BOOL we_justAddNewCaseRecord;

NSString * we_phone_onReg;
BOOL we_logined;
int we_targetTabId;
NSString * we_vericode_type;
int we_expToModify_id;
int we_wkpTOModify_id;

NSString * we_wkp_dayOfWeek;
NSString * we_wkp_periodOfDay;
NSString * we_wkp_typeOfPeriod;
NSString * we_pea_gender;
NSString * we_doctorChating;

NSMutableDictionary * we_avatars;
NSMutableDictionary * we_doctors;
NSMutableDictionary * we_messagesWithDoctor;

// app data
NSDictionary * we_codings;
NSArray * we_examinationTypeKeys;
NSMutableDictionary * we_secondaryTypeKeyToValue;
NSMutableDictionary * we_secondaryTypeKeyToData;
#define secondaryTypeName(parentTypeOrder, secondaryTypeOrder) we_examinationTypes[we_examinationTypeKeys[parentTypeOrder]][secondaryTypeOrder][@"text"]
#define secondaryTypeNameByKey(parentTypeKey, secondaryTypeOrder) we_examinationTypes[parentTypeKey][secondaryTypeOrder][@"text"]
#define secondaryTypeId(parentTypeOrder, secondaryTypeOrder) we_examinationTypes[we_examinationTypeKeys[parentTypeOrder]][secondaryTypeOrder][@"id"]
#define secondaryTypeData(parentTypeOrder, secondaryTypeOrder) we_examinationTypes[we_examinationTypeKeys[parentTypeOrder]][secondaryTypeOrder][@"data"]
NSDictionary * we_examinationTypes;
NSDictionary * we_imagePaths;

UIImage * we_avatar;
UIImage * we_qcImage;
UIImage * we_pcImage;
UIImage * we_wcImage;

NSMutableArray * we_msgs;
NSMutableArray * user_exps;
NSMutableDictionary * we_hospitalList;
NSMutableDictionary * we_sectionList;

@interface NSString (WeDelegate)
- (NSString *)urlencode;
- (NSString *)md5;
@end

@interface NSData (WeDelegate)
- (NSString*)md5;
@end

#define refreshInterval 5

typedef enum _WeTargetView
{
    targetViewNone = 0,
    targetViewMainPage = 1,
    targetViewPersonalCenter = 2,
    targetViewConsultingRoom = 3,
    targetViewPersonalAccount = 4,
    targetViewCaseHistory = 5
} weTargetView;

weTargetView we_targetView;

#define weTabBarIdMainPage 0
#define weTabBarIdConsultingRoom 1
#define weTabBarIdPersonalCenter 4
#define weTabBarIdCaseHistory 3

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
#define We_font_textfield_tiny_zh_cn [UIFont fontWithName:@"Heiti SC" size:10]
#define We_font_textfield_small_zh_cn [UIFont fontWithName:@"Heiti SC" size:12]
#define We_font_textfield_large_zh_cn [UIFont fontWithName:@"Heiti SC" size:16]
#define We_font_textfield_huge_zh_cn [UIFont fontWithName:@"Heiti SC" size:18]

#define We_background_cell_general UIColorFromRGB(255, 255, 255, 0.7)
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