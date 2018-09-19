//
//  VKResponse.h
//  Test
//
//  Created by Вова Петров on 31.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKResponse : NSObject

typedef enum : NSUInteger {
    VK_REQUEST_STATUS_CODE_UNKNOWN_OR_EMPTY = 0,
    VK_REQUEST_STATUS_CODE_OPERATION_ERROR = 1,
    VK_REQUEST_STATUS_CODE_PARSE_JSON_ERROR = 2,
    VK_REQUEST_STATUS_CODE_SUCCESS = 200,
    VK_REQUEST_STATUS_CODE_NET_ERROR = 404,
    VK_REQUEST_STATUS_CODE_INPUT_ERROR = 100
} VK_RequestStatusCode;

@property (nonatomic) VK_RequestStatusCode code;
@property (nonatomic, strong) NSString* codeDescription;

@property (nonatomic, strong) NSDictionary* parsedResponse;

@property (nonatomic, strong) NSError* errorObj;
@property (nonatomic, strong) NSError* errorParsingObj;

-(BOOL) isSuccess;
@end
