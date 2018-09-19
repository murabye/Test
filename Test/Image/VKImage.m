//
//  VKImage.m
//  Test
//
//  Created by Вова Петров on 14.09.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKImage.h"

@implementation VKImage

-(void)setOrigSize:(CGSize)origSize {
    _origSize = origSize;
    _ratio = origSize.height / origSize.width;
    _generedSize.height = .width * _ratio;
}

@end
