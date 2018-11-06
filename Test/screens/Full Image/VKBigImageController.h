//
//  VKBigImageController.h
//  Test
//
//  Created by варя on 22.09.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKBigImageController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fullImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (strong, nonatomic) NSDictionary* imageData;

@end
