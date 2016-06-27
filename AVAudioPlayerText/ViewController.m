//
//  ViewController.m
//  AVAudioPlayerText
//
//  Created by 曲天白 on 16/6/23.
//  Copyright © 2016年 曲天白. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self.player pause];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    //    接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    //    取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"吴亦凡-时间煮雨" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    self.info1.text = [NSString stringWithFormat:@"当前播放时间%f",self.player.currentTime];
    self.info2.text = [NSString stringWithFormat:@"音频总时长:%f",self.player.duration];
    
    [self setPlayingInfo];
}
- (void)setPlayingInfo {
    //    设置后台播放时显示的东西，例如歌曲名字，图片等
    //    <MediaPlayer/MediaPlayer.h>
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"吴亦凡.jpg"]];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:@"时间煮雨",
                          MPMediaItemPropertyArtist:@"吴亦凡",
                          MPMediaItemPropertyArtwork:artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    
}
#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                if (![_player isPlaying]) {
                    [_player play];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([_player isPlaying]) {
                    [_player pause];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}

- (IBAction)start:(id)sender {
    
    if ([self.player isPlaying]) {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
        [self.player pause];
    }
    else
    {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:0];
        [self.player play];
    }
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    
}


- (IBAction)stop:(id)sender {
    [self.player stop];
    //计时器停止
    [_timer invalidate];
    //释放定时器
    _timer = nil;
}
- (IBAction)previousSong:(id)sender {
    
}
- (IBAction)nextSong:(id)sender {
    
}

-(void)updateProgress{
    //进度条显示播放进度
    self.progress.progress = self.player.currentTime/self.player.duration;
    self.info1.text = [NSString stringWithFormat:@"当前播放时间%f",self.player.currentTime];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (player == _player && flag) {
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
    }
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (player == _player){
        NSLog(@"播放被中断");
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
