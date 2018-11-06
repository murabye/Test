//
//  VKBigImageControllerViewController.m
//  Test
//
//  Created by варя on 22.09.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKBigImageControllerViewController.h"

@interface VKBigImageControllerViewController ()

@end

@implementation VKBigImageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL* url = [NSURL URLWithString:[self urlStr]];
        NSData *data = [NSData dataWithContentsOfURL: url];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.FullImage.image = image;
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
