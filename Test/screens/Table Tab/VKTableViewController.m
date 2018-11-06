//
//  VKTableViewController.m
//  Test
//
//  Created by Вова Петров on 27.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKTableViewController.h"
#import "VKOneImageViewCell.h"
#import "VKRequest.h"
#import "VKResponse.h"
#import "VKRequestManager.h"
#import "VKBigImageController.h"

@interface VKTableViewController ()
@property (strong, nonatomic) NSMutableArray* vkTableData;
@end

@implementation VKTableViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vkTableData = [[NSMutableArray alloc] init];
    
    VKRequest* requestPhotoList = [[VKRequest alloc] init];
    NSDictionary *params = @{
                            @"lat": @"30",
                            @"long": @"30",
                            @"count": @"20",
                            @"radius": @"5000",
                            @"v": @"5.85",
                            @"access_token":
                                @"26da37e826da37e826da37e8bb26bc2ab7226da26da37e87d416f5c1860b34037297d66"
                            };
    requestPhotoList.params = params;
    
    [[VKRequestManager shared] sendRequest:requestPhotoList withCompletionHandler:^(VKResponse *result) {
        NSDictionary* dict = result.parsedResponse;
        dict = [dict objectForKey:@"items"];
        for (NSDictionary* photoElem in dict) {
            NSArray* sizes = [photoElem objectForKey:@"sizes"];
            [self.vkTableData addObject:sizes];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self vkTableData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    VKOneImageViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.vkImageView.image = [UIImage imageNamed:@"dog"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSDictionary* neededSize = [self getSizeWith: @"x"
                                                from:[self.vkTableData objectAtIndex:indexPath.row]];
        
        NSString* urlStr = [neededSize objectForKey:@"url"];
        NSURL* url = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL: url];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.vkImageView.image = image;
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* neededSize = [self getSizeWith: @"x"
                                            from:[self.vkTableData objectAtIndex:indexPath.row]];
    if (!neededSize) {
        return 0;
    }
    
    NSString* widthStr = [neededSize objectForKey:@"width"];
    NSString* heightStr = [neededSize objectForKey:@"height"];
    
    NSInteger width = [widthStr integerValue];
    NSInteger height = [heightStr integerValue];
    
    double ratio = (double)height / (double)width;
    double outputHeight = ratio * UIScreen.mainScreen.bounds.size.width;
    
    return ( round(outputHeight) );
}

#pragma mark - select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"FromTableToBig" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromTableToBig"]) {
        VKBigImageController *page = segue.destinationViewController;
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        
        NSDictionary* neededSize = [self getSizeWith: @"x"
                                                from:[self.vkTableData objectAtIndex:indexPath.row]];
        if (!neededSize) {
            return;
        }
        
        page.imageData = neededSize;
    }
}

/*
#pragma mark - Alert
- (void) showAlertWithMessage: (NSString *)message title: (NSString *)title {
    NSString *okText = @"OK";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:okText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods
- (NSDictionary*) getSizeWith: (NSString*)mark from:(NSDictionary*)sizeCollection {
    NSDictionary* neededSize;
    for (NSDictionary * sizeParameters in sizeCollection) {
        if ([[sizeParameters objectForKey:@"type"]  isEqual: mark]) {
            neededSize = [NSDictionary dictionaryWithDictionary:sizeParameters];
            break;
        }
    }
    return neededSize;
}

@end
