//
//  ViewController.m
//  XYMediaPlayerDemo
//
//  Created by wuxiaoyuan on 2019/9/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import "ViewController.h"
#import "XYMediaPlayer.h"
#import "Masonry.h"
#import "XYAlertHUD.h"
@interface ViewController ()<XYLrcScrollProtocal>
@property (nonatomic, strong) UIButton *fullbtn;

@property (nonatomic, strong) XYAudioPlayView *audioView;
@property (nonatomic, copy) NSString *path;//在线地址

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [XYAlert showIndeterminate];
    self.path = @"http://192.168.129.130:10103/TC_TeachCenter_HttpV2/LBD_TeachProgram/12003/71eeeb96-627b-41fa-aaec-088e284c8521/PreClassProgram/TBE092516768/8ecb920e66b84148a7d35f2b364fc670.mp3";
    
    [self creatAudioUI];
}
#pragma mark -UI
- (void)creatAudioUI{
    [self.view addSubview:self.audioView];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.audioView loadDataWithUrl:self.path];
    [XYAlert hide];
    [self.audioView startPlay];
}


- (XYAudioPlayView *)audioView{
    if (!_audioView) {
        _audioView = [[XYAudioPlayView alloc]initWithFrame:CGRectZero];
        _audioView.scrollDelegate = self;
    }
    return _audioView;
}

@end
