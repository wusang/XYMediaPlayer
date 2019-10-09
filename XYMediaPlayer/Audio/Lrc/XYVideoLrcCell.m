//
//  XYVideoLrcCell.m
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYVideoLrcCell.h"
#import <Masonry/Masonry.h>
#import <XYExtensions/XYExtensions.h>
#import "XYMediaPlayer.h"
@interface XYVideoLrcCell ()

@property (nonatomic,strong) UILabel *labContent;

@end

@implementation XYVideoLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.labContent];
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.left.equalTo(self.contentView).offset(10);
        make.center.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
}

- (void)setLrcText:(NSString *)lrcText{
    _lrcText = lrcText;
    self.labContent.text = lrcText;
}

- (void)setChoiced:(BOOL)choiced{
    _choiced = choiced;
    if (choiced) {
        self.labContent.textColor = XY_ColorWithHex(0x25CDF5);
    }else{
        self.labContent.textColor = XY_ColorWithHex(0x252525);
    }
}

- (UILabel *)labContent{
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.textAlignment = NSTextAlignmentCenter;
        _labContent.textColor = [UIColor whiteColor];
        _labContent.font = [UIFont systemFontOfSize:15];
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
