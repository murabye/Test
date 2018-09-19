//
//  VKResponse.m
//  Test
//
//  Created by Вова Петров on 31.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKResponse.h"

@implementation VKResponse
-(BOOL)isSuccess {
    return [self code] == VK_REQUEST_STATUS_CODE_SUCCESS;
}

@end
