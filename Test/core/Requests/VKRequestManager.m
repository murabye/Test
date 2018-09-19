//
//  VKRequestManager.m
//  Test
//
//  Created by Вова Петров on 31.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKRequestManager.h"

@interface VKRequestManager ()

@end

@implementation VKRequestManager

+(instancetype) shared {
    static VKRequestManager *_requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestManager = [[VKRequestManager alloc] init];
        
        NSURLSessionConfiguration *configs = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configs setAllowsCellularAccess:YES];

        configs.HTTPMaximumConnectionsPerHost = 20;
        
        _requestManager.session = [NSURLSession sessionWithConfiguration:configs];
    });
    
    return _requestManager;
}

- (void)sendRequest:(VKRequest*)request withCompletionHandler:(VKRequestCompletion)handler {
    if (!handler)
        return;

    NSMutableURLRequest* urlRequest = [request convertToURLRequest];
    
    NSURLSessionDownloadTask* task = [[self session] downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        VKResponse* userResponse = [[VKResponse alloc] init];
        NSData *data = [NSData dataWithContentsOfFile:[location relativePath]];
        
        if (!error) {
            if ([self tryJsonParse:data to:userResponse]) {
                if (![userResponse.parsedResponse objectForKey:@"response"]) {
                    userResponse.code = VK_REQUEST_STATUS_CODE_INPUT_ERROR;
                
                    userResponse.codeDescription = [[userResponse.parsedResponse
                                                     objectForKey:@"response"]
                                                     objectForKey:@"error_msg"];
                } else {
                    userResponse.parsedResponse = [userResponse.parsedResponse objectForKey:@"response"];
                }
            }
            
            handler(userResponse);
            return;
        }
        
        userResponse.code = VK_REQUEST_STATUS_CODE_NET_ERROR;
        userResponse.errorObj = error;
        handler(userResponse);
    }];
    
    [task resume];
}

-(BOOL)tryJsonParse:(NSData*)json to:(VKResponse*)responce{
    NSError* error = nil;
    
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:json
                                                                 options:kNilOptions
                                                                   error:&error];
    
    if (!error) {
        responce.code = VK_REQUEST_STATUS_CODE_SUCCESS;
        responce.parsedResponse = dictFromData;
        return YES;
    }
    
    responce.code = VK_REQUEST_STATUS_CODE_PARSE_JSON_ERROR;
    responce.codeDescription = @"Нечитаемый JSON";
    responce.errorParsingObj = error;
    return NO;
}

@end
