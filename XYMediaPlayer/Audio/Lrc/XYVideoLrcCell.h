//
//  XYVideoLrcCell.h
//  LGIJKPlayerDemo
//
//  Created by wuxiaoyuan on 2019/8/14.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XYVideoLrcCell : UITableViewCell

/** 字幕 */
@property (nonatomic,copy) NSString *lrcText;
/** 是否选中 */
@property (nonatomic,assign) BOOL choiced;


@end


