//
//  XYAlertViewButton.m
//  XYAlertView
//
//
//

#import "XYAlertViewButton.h"
#import "XYAlertViewHelper.h"

@implementation XYAlertViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.imageView.backgroundColor = UIColor.clearColor;

        self.contentEdgeInsets = UIEdgeInsetsMake(XYAlertViewPaddingHeight,
                                                  XYAlertViewPaddingWidth,
                                                  XYAlertViewPaddingHeight,
                                                  XYAlertViewPaddingWidth);

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }

    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleLabelFrame = self.titleLabel.frame;

    if (self.iconPosition == XYAlertViewButtonIconPositionLeft) {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + XYAlertViewButtonImageOffsetFromTitle;
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right;
        }
        else {
            imageViewFrame.origin.x -= XYAlertViewButtonImageOffsetFromTitle / 2.0;
            titleLabelFrame.origin.x += XYAlertViewButtonImageOffsetFromTitle / 2.0;
        }
    }
    else {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            titleLabelFrame.origin.x = self.contentEdgeInsets.left;
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
            titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - XYAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
        }
        else {
            imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + (XYAlertViewButtonImageOffsetFromTitle / 2.0);
            titleLabelFrame.origin.x -= CGRectGetWidth(imageViewFrame) + (XYAlertViewButtonImageOffsetFromTitle / 2.0);
        }
    }

    if (XYAlertViewHelper.isNotRetina) {
        imageViewFrame = CGRectIntegral(imageViewFrame);
    }

    self.imageView.frame = imageViewFrame;

    if (XYAlertViewHelper.isNotRetina) {
        titleLabelFrame = CGRectIntegral(imageViewFrame);
    }

    self.titleLabel.frame = titleLabelFrame;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[XYAlertViewHelper image1x1WithColor:color] forState:state];
}

@end
