//
//  WeAppDelegate.h
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
+ (NSData *)sendPhoneNumberToServer:(NSString *)urlString paras:(NSString *)parasString;
+ (NSData *)we_post:(NSString*)urlString paras:(NSDictionary *)paras;
+ (NSString *)toString:(id)unkown;
+ (NSString *)transitionDayOfWeekFromChar:(NSString *)dayOfWeek;
+ (NSString *)transitionPeriodOfDayFromChar:(NSString *)PeriodOfDay;
+ (NSString *)transitionTypeOfPeriodFromChar:(NSString *)TypeOfPeriod;
+ (NSString *)transitionTitleFromChar:(NSString *)TypeOfPeriod;
+ (NSString *)transitionGenderFromChar:(NSString *)TypeOfPeriod;
@end

// Global Variables
BOOL we_logined;
int we_targetTabId;
NSString * we_vericode_type;
int we_expToModify_id;
int we_wkpTOModify_id;

NSString * we_wkp_dayOfWeek;
NSString * we_wkp_periodOfDay;
NSString * we_wkp_typeOfPeriod;
NSString * we_pea_gender;

NSString * we_notice;
NSString * we_consultPrice;
NSString * we_plusPrice;
NSString * we_maxResponseGap;
NSString * we_workPeriod;
NSString * we_workPeriod_save;
NSString * we_hospital;
NSString * we_section;
NSString * we_title;
NSString * we_category;
NSString * we_skills;
NSString * we_degree;
NSString * we_email;
NSString * we_phone;
NSString * we_name;
NSString * we_gender;

NSMutableArray * user_exps;

@interface NSString (WeDelegate)
- (NSString *)md5;
@end

@interface NSData (WeDelegate)
- (NSString*)md5;
@end

#define UIColorFromRGB0x(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define We_font_textfield_zh_cn [UIFont fontWithName:@"Heiti SC" size:14]
#define We_font_textfield_en_us [UIFont fontWithName:@"Helvetica" size:14]
#define We_font_button_zh_cn [UIFont fontWithName:@"Heiti SC" size:14]

#define We_background_cell_general UIColorFromRGB(255, 255, 255, 0.85)
#define We_background_general UIColorFromRGB(237, 237, 237, 1)
#define We_background_red_general UIColorFromRGB(134, 11, 38, 0.9)
#define We_background_red_tableviewcell UIColorFromRGB(134, 11, 38, 0.85)
#define We_foreground_white_general UIColorFromRGB(255, 255, 255, 1)
#define We_foreground_gray_general UIColorFromRGB(146, 146, 146, 1)
#define We_foreground_black_general UIColorFromRGB(51, 51, 51, 1)
#define We_foreground_red_general UIColorFromRGB(134, 11, 38, 1)

#define We_frame_textFieldInCell_general CGRectMake(100, 9, 205, 30)
#define We_frame_labelInCell_general CGRectMake(100, 9, 180, 30)
#define We_frame_textView_huge CGRectMake(10, 10, 300, 180)

#define We_init_textFieldInCell_general(tf, _text, _font) tf = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];tf.text = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentRight;tf.delegate = self;
#define We_init_textFieldInCell_pholder(tf, _text, _font) tf = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];tf.placeholder = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentRight;tf.delegate = self;

#define We_init_labelInCell_general(lb, _text, _font) lb = [[UILabel alloc] initWithFrame:We_frame_labelInCell_general];lb.text = _text;lb.font = _font;lb.textAlignment = NSTextAlignmentRight;

#define We_init_textView_huge(tf, _text, _font) tf = [[UITextView alloc] initWithFrame:We_frame_textView_huge];tf.text = _text;tf.font = _font;tf.textAlignment = NSTextAlignmentLeft;tf.delegate = self;tf.scrollEnabled = NO;