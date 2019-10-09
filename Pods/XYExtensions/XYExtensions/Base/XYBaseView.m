//
//  XYBaseView.m
//  XYExtensionsDemo
//
//  Created by wuxiaoyuan on 2019/9/30.
//  Copyright © 2019 lange. All rights reserved.
//

#import "XYBaseView.h"

@implementation XYBaseView

/** when `-init` this method will be called */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
    [self setupSubviews];
}

- (void)configure {
    
}

- (void)setupSubviews {
    
}

+ (instancetype)newFromNib {
    id instance = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    return instance;
}

@end
