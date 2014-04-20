//
//  WeAppDelegate.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeAppDelegate.h"

@implementation WeAppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(134, 11, 38, 0.9)];
    we_logined = NO;
    we_targetTabId = 0;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSDictionary *)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:kNilOptions
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

+ (NSData *)sendPhoneNumberToServer:(NSString *)urlString paras:(NSString *)parasString
{
    NSLog(@"%@ %@", urlString, parasString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"iOS" forHTTPHeaderField:@"yijiaren"];
    NSData *data = [parasString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

+ (NSData *)we_post:(NSString*)urlString paras:(NSDictionary *)paras
{
    NSLog(@"%@ %@", urlString, paras);
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"IOS" forHTTPHeaderField:@"yijiaren"];
    //[request setValuesForKeysWithDictionary:paras];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:paras];
    [request setHTTPBody:data];
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}


+ (NSString *)toString:(id)unkown {
    NSString * tmp = [NSString stringWithFormat:@"%@", unkown];
    if ([tmp isEqualToString:@"<null>"]) return @"";
    else return tmp;
}

+ (NSString *)transitionDayOfWeekFromChar:(NSString *)dayOfWeek {
    if ([dayOfWeek isEqualToString:@"1"]) return @"周一";
    if ([dayOfWeek isEqualToString:@"2"]) return @"周二";
    if ([dayOfWeek isEqualToString:@"3"]) return @"周三";
    if ([dayOfWeek isEqualToString:@"4"]) return @"周四";
    if ([dayOfWeek isEqualToString:@"5"]) return @"周五";
    if ([dayOfWeek isEqualToString:@"6"]) return @"周六";
    if ([dayOfWeek isEqualToString:@"7"]) return @"周日";
    return @"出错啦！";
}


+ (NSString *)transitionPeriodOfDayFromChar:(NSString *)PeriodOfDay {
    if ([PeriodOfDay isEqualToString:@"A"]) return @"上午";
    if ([PeriodOfDay isEqualToString:@"B"]) return @"下午";
    return @"出错啦！";
}

+ (NSString *)transitionTypeOfPeriodFromChar:(NSString *)TypeOfPeriod {
    if ([TypeOfPeriod isEqualToString:@"Z"]) return @"专家门诊";
    if ([TypeOfPeriod isEqualToString:@"T"]) return @"特殊门诊";
    if ([TypeOfPeriod isEqualToString:@"P"]) return @"普通门诊";
    return @"出错啦！";
}

+ (NSString *)transitionTitleFromChar:(NSString *)title {
    if ([title isEqualToString:@"Z"]) return @"专家门诊";
    if ([title isEqualToString:@"T"]) return @"特殊门诊";
    if ([title isEqualToString:@"P"]) return @"普通门诊";
    return @"出错啦！";
}

+ (NSString *)transitionGenderFromChar:(NSString *)gender {
    if ([gender isEqualToString:@"M"]) return @"男";
    if ([gender isEqualToString:@"F"]) return @"女";
    if ([gender isEqualToString:@"U"]) return @"未设置";
    return @"出错啦！";
}
@end


#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
@implementation NSString (WeDelegate)
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (WeDelegate)
- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end
