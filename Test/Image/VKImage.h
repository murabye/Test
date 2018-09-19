//
//  VKImage.h
//  Test
//
//  Created by Вова Петров on 14.09.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VKImage : NSObject

@property (nonatomic) CGSize origSize;
@property (nonatomic, readonly) CGFloat ratio;
@property (nonatomic, readonly) CGSize generedSize;

@property (nonatomic, strong) NSURL * urlPath;
@property (nonatomic, strong) NSURL * filePath;

@end
