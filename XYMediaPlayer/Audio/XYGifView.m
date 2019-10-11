//
//  XYGifView.m
//  LGTeachCloud
//
//  Created by wuxiaoyuan on 2019/8/21.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "XYGifView.h"

@implementation XYGifView

- (void)presentationGIFImageWithPath:(NSString *)path duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    if (path.length != 0) {
        [self decompositionImageWithPath:path duration:duration repeatCount:repeatCount];
    }
}
- (void)decompositionImageWithPath:(NSString *)path duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    NSMutableArray *gifImages = [NSMutableArray array];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithData(CFBridgingRetain(gifData), nil);
    //获取Gif图有多少帧
    NSInteger count = CGImageSourceGetCount(gifSource);
    for (int i = 0; i < count; i++) {
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, nil);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        if (image) {
            [gifImages addObject:image];
        }
        CGImageRelease(imageRef);
    }
    
    CFRelease(gifSource);
    
    [self displayGifWithGifImages:gifImages Duration:duration repeatCount:repeatCount];
}
- (void)displayGifWithGifImages:(NSArray *)images Duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    self.animationImages = images;
    self.animationDuration = duration;
    self.animationRepeatCount = repeatCount;
}

@end
