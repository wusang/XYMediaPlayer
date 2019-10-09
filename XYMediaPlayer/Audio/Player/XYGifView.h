//
//  XYGifView.h
//  LGTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/21.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYGifView : UIImageView
- (void)presentationGIFImageWithPath:(NSString *)path duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount;
@end

NS_ASSUME_NONNULL_END
