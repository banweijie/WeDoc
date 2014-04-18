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
+ (void)resignFirstResponder:(id)sender;
@end

BOOL we_logined;
int we_targetTabId;

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
