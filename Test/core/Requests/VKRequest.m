//
//  VKRequest.m
//  Test
//
//  Created by Вова Петров on 29.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKRequest.h"
@implementation VKRequest

NSString * const defaultServerURL = @"https://api.vk.com/method/";
NSString * const defaultMethodURL = @"photos.search?";
NSString * const defaultContentType = @"application/json";

#pragma mark - init
- (id)init {
    self = [super init];
    if (self)
    {
        [self setMethodType:VK_GET_METHOD];
        [self setServerURLString:defaultServerURL];
        [self setMethodURLString:defaultMethodURL];
        [self setContentType:defaultContentType];
    }
    return self;
}

#pragma mark - setters

-(void)setBody:(NSDictionary *)body {
    _body = body;
    
    NSError* error = nil;
    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:body
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    
    if (!error) {
        _bodyNSData = dataFromDict;
        return;
    }
}

-(void)setBodyNSData:(NSData *)bodyNSData {
    _bodyNSData = bodyNSData;
    
    NSError* error = nil;
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:bodyNSData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    
    if (!error) {
        _body = dictFromData;
        return;
    }
}

-(void)setParams:(NSDictionary *)params {
    _params = params;
    
    NSString* paramString = @"";
    
    for (NSString* key in params) {
        paramString = [paramString stringByAppendingString: [NSString stringWithFormat:@"%@=%@&", key, params[key]]];
    }
    
    paramString = [paramString substringToIndex: [paramString length]-1];
    
    _paramsString = paramString;
}

#pragma mark - get methods
-(NSURL*)getFinalURL {
    NSString* fullStr = [NSString stringWithFormat:@"%@%@", [self serverURLString], [self methodURLString]];
    if (_paramsString != nil && [_paramsString length] > 0) {
        fullStr = [fullStr stringByAppendingString:_paramsString];
    }
    
    return [[NSURL alloc] initWithString:fullStr];
}

-(NSString*)getMethodString {
    switch ([self methodType]) {
        case VK_DELETE_METHOD:
            return @"DELETE";
            break;
            
        case VK_PUT_METHOD:
            return @"PUT";
            break;
            
        case VK_POST_METHOD:
            return @"POST";
            break;
            
        default:
            return @"GET";
            break;
    }
}

#pragma mark - other
-(NSMutableURLRequest*)convertToURLRequest {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]
                                     initWithURL:[self getFinalURL]];
    [request setHTTPMethod:[self getMethodString]];
    [request setValue:[self contentType] forHTTPHeaderField:@"Content-type"];
    
    if (self.body != nil && [self.body count] != 0) {
        [request setHTTPBody:self.bodyNSData];
    }
    if (self.httpHeaders && [self.httpHeaders count] != 0) {
        for (NSString* key in self.httpHeaders) {
            NSString* value = self.httpHeaders[key];
            
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    return request;
}

@end
