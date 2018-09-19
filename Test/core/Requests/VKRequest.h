//
//  VKRequest.h
//  Test
//
//  Created by Вова Петров on 29.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "VKResponse.h"

@interface VKRequest : NSObject <NSURLSessionDelegate>
typedef enum {
    VK_GET_METHOD,
    VK_POST_METHOD,
    VK_PUT_METHOD,
    VK_DELETE_METHOD
} VK_MethodType;

@property (nonatomic) VK_MethodType methodType;
@property (nonatomic, strong) NSString* serverURLString;
@property (nonatomic, strong) NSString* methodURLString;
@property (nonatomic, strong) NSDictionary* params;
@property (nonatomic, strong) NSString* paramsString;
@property (nonatomic, strong) NSDictionary* body;
@property (nonatomic, strong) NSData* bodyNSData;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSDictionary* httpHeaders;

-(NSURL*)getFinalURL;
-(NSString*)getMethodString;
-(NSMutableURLRequest*)convertToURLRequest;
@end
