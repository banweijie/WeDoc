//
//  WeAppDelegate.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeAppDelegate.h"

@implementation WeAppDelegate {
    NSTimer * timer;
    NSTimer * timer1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    we_logined = NO;
    we_targetTabId = 0;
    UITabBarController<UITabBarControllerDelegate> * _tabBarController = (UITabBarController<UITabBarControllerDelegate> *)_window.rootViewController;
    _tabBarController.delegate = _tabBarController;
    
    we_hospitalList = [[NSMutableDictionary alloc] init];
    we_sectionList = [[NSMutableDictionary alloc] init];
    we_messagesWithPatient = [[NSMutableDictionary alloc] init];
    [self refreshInitialData];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"1" forKey:@"lastMessageId"];

    timer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refreshMessage:) userInfo:nil repeats:YES];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refreshPatientList:) userInfo:nil repeats:YES];
    
    NSLog(@"%@", [userDefaults stringForKey:@"lastMessageId"]);
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

+ (NSString *)transitionToDateFromSecond:(long long)s {
    NSDate * t = [NSDate dateWithTimeIntervalSince1970:s];
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * the = [calendar components:unitFlags fromDate:t];
    NSDateComponents * now = [calendar components:unitFlags fromDate:date];

    if ([[NSDate date] timeIntervalSince1970] - s <= 24 * 3600) {
        if ([the day] != [now day]) return [NSString stringWithFormat:@"昨天 %02d:%02d", [the hour], [the minute]];
        else return [NSString stringWithFormat:@"%02d:%02d", [the hour], [the minute]];
    }
    else {
        if ([the year] != [now year]) return [NSString stringWithFormat:@"%d年%d月", [the year], [the month]];
        else return [NSString stringWithFormat:@"%d月%d日", [the month], [the day]];
    }
    return [NSString stringWithFormat:@"%lld", s];
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

+ (NSData *)postToServer:(NSString *)urlString withParas:(NSString *)parasString
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

+ (NSData *)postToServer:(NSString *)urlString withDictionaryParas:(NSDictionary *)paras {
    NSLog(@"%@ %@", urlString, paras);
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"iOS" forHTTPHeaderField:@"yijiaren"];
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

+ (NSString *)transition:(NSString *)code asin:(NSString *)type {
    return we_codings[type][code];
}

- (void)refreshInitialData {
    NSString * urlString = yijiarenUrl(@"data", @"initData");
    NSString * paraString = @"";
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败，暂时使用本地缓存数据";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"%@", HTTPResponse);
        we_codings = HTTPResponse[@"codings"];
        we_imagePaths = HTTPResponse[@"imagePaths"];
        NSLog(@"%@", we_codings);
        return;
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"更新应用数据失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

+ (void)refreshUserData {
    NSString * urlString = yijiarenUrl(@"user", @"refreshUser");
    NSString * paraString = @"";
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败，暂时使用本地缓存数据";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            NSLog(@"%@", [HTTPResponse objectForKey:@"response"]);
            
            if (currentUser) {
                [currentUser setWithNSDictionary:HTTPResponse[@"response"]];
            }
            else {
                currentUser = [[WeDoctor alloc] initWithNSDictionary:HTTPResponse[@"response"]];
            }
            
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
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"更新用户数据失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

- (void)refreshMessage:(id)sender {
    // 判断登录状态
    if (!we_logined) return;
    
    NSLog(@"refreshMessage(lastMessageId = %@)", [userDefaults stringForKey:@"lastMessageId"]);
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"lastMessageId":[userDefaults stringForKey:@"lastMessageId"]};
    [manager GET:yijiarenUrl(@"message", @"getMsg") parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             
             NSString * result = [NSString stringWithFormat:@"%@", [HTTPResponse objectForKey:@"result"]];
             
             if ([result isEqualToString:@"1"]) {
                 // 获取所有信息
                 NSArray * messages = [HTTPResponse objectForKey:@"response"];
                 
                 // 依次处理所有信息
                 if ([messages count] > 0) {
                     WeMessage * message;
                     for (int i = 0; i < [messages count]; i ++) {
                         // 取出某一条消息
                         message = [[WeMessage alloc] initWithNSDictionary:messages[i]];
                         // 如果是图片消息则去读取图片
                         if ([message.messageType isEqualToString:@"I"]) {
                             [self DownloadImageWithURL:yijiarenImageUrl(message.content) successCompletion:^(id image) {
                                 message.imageContent = (UIImage *) image;
                             }];
                         }
                         // 添加到所属医生的信息列表中
                         if (we_messagesWithPatient[message.senderId] == NULL) {
                             we_messagesWithPatient[message.senderId] = [[NSMutableArray alloc] init];
                         }
                         [we_messagesWithPatient[message.senderId] addObject:message];
                     }
                     // 设置最后读取的信息
                     [userDefaults setValue:message.messageId forKey:@"lastMessageId"];
                 }
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
             NSLog(@"Fail: %@", errorMessage);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

- (void)refreshPatientList:(id)sender {
    // 判断登录状态
    if (!we_logined) return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:yijiarenUrl(@"doctor", @"listPatients") parameters:nil
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             if ([result isEqualToString:@"1"]) {
                 favorPatients = [[NSMutableDictionary alloc] init];
                 NSArray * favorPatientList = HTTPResponse[@"response"];
                 for (int i = 0; i < [favorPatientList count]; i++) {
                     WeFavorPatient * newPatient = [[WeFavorPatient alloc] initWithNSDictionary:favorPatientList[i][@"patient"]];
                     favorPatients[newPatient.userId] = newPatient;
                     //NSLog(@"%@", [newPatient stringValue]);
                 }
                 //NSLog(@"%@", favorPatients);
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
                                          initWithTitle:@"获取病人列表失败"
                                          message:errorMessage
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"获取病人列表失败"
                                          message:@"未能连接服务器，请重试"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
     ];
}

- (void)DownloadImageWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id))success {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"DownloadImageWithURL error: %@", error);
    }];
    [requestOperation start];
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
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
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

