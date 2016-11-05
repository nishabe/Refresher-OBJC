//
//  PlayerViewController.m
//  Refresher-OBJC
//
//  Created by        on 11/5/16.
//  Copyright © 2016        Inc. All rights reserved.
// Ref: http://stackoverflow.com/questions/25932570/how-to-play-video-with-avplayerviewcontroller-avkit-in-swift
// http://stackoverflow.com/questions/12822420/ios-how-to-use-mpmovieplayercontroller

#import "PlayerViewController.h"
#import <AVKit/AVKit.h>
#import "AVFoundation/AVFoundation.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Utilities.h"

@interface PlayerViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (strong, nonatomic) NSTimer *progressBarTimer;
@property (strong, nonatomic) AVAudioPlayer *localAudioPlayer;
@property (strong, nonatomic) AVPlayer *remoteAudioPlayer;
@property (strong, nonatomic) NSURL *localAudioFileURL;
@property (strong, nonatomic) NSURL *recordedAudioFileURL;
@property (strong, nonatomic) NSString *recordedAudioFilePath;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property BOOL isAudioRecording;
@property BOOL isRecordedAudioPlaying;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation PlayerViewController

#pragma mark View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden=YES;
    [self preaprePlayback];
    [self prepareRecord];
}
- (void)viewDidDisappear:(BOOL)animated{
        [self stopLocalAudio];
        [self stopRemoteAudio];
}

#pragma mark User action handling

- (IBAction)didTapOnAVPlayer:(id)sender {
    // 1.Grab a remote or local URL to our video
    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    //NSURL *videoURL = [[NSBundle mainBundle]URLForResource:@"video" withExtension:@"mp4"];
    // 2. Create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    playerViewController.player = player;
    // 3. Show the view controller
    [self.view addSubview:playerViewController.view];
    [self presentViewController:playerViewController animated:YES completion:nil];
}
- (IBAction)didTapOnMPMoviePlayer:(id)sender {
    // Suppressing a compiler warning. 'MPMoviePlayerViewController', depracated since iOS 9.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];MPMoviePlayerViewController *movieController =
    [[MPMoviePlayerViewController alloc] initWithContentURL: videoURL];
    [self presentMoviePlayerViewControllerAnimated:movieController];
#pragma clang diagnostic pop
    
}

- (IBAction)didTapOnRemoteAudioPlay:(id)sender {
    [self playRemoteAudio];
}

- (IBAction)didTapOnLocalAudioPlay:(id)sender {
    [self playLocalAudio];
}
- (IBAction)didTapOnRecord:(id)sender {
    UIButton* button = (UIButton*)sender;
    if (!self.isRecordedAudioPlaying && !self.isAudioRecording) {
        [self audioRecordingStart];
        self.isAudioRecording = YES;
        NSAttributedString *title=[[NSAttributedString alloc] initWithString:@"Stop Audio Recording"];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        self.activityIndicator.hidden=NO;
        [self.activityIndicator startAnimating];
    }else{
        [self audioRecordingStop];
        NSAttributedString *title=[[NSAttributedString alloc] initWithString:@"Start Audio Recording"];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden=YES;
    }
}
- (IBAction)didTapOnPlayback:(id)sender {
    UIButton* button = (UIButton*)sender;
    if (!self.isRecordedAudioPlaying && !self.isAudioRecording) {
        [self startRecordedAudioPlaying];
        self.isRecordedAudioPlaying =YES;
        NSAttributedString *title=[[NSAttributedString alloc] initWithString:@"Stop Recorded Audio Playing"];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        self.activityIndicator.hidden=NO;
        [self.activityIndicator startAnimating];
    }else{
        [self stopRecordedAudioPlaying];
        NSAttributedString *title=[[NSAttributedString alloc] initWithString:@"Start Recorded Audio Playing"];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden=YES;
    }
    
}
- (IBAction)didTapOnDeleteAudio:(id)sender {
    [self deleteRecordedAudioFile];
}

#pragma mark Private Functions

- (void) playRemoteAudio{
    NSURL *audioURL = [NSURL URLWithString:@"https://blobindiedev.blob.core.windows.net/podcastep/Ep%2019%20Michael%20Hicks%20Pt%202.mp3"];
    NSLog(@"Song URL : %@", audioURL.absoluteString);
    AVPlayerItem *aPlayerItem = [[AVPlayerItem alloc] initWithURL:audioURL];
    self.remoteAudioPlayer = [[AVPlayer alloc] initWithPlayerItem:aPlayerItem];
    [self.remoteAudioPlayer play];
}
- (void) playLocalAudio{
    self.localAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.localAudioFileURL error:nil];
    self.localAudioPlayer.delegate=self;
    [self.localAudioPlayer play];
    self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                             target:self
                                                           selector:@selector(updateProgress)
                                                           userInfo:nil
                                                            repeats:YES];
}
- (void)updateProgress
{
    float timeLeft = self.localAudioPlayer.currentTime/self.localAudioPlayer.duration;
    // upate the UIProgress
    self.audioProgress.progress= timeLeft;
}
-(void) stopLocalAudio{
    [self.progressBarTimer invalidate];
    self.audioProgress.progress= 0.0;
    [self.localAudioPlayer stop];
}
-(void) stopRemoteAudio{
    [self.progressBarTimer invalidate];
    self.audioProgress.progress= 0.0;
    [self.remoteAudioPlayer pause];
}
- (void)preaprePlayback {
    NSString* audioFilePath=[[NSBundle mainBundle] pathForResource:@"Loop 01- Dreamy" ofType:@"mp3"];
    self.localAudioFileURL = [NSURL fileURLWithPath:audioFilePath];
    self.audioProgress.progress= 0.0;
}
- (void)prepareRecord{
    //Audio Recording Setup
    self.recordedAudioFilePath=[Utilities getFileName:nil withExtension:@".m4a"];
    self.recordedAudioFileURL = [NSURL fileURLWithPath:self.recordedAudioFilePath];
    NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:44100],AVSampleRateKey,
                                   [NSNumber numberWithInt: kAudioFormatAppleLossless],AVFormatIDKey,
                                   [NSNumber numberWithInt: 1],AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityMedium],AVEncoderAudioQualityKey,nil];
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:self.recordedAudioFileURL
                          settings:audioSettings
                          error:nil];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [self.audioRecorder prepareToRecord];
    }
}
- (void)audioRecordingStart
{
    self.isAudioRecording=YES;
    if (![self.audioRecorder prepareToRecord])
    {
        NSLog(@"Error: Prepare to record failed");
    }
    [self.audioRecorder record];
}
- (void)audioRecordingStop
{
    self.isAudioRecording=NO;
    self.isRecordedAudioPlaying=NO;
    [self.audioRecorder stop];
}
- (void)startRecordedAudioPlaying
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.recordedAudioFilePath]) {
        self.isRecordedAudioPlaying=YES;
        self.localAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordedAudioFileURL error:nil];
        self.localAudioPlayer.delegate=self;
        [self.localAudioPlayer play];
        self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                                 target:self
                                                               selector:@selector(updateProgress)
                                                               userInfo:nil
                                                                repeats:YES];
        [self.audioProgress setHidden:NO];
    }
}
- (void)stopRecordedAudioPlaying
{
    self.isRecordedAudioPlaying=NO;
    [self.progressBarTimer invalidate];
    [self.localAudioPlayer stop];
    self.audioProgress.progress= 0.0;
    self.audioProgress.hidden=YES;
}
-(void)deleteRecordedAudioFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtURL:self.recordedAudioFileURL error:&error];
}
#pragma mark Delegate Handling
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Audio Playing over!");
}
@end
