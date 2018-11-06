//
//  VKCollectionViewController.m
//  Test
//
//  Created by Вова Петров on 27.08.2018.
//  Copyright © 2018 Varvar Kuznetsova. All rights reserved.
//

#import "VKCollectionViewController.h"
#import "VKCollectionViewCell.h"
#import "VKRequest.h"
#import "VKRequestManager.h"
#import "VKResponse.h"
#import "VKBigImageController.h"

@interface VKCollectionViewController ()
@property (strong, nonatomic) NSMutableArray* collectionData;
@end

@implementation VKCollectionViewController

static NSString * const reuseIdentifier = @"SimpleCollectionItem";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionData = [[NSMutableArray alloc] init];
    
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
            [self.collectionData addObject:sizes];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromCollectionToBig"]) {
        VKBigImageController *page = segue.destinationViewController;
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        
        NSDictionary* neededSize = [self getSizeWith: @"x"
                                                from:[self.collectionData objectAtIndex:indexPath.row]];
        if (!neededSize) {
            return;
        }
        
        page.imageData = neededSize;
    }
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VKCollectionViewCell *cell = [collectionView
                                dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                  forIndexPath:indexPath];

    cell.VKImageView.image =  [UIImage imageNamed:@"dog"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSDictionary* currentElem = [self.collectionData objectAtIndex:indexPath.row];
        NSDictionary* neededSize = [self getSizeWith:@"m" from:currentElem];
        
        NSString* urlStr = [neededSize objectForKey:@"url"];
        NSURL* url = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL: url];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.VKImageView.image = image;
        });
    });
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* neededSize = [self getSizeWith: @"m"
                                            from:[self.collectionData objectAtIndex:indexPath.row]];
    
    if (!neededSize) {
        return CGSizeMake(0, 0);
    }
    
    NSString* widthStr = [neededSize objectForKey:@"width"];
    NSString* heightStr = [neededSize objectForKey:@"height"];
    
    double width = [widthStr doubleValue];
    double height = [heightStr doubleValue];
    
    return CGSizeMake(width, height);
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"FromCollectionToBig" sender:indexPath];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
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
