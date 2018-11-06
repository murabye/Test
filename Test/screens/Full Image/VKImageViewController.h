//
//  VKImageViewController.h
//  Test
//
//  Created by варя on 22.09.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;
@property (strong, nonatomic) NSString* urlStr;

@end
