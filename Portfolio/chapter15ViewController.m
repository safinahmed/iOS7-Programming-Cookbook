//
//  chapter15ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 26/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter15ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface chapter15ViewController () <UINavigationControllerDelegate, UIVideoEditorControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSURL *videoURLToEdit;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation chapter15ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0)
    {
        NSLog(@"Media type is empty."); return NO;
    }
    NSArray *availableMediaTypes =
    [UIImagePickerController
     availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop)
    {
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType]){
             result = YES;
             *stop= YES; }
     }];
    return result;
}

- (BOOL) doesCameraSupportShootingVideos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie
                          sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFlashAvailableOnFrontCamera
{
    return [UIImagePickerController isFlashAvailableForCameraDevice:
            UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isFlashAvailableOnRearCamera
{
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear];
}

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    NSLog(@"The video editor finished saving video");
    NSLog(@"The edited video path is at = %@", editedVideoPath);
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) canUserPickVideosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static BOOL beenHereBefore = NO;
    if (beenHereBefore)
    {
        /* Only display the picker once as the viewDidAppear: method gets
         called whenever the view of our view controller gets displayed */
        return;
    }
    else
    {
            beenHereBefore = YES;
    }
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    if ([self isPhotoLibraryAvailable] && [self canUserPickVideosFromPhotoLibrary])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        /* Set the source type to photo library */
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        /* And we want our user to be able to pick movies from the library */
        imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeMovie];
        /* Set the delegate to the current view controller */
        imagePicker.delegate = self;
        /* Present our image picker */
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error
{
    NSLog(@"Video editor error occurred = %@", error);
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
{
    NSLog(@"The video editor was cancelled");
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Picker returned successfully.");
    NSString     *mediaType = [info objectForKey:
                               UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        self.videoURLToEdit = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.videoURLToEdit != nil){
            NSString *videoPath = [self.videoURLToEdit path];
            /* First let's make sure the video editor is able to edit the
             video at the path in our documents folder */
            if ([UIVideoEditorController canEditVideoAtPath:videoPath])
            {
                /* Instantiate the video editor */
                UIVideoEditorController *videoEditor =
                [[UIVideoEditorController alloc] init];
                /* We become the delegate of the video editor */
                videoEditor.delegate = self;
                /* Make sure to set the path of the video */
                videoEditor.videoPath = videoPath;
                /* And present the video editor */
                [self presentViewController:videoEditor
                                   animated:YES
                                 completion:nil];
                self.videoURLToEdit = nil;
            }
            else
            {
                NSLog(@"Cannot edit the video at this path");
            }
        }
    }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Picker was cancelled");
    self.videoURLToEdit = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isFrontCameraAvailable])
    {
        NSLog(@"The front camera is available.");
        if ([self isFlashAvailableOnFrontCamera])
        {
        NSLog(@"The front camera is equipped with a flash");
        }
        else{
            NSLog(@"The front camera is not equipped with a flash");
        }
    }
    else
    {
        NSLog(@"The front camera is not available.");
    }
    if ([self isRearCameraAvailable])
    {
        NSLog(@"The rear camera is available.");
        if ([self isFlashAvailableOnRearCamera])
        {
        NSLog(@"The rear camera is equipped with a flash");
        }
        else
        {
            NSLog(@"The rear camera is not equipped with a flash");
        }
    }else{
        NSLog(@"The rear camera is not available.");
    }
    if ([self doesCameraSupportTakingPhotos])
    {
        NSLog(@"The camera supports taking photos.");
    }
    else
    {
        NSLog(@"The camera does not support taking photos");
    }
    if ([self doesCameraSupportShootingVideos])
    {
        NSLog(@"The camera supports shooting videos.");
    }
    else
    {
        NSLog(@"The camera does not support shooting videos.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
