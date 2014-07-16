//
//  WeAppDelegate.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeAppDelegate.h"

@implementation WeAppDelegate {
    NSTimer * timer0;
    NSTimer * timer1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    currentUser = nil;
    
    // 设置TabBar的delegate
    UITabBarController<UITabBarControllerDelegate> * _tabBarController = (UITabBarController<UITabBarControllerDelegate> *)_window.rootViewController;
    _tabBarController.delegate = _tabBarController;
    
    we_hospitalList = [[NSMutableDictionary alloc] init];
    we_sectionList = [[NSMutableDictionary alloc] init];
    caseRecords = [[NSMutableArray alloc] init];
    examinations = [[NSMutableArray alloc] init];
    
    [self refreshInitialData];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"1" forKey:@"lastMessageId"];
    
    //timer0 = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refreshDoctorList:) userInfo:nil repeats:YES];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refreshMessage:) userInfo:nil repeats:YES];
    
    globalHelper = [LKDBHelper getUsingLKDBHelper];
    
    [globalHelper createTableWithModelClass:[WeMessage class]];
    
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

+ (NSInteger)calcDaysByYear:(NSInteger)year andMonth:(NSInteger)month {
    if (month == 2) {
        if (year % 400 == 0) return 29;
        if (year % 100 == 0) return 28;
        if (year % 4 == 0) return 29;
        return 28;
    }
    if (month == 4 || month == 6 || month == 9 || month == 11) return 30;
    return 31;
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

# pragma mark - Networking

+ (void)postToServerWithField:(NSString *)field action:(NSString *)action parameters:(NSDictionary *)parameters success:(void (^__strong)(__strong id))success failure:(void (^__strong)(__strong NSString *))failure {
    NSLog(@"\npost to api: <%@, %@>\nparameters: %@", field, action, parameters);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"yijiaren"];
    [manager POST:yijiarenUrl(field, action) parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSString * errorMessage = @"未知的错误";
              NSString * result = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
              if ([result isEqualToString:@"1"]) {
                  success(responseObject[@"response"]);
                  return;
              }
              if ([result isEqualToString:@"2"]) {
                  NSDictionary *fields = responseObject[@"fields"];
                  NSEnumerator *enumerator = [fields keyEnumerator];
                  id key;
                  while ((key = [enumerator nextObject])) {
                      NSString * tmp1 = [fields objectForKey:key];
                      if (tmp1 != NULL) errorMessage = tmp1;
                  }
              }
              else if ([result isEqualToString:@"3"]) {
                  errorMessage = responseObject[@"info"];
              }
              else if ([result isEqualToString:@"4"]) {
                  errorMessage = responseObject[@"info"];
              }
              failure(errorMessage);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              failure([NSString stringWithFormat:@"%@", @"连接服务器失败"]);
          }];
}

+ (void)postToServerWithField:(NSString *)field action:(NSString *)action parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    NSLog(@"\npost to api: <%@, %@>\nparameters: %@\nfileName: %@", field, action, parameters, fileName);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"yijiaren"];
    [manager POST:yijiarenUrl(field, action)
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"YJR/FILE"];
}
          success:^(NSURLSessionDataTask * task, id responseObject) {
              NSString * errorMessage = @"未知的错误";
              NSString * result = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
              if ([result isEqualToString:@"1"]) {
                  success(responseObject[@"response"]);
                  return;
              }
              if ([result isEqualToString:@"2"]) {
                  NSDictionary *fields = responseObject[@"fields"];
                  NSEnumerator *enumerator = [fields keyEnumerator];
                  id key;
                  while ((key = [enumerator nextObject])) {
                      NSString * tmp1 = [fields objectForKey:key];
                      if (tmp1 != NULL) errorMessage = tmp1;
                  }
              }
              else if ([result isEqualToString:@"3"]) {
                  errorMessage = responseObject[@"info"];
              }
              else if ([result isEqualToString:@"4"]) {
                  errorMessage = responseObject[@"info"];
              }
              failure(errorMessage);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              failure([NSString stringWithFormat:@"%@", @"连接服务器失败"]);
          }];
}


+ (void)DownloadImageWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id))success {
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

+ (void)DownloadFileWithURL:(NSString *)URL successCompletion:(void (^__strong)(__strong id)) success {
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request
                                                                      progress:nil
                                                                   destination:^NSURL * (NSURL * targetPath, NSURLResponse * response) {
                                                                       NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                       return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                   }
                                                             completionHandler:^(NSURLResponse * response, NSURL * filePath, NSError * error) {
                                                                 if (error) NSLog(@"%@", error);
                                                                 else {
                                                                     success(filePath);
                                                                 }
                                                             }];
    [downloadTask resume];
}

// 编码转换
+ (NSString *)transitionOfFundingType:(NSString *)type {
    if ([type isEqualToString:@""]) return @"全部";
    return we_codings[@"fundingType"][type];
}

+ (NSString *)transitionToDateFromSecond:(long long)s {
    NSDate * t = [NSDate dateWithTimeIntervalSince1970:s];
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * the = [calendar components:unitFlags fromDate:t];
    NSDateComponents * now = [calendar components:unitFlags fromDate:date];
    
    if ([[NSDate date] timeIntervalSince1970] - s <= 24 * 3600) {
        if ([the day] != [now day]) return [NSString stringWithFormat:@"昨天 %02ld:%02ld", (long)[the hour], (long)[the minute]];
        else return [NSString stringWithFormat:@"%02ld:%02ld", (long)[the hour], (long)[the minute]];
    }
    else {
        if ([the year] != [now year]) {
            return [NSString stringWithFormat:@"%ld年%ld月%ld日 %02ld %02ld", (long)[the year], (long)[the month], (long)[the day], (long)[the hour], (long)[the minute]];
        }
        else {
            return [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld", (long)[the month], (long)[the day], (long)[the hour], (long)[the minute]];
        }
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

#pragma mark - APIs

- (void)refreshInitialData {
    NSString * urlString = yijiarenUrl(@"data", @"initData");
    NSString * paraString = @"";
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败，暂时使用本地缓存数据";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"%@", HTTPResponse);
        we_codings = HTTPResponse[@"response"][@"codings"];
        we_imagePaths = HTTPResponse[@"response"][@"imagePaths"];
        NSLog(@"%@", HTTPResponse);
        we_examinationTypeKeys = [we_codings[@"examinationType"] allKeys];
        we_examinationTypes = HTTPResponse[@"response"][@"examinationTypes"];
        we_secondaryTypeKeyToValue = [[NSMutableDictionary alloc] init];
        we_secondaryTypeKeyToData = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [we_examinationTypeKeys count]; i++) {
            for (int j = 0; j < [we_examinationTypes[we_examinationTypeKeys[i]] count]; j++) {
                we_secondaryTypeKeyToValue[[WeAppDelegate toString:secondaryTypeId(i, j)]] = secondaryTypeName(i, j);
                we_secondaryTypeKeyToData[[WeAppDelegate toString:secondaryTypeId(i, j)]] = secondaryTypeData(i, j);
            }
        }
        //NSLog(@"%@", we_secondaryTypeKeyToData);
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

- (void)refreshMessage:(id)sender {
    // 判断登录状态
    if (currentUser == nil) return;
    
    // 访问接口
    [WeAppDelegate postToServerWithField:@"message" action:@"getMsg"
                              parameters:@{
                                           @"lastMessageId":[NSString stringWithFormat:@"%lld", lastMessageId]
                                           }
                                 success:^(NSArray * response) {
                                     for (int i = 0; i < [response count]; i++) {
                                         WeMessage * message = [[WeMessage alloc] initWithNSDictionary:response[i]];
                                         if ([message.messageType isEqualToString:@"X"]) NSLog(@"XXXXXXXXXX");
                                         if ([message.messageId longLongValue] > lastMessageId) {
                                             lastMessageId = [message.messageId longLongValue];
                                         }
                                         NSMutableArray * result = [globalHelper search:[WeMessage class]
                                                                                  where:[NSString stringWithFormat:@"messageId = %@", message.messageId]
                                                                                orderBy:nil offset:0 count:0];
                                         if ([result count] == 0) {
                                             // 文字消息
                                             if ([message.messageType isEqualToString:@"T"]) {
                                                 [globalHelper insertToDB:message];
                                             }
                                             // 图片消息
                                             else if ([message.messageType isEqualToString:@"I"]) {
                                                 [globalHelper insertToDB:message];
                                                 [WeAppDelegate DownloadImageWithURL:yijiarenImageUrl(message.content)
                                                                   successCompletion:^(id image) {
                                                                       //NSLog(@"!!!");
                                                                       message.imageContent = (UIImage *)image;
                                                                       [globalHelper updateToDB:message where:nil];
                                                                   }];
                                             }
                                             // 语音消息
                                             else if ([message.messageType isEqualToString:@"A"]) {
                                                 [globalHelper insertToDB:message];
                                                 [WeAppDelegate DownloadFileWithURL:yijiarenImageUrl(message.content)
                                                                  successCompletion:^(NSURL * filePath) {
                                                                      [VoiceConverter amrToWav:filePath.path wavSavePath:[NSString stringWithFormat:@"%@%@.wav", NSTemporaryDirectory(), message.messageId]];
                                                                      message.audioContent = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@.wav", NSTemporaryDirectory(), message.messageId]];
                                                                      [globalHelper updateToDB:message where:nil];
                                                                  }];
                                             }
                                             // 状态改变
                                             else if ([message.messageType isEqualToString:@"C"]) {
                                                 for (int i = 0; i < message.content.length; i++) {
                                                     if ([message.content characterAtIndex:i] == '=') {
                                                         NSString * left = [message.content substringToIndex:i];
                                                         NSString * right = [message.content substringFromIndex:i + 1];
                                                         //NSLog(@"%@ %@", left, right);
                                                         if ([left isEqualToString:@"consultStatus"]) {
                                                             WeFavorPatient * currentPatient = favorPatientList[message.senderId];
                                                             currentPatient.consultStatus = right;
                                                         }
                                                     }
                                                 }
                                             }
                                             // 咨询消息
                                             else if ([message.messageType isEqualToString:@"c"]) {
                                                 //NSLog(@"%@", message.content);
                                                 WeFavorPatient * currentPatient = favorPatientList[message.senderId];
                                                 //NSLog(@"%@", currentPatient.userName);
                                                 currentPatient.currentConsultId = message.content;
                                             }
                                             // 系统消息
                                             else if ([message.messageType isEqualToString:@"X"]) {
                                                 NSLog(@"XXXXXXXXXXXXX");
                                                 [globalHelper insertToDB:message];
                                             }
                                         }
                                     }
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                 }];
}

#pragma mark - No Idea

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)calcSizeForString:(NSString *)text Font:(UIFont *)font expectWidth:(int)width {
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
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
    int sourceLen = (int)strlen((const char *)source);
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
    CC_MD5( self.bytes, (unsigned int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

