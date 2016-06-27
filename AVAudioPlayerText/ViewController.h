//
//  ViewController.h
//  AVAudioPlayerText
//
//  Created by 曲天白 on 16/6/23.
//  Copyright © 2016年 曲天白. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController<AVAudioPlayerDelegate>

@property (nonatomic , strong) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *info1;

@property (weak, nonatomic) IBOutlet UILabel *info2;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIImageView *artistV;

@property (copy , nonatomic) NSMutableArray *songArray;


@end

