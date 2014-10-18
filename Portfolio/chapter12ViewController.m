//
//  chapter12ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 26/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter12ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface chapter12ViewController () <AVAudioPlayerDelegate, AVAudioRecorderDelegate, MPMediaPickerControllerDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) MPMediaPickerController *mediaPicker;

@property (nonatomic, strong) MPMusicPlayerController *myMusicPlayer;
@property (nonatomic, strong) UIButton *buttonPickAndPlay;
@property (nonatomic, strong) UIButton *buttonStopPlaying;

@end

@implementation chapter12ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finished playing the song");
    /* The [flag] parameter tells us if the playback was successfully
     finished or not */
    if ([player isEqual:self.audioPlayer])
    {
        self.audioPlayer = nil;
    }
    else
    {
        /* Which audio player is this? We certainly didn't allocate
         this instance! */
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
        NSLog(@"audioPlayerBeginInterruption");
    /* Audio Session is interrupted. The player will be paused here */
    [player pause];
}

- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player
                        withOptions:(NSUInteger)flags
{
     NSLog(@"audioPlayerEndInterruption");
    if (flags == AVAudioSessionInterruptionOptionShouldResume && player != nil)
    {
        [player play];
    }
}

- (NSURL *) audioRecordingPath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    return [documentsFolderUrl URLByAppendingPathComponent:@"Recording.m4a"];
}

- (NSDictionary *) audioRecordingSettings{
    /* Let's prepare the audio recorder options in the dictionary.
     Later we will use this dictionary to instantiate an audio
     recorder of type AVAudioRecorder */
    return @{
             AVFormatIDKey : @(kAudioFormatAppleLossless),
             AVSampleRateKey : @(44100.0f),
             AVNumberOfChannelsKey : @1,
             AVEncoderAudioQualityKey : @(AVAudioQualityLow),
             };
}

- (void) startRecordingAudio
{
    NSError *error=nil;
    NSURL *audioRecordingURL = [self audioRecordingPath];
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:audioRecordingURL
                          settings:[self audioRecordingSettings]
                          error:&error];
    if (self.audioRecorder != nil)
    {
        self.audioRecorder.delegate = self;
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record])
        {
            NSLog(@"Successfully started to record.");
            /* After 5 seconds, let's stop the recording process */
            [self performSelector:@selector(stopRecordingOnAudioRecorder:) withObject:self.audioRecorder
                       afterDelay:15.0f];
        }
        else
        {
            NSLog(@"Failed to record.");
            self.audioRecorder = nil;
        }
    }
    else
    {
        NSLog(@"Failed to create an instance of the audio recorder.");
    }
}

- (void) stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder
{
    /* Just stop the audio recorder here */
    [paramRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag)
    {
        NSLog(@"Successfully stopped the audio recording process.");
        /* Let's try to retrieve the data for the recorded file */
        NSError *playbackError = nil;
        NSError *readingError = nil;
        NSData  *fileData =
        [NSData dataWithContentsOfURL:[self audioRecordingPath]
                              options:NSDataReadingMapped
                                error:&readingError];
        /* Form an audio player and make it play the recorded data */
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                         error:&playbackError];
        /* Could we instantiate the audio player? */
        if (self.audioPlayer != nil)
        {
            self.audioPlayer.delegate = self;
            /* Prepare to play and start playing */
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play])
            {
                NSLog(@"Started playing the recorded audio.");
            }
            else
            {
                NSLog(@"Could not play the audio.");
            }
        }
        else
        {
            NSLog(@"Failed to create an audio player.");
        }
    }
    else
    {
        NSLog(@"Stopping the audio recording failed.");
    }
    /* Here we don't need the audio recorder anymore */
    self.audioRecorder = nil;
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"Recording process is interrupted");
    [recorder pause];
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
                         withOptions:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        //THERE IS NO RESUME, ALL RECORDING WILL BE DONE FROM THE START
        NSLog(@"Resuming the recording...");
        [recorder record];
    }
}

- (void) stopPlayingVideo:(id)paramSender
{
    if (self.moviePlayer != nil)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
    }
}

- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification
{
    /* Find out what the reason was for the player to stop */
    NSNumber *reason =
    paramNotification.userInfo
    [MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil)
    {
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:{
                /* The movie ended normally */
                break; }
            case MPMovieFinishReasonPlaybackError:{
                /* An error happened and the movie ended */ break;
            }
            case MPMovieFinishReasonUserExited:{
                /* The user exited the player */
                break; }
        }
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil];
    }
}

- (void) startPlayingVideo:(id)paramSender{
    /* First let's construct the URL of the file in our application bundle
     that needs to get played by the movie player */
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [mainBundle URLForResource:@"Sample"
                              withExtension:@"m4v"];
    
    /* If we have already created a movie player before,
     let's try to stop it */
    if (self.moviePlayer != nil)
    {
        [self stopPlayingVideo:nil];
    }
    
    /* Now create a new movie player using the URL */
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    if (self.moviePlayer != nil)
    {
        /* Listen for the notification that the movie player sends us
         whenever it finishes playing an audio file */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoHasFinishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        NSLog(@"Successfully instantiated the movie player.");
        /* Scale the movie player to fit the aspect ratio */
        
        self.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES
                               animated:NO];
        /* Let's start playing the video in full screen mode */
        [self.moviePlayer play];
        NSLog(@"Playing Movie");
    }
    else
    {
        NSLog(@"Failed to instantiate the movie player.");
    }
}


- (void) displayMediaPicker {
    self.mediaPicker = [[MPMediaPickerController alloc]
                        initWithMediaTypes:MPMediaTypeAny];
    if (self.mediaPicker != nil)
    {
        NSLog(@"Successfully instantiated a media picker.");
        self.mediaPicker.delegate = self;
        self.mediaPicker.allowsPickingMultipleItems = NO;
        [self.navigationController presentViewController:self.mediaPicker
                                                animated:YES
                                              completion:nil];
        NSLog(@"Could not instantiate a media picker.");
    }
}

- (void) stopPlayingAudio{
    if (self.myMusicPlayer != nil)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object:self.myMusicPlayer];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object:self.myMusicPlayer];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMusicPlayerControllerVolumeDidChangeNotification
         object:self.myMusicPlayer];
        [self.myMusicPlayer stop];
    }
}

- (void) displayMediaPickerAndPlayItem
{
    self.mediaPicker =
    [[MPMediaPickerController alloc]
     initWithMediaTypes:MPMediaTypeAnyAudio];
    if (self.mediaPicker != nil)
    {
        NSLog(@"Successfully instantiated a media picker.");
        self.mediaPicker.delegate = self;
        self.mediaPicker.allowsPickingMultipleItems = YES;
        self.mediaPicker.showsCloudItems = YES;
        self.mediaPicker.prompt = @"Pick a song please...";
        [self.view addSubview:self.mediaPicker.view];
        [self.navigationController presentViewController:self.mediaPicker
                                                animated:YES
                                              completion:nil];
    }
    else
    {
        NSLog(@"Could not instantiate a media picker.");
    }
}

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSLog(@"Media Picker returned");
    /* First, if we have already created a music player, let's
     deallocate it */
    self.myMusicPlayer = nil;
    self.myMusicPlayer = [[MPMusicPlayerController alloc] init];
    [self.myMusicPlayer beginGeneratingPlaybackNotifications];
    /* Get notified when the state of the playback changes */
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(musicPlayerStateChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.myMusicPlayer];
    /* Get notified when the playback moves from one item
     to the other. In this recipe, we are only going to allow
     our user to pick one music file */
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(nowPlayingItemIsChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.myMusicPlayer];
    /* And also get notified when the volume of the
     music player is changed */
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeIsChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.myMusicPlayer];
    /* Start playing the items in the collection */
    [self.myMusicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self.myMusicPlayer play];
    /* Finally dismiss the media picker controller */
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    /* The media picker was cancelled */
    NSLog(@"Media Picker was cancelled");
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void) musicPlayerStateChanged:(NSNotification *)paramNotification
{
    NSLog(@"Player State Changed");
    /* Let's get the state of the player */
    NSNumber *stateAsObject =
    [paramNotification.userInfo
     objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"];
    NSInteger state = [stateAsObject integerValue];
    /* Make your decision based on the state of the player */
    switch (state)
    {
        case MPMusicPlaybackStateStopped:
        {
            /* Here the media player has stopped playing the queue. */
            break;
        }
        case MPMusicPlaybackStatePlaying:
        {
            /* The media player is playing the queue. Perhaps you
             can reduce some processing that your application
             that is using to give more processing power
             to the media player */
            break;
        }
        case MPMusicPlaybackStatePaused:
        {
            /* The media playback is paused here. You might want
             to indicate by showing graphics to the user */
            break;
        }
        case MPMusicPlaybackStateInterrupted:
        {
            /* An interruption stopped the playback of the media queue */ break;
        }
        case MPMusicPlaybackStateSeekingForward:{
            /* The user is seeking forward in the queue */
            break; }
        case MPMusicPlaybackStateSeekingBackward:{
            /* The user is seeking backward in the queue */ break;
        }
    } /* switch (State){ */
}

- (void) nowPlayingItemIsChanged:(NSNotification *)paramNotification
{
    NSLog(@"Playing Item Is Changed");
    NSString *persistentID =
    [paramNotification.userInfo
     objectForKey:@"MPMusicPlayerControllerNowPlayingItemPersistentIDKey"]; /* Do something with Persistent ID */
    NSLog(@"Persistent ID = %@", persistentID);
}

- (void) volumeIsChanged:(NSNotification *)paramNotification
{
    NSLog(@"Volume Is Changed");
    /* The userInfo dictionary of this notification is normally empty */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //CHOOSE SONG AND PLAY
    self.title = @"Media picker...";
    self.buttonPickAndPlay = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonPickAndPlay.frame = CGRectMake(0.0f,
                                              0.0f,
                                              200,
                                              37.0f);
    self.buttonPickAndPlay.center = CGPointMake(self.view.center.x,
                                                self.view.center.y - 50);
    [self.buttonPickAndPlay setTitle:@"Pick and Play"
                            forState:UIControlStateNormal];
    [self.buttonPickAndPlay addTarget:self action:@selector(displayMediaPickerAndPlayItem)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPickAndPlay];
    self.buttonStopPlaying = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonStopPlaying.frame = CGRectMake(0.0f,
                                              0.0f,
                                              200,
                                              37.0f);
    self.buttonStopPlaying.center = CGPointMake(self.view.center.x,
                                                self.view.center.y + 50);
    [self.buttonStopPlaying setTitle:@"Stop Playing"
                            forState:UIControlStateNormal];
    [self.buttonStopPlaying addTarget:self action:@selector(stopPlayingAudio)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonStopPlaying];
    
    
    
    
    //PLAY VIDEO
//    [self startPlayingVideo:nil];
    
    
    
    //PLAY AUDIO IN DIFFERENT CATEGORY
//    NSError *audioSessionError = nil;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    if ([audioSession setCategory:AVAudioSessionCategoryAmbient error:&audioSessionError])
//    {
//        NSLog(@"Successfully set the audio session.");
//    }
//    else
//    {
//        NSLog(@"Could not set the audio session");
//    }
//    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(dispatchQueue, ^(void) {
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSString *filePath = [mainBundle pathForResource:@"MyFX"
//                                                  ofType:@"mp3"];
//        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//        NSError *audioPlayerError = nil;
//        self.audioPlayer = [[AVAudioPlayer alloc]
//                            initWithData:fileData
//                            error:&audioPlayerError];
//        if (self.audioPlayer != nil)
//        {
//            self.audioPlayer.delegate = self;
//            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play])
//            {
//                NSLog(@"Successfully started playing.");
//            }
//            else
//            {
//                NSLog(@"Failed to play the audio file.");
//                self.audioPlayer = nil;
//            }
//        }
//        else
//        {
//            NSLog(@"Could not instantiate the audio player.");
//        }
//    });
    
    //RECORD AUDIO
//    /* Ask for permission to see if we can record audio */
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord
//             withOptions:AVAudioSessionCategoryOptionDuckOthers
//                   error:nil];
//    
//    [session requestRecordPermission:^(BOOL granted) {
//        if(granted)
//            [self startRecordingAudio];
//        else
//            NSLog(@"We don't have permission to record audio.");
//    }];

    
    
    //PLAY AUDIO
//    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(dispatchQueue, ^(void) {
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSString *filePath = [mainBundle pathForResource:@"MyFX"
//                                                  ofType:@"mp3"];
//        NSData *fileData=[NSData dataWithContentsOfFile:filePath];
//        NSError *error = nil;
//        /* Start the audio player */
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
//                                                         error:&error];
//        /* Did we get an instance of AVAudioPlayer? */
//        if (self.audioPlayer != nil)
//        {
//            /* Set the delegate and start playing */
//            self.audioPlayer.delegate = self;
//            if ([self.audioPlayer prepareToPlay] &&
//                [self.audioPlayer play])
//            {
//                NSLog(@"Playing");
//                /* Successfully started playing */
//            }
//            else
//            {
//                NSLog(@"FAILED Playing");
//                /* Failed to play */
//            }
//        }
//        else
//        {
//            NSLog(@"Failed Instantiation");
//                /* Failed to instantiate AVAudioPlayer */
//        }
//    });
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
