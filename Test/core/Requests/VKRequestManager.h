//
//  VKRequestManager.h
//  Test
//
//  Created by Вова Петров on 31.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKResponse.h"
#import "VKRequest.h"

@interface VKRequestManager : NSObject

typedef void (^VKRequestCompletion)(VKResponse* result);

@property (strong, nonatomic) NSURLSession *session;

+ (instancetype) shared;
- (void)sendRequest:(VKRequest*)request withCompletionHandler:(VKRequestCompletion)handler;

@end
