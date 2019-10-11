//
//  XYAudioLrcView.m
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYAudioLrcView.h"
#import <Masonry/Masonry.h>
#import "XYMediaLrcModel.h"
#import "XYAudioLrcCell.h"
#import "XYAudioLrcView.h"

//NSString *const XYLVoiceTextPlayerViewPausePlayNotification = @"XYVoiceTextPlayerViewPausePlayNotification";
@interface XYAudioLrcView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) BOOL isStopLook;
@end

@implementation XYAudioLrcView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutUI];
//        self.isStopLook = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseVoicePlayer) name:XYLVoiceTextPlayerViewPausePlayNotification object:nil];
    }
    return self;
}

- (void)layoutUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setSrtModel:(XYMediaLrcModel *)srtModel{
    _srtModel = srtModel;
    [self.tableView reloadData];
}
- (void)setCurrentTime:(CGFloat)currentTime{
    _currentTime = currentTime;
    XYMediaLrcInfoModel *firstInfo = self.srtModel.srtList.firstObject;
    if (currentTime == 0 || currentTime < firstInfo.beginTime) {
        if (self.currentIndex > 0) {
            NSIndexPath *lastIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            XYAudioLrcCell *lastCell = [self.tableView cellForRowAtIndexPath:lastIndexP];
            lastCell.choiced = NO;
            self.currentIndex = 0;
            NSIndexPath *currentIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            XYAudioLrcCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexP];
            currentCell.choiced = YES;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else{
        NSIndexPath *lastIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        XYAudioLrcCell *lastCell = [self.tableView cellForRowAtIndexPath:lastIndexP];
        lastCell.choiced = NO;
        for (int i = 0; i < self.srtModel.srtList.count; i++) {
            if (i == self.srtModel.srtList.count -1) {
                self.currentIndex = i;
                //                XYMediaLrcInfoModel *currentInfo = self.srtModel.srtList[i];
                //                if (currentTime > currentInfo.beginTime) {
                //                    [self scrollToIndex:i];
                //                }
            }else{
                XYMediaLrcInfoModel *currentInfo = self.srtModel.srtList[i];
                XYMediaLrcInfoModel *nextInfo = self.srtModel.srtList[i+1];
                if (currentTime/currentInfo.beginTime >= 0.99 &&
                    currentTime < nextInfo.beginTime) {
                    self.currentIndex = i;
                    break;
                }
                //                NSInteger cTime = (NSInteger)(currentTime * 1000);
                //                NSInteger lTime = (NSInteger)(currentInfo.beginTime * 1000);
                //                NSInteger nTime = (NSInteger)(nextInfo.beginTime * 1000);
                //
                //                if (cTime > lTime && cTime < nTime) {
                //                    [self scrollToIndex:i];
                //                    break;
                //                }
            }
        }
        NSIndexPath *currentIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        XYAudioLrcCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexP];
        currentCell.choiced = YES;
        [self.tableView scrollToRowAtIndexPath:currentIndexP atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.srtModel.srtList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYAudioLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYAudioLrcCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XYMediaLrcInfoModel *infoModel = self.srtModel.srtList[indexPath.row];
    cell.lrcText = infoModel.subtitles;
    if (indexPath.row == self.currentIndex) {
        cell.choiced = YES;
    }else{
        cell.choiced = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   XYMediaLrcInfoModel *infoModel = self.srtModel.srtList[indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(XYMediaLrcView:seekToTime:)]) {
//        [self.delegate XYMediaLrcView:self seekToTime:infoModel.beginTime];
//    }
}

#pragma mark -scroller
//- (void)scrollToIndex:(NSInteger)index{
//    self.currentIndex = index;
//    NSIndexPath *currentIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
//    XYAudioLrcCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexP];
//    currentCell.choiced = YES;
//    if (self.isStopLook) {
//        [self.tableView scrollToRowAtIndexPath:currentIndexP atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    }
//
//}
//- (void)pauseVoicePlayer{
//    self.isStopLook = YES;
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.isStopLook = NO;
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(startScroll)]) {
        [self.scrollDelegate startScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(endScroll)]) {
        [self.scrollDelegate endScroll];
    }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.isStopLook = YES;
//}


#pragma mark -lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 30;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XYAudioLrcCell class] forCellReuseIdentifier:NSStringFromClass([XYAudioLrcCell class])];
    }
    return _tableView;
}

@end
