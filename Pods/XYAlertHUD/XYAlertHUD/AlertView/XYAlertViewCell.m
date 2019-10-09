//
//  XYAlertViewCell.m
//  XYAlertView
//
//
//

#import "XYAlertViewCell.h"
#import "XYAlertViewHelper.h"

@interface XYAlertViewCell ()

@property (readwrite) UIView *separatorView;

@end

@implementation XYAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self clearBackgrounds];

        self.separatorView = [UIView new];
        [self addSubview:self.separatorView];

        self.enabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat frameWidth = CGRectGetWidth(self.bounds);
    CGFloat frameHeight = CGRectGetHeight(self.bounds);

    // -----

    BOOL imageExists = (self.imageView.image != nil);
    CGSize imageSize = self.imageView.image.size;

    CGFloat textLabelMaxWidth;

    if (imageExists) {
        textLabelMaxWidth = frameWidth - (XYAlertViewPaddingWidth * 2.0) - imageSize.width - XYAlertViewButtonImageOffsetFromTitle;
    }
    else {
        textLabelMaxWidth = frameWidth - (XYAlertViewPaddingWidth * 2.0);
    }

    CGRect textLabelFrame = CGRectMake(NSNotFound,
                                       XYAlertViewPaddingHeight,
                                       textLabelMaxWidth,
                                       frameHeight - (XYAlertViewPaddingHeight * 2.0));

    if (self.textLabel.textAlignment == NSTextAlignmentLeft) {
        textLabelFrame.origin.x = XYAlertViewPaddingWidth;

        if (imageExists && self.iconPosition == XYAlertViewButtonIconPositionLeft) {
            textLabelFrame.origin.x += imageSize.width + XYAlertViewButtonImageOffsetFromTitle;
        }
    }
    else if (self.textLabel.textAlignment == NSTextAlignmentRight) {
        textLabelFrame.origin.x = frameWidth - textLabelMaxWidth - XYAlertViewPaddingWidth;

        if (imageExists && self.iconPosition == XYAlertViewButtonIconPositionRight) {
            textLabelFrame.origin.x -= imageSize.width + XYAlertViewButtonImageOffsetFromTitle;
        }
    }
    else {
        textLabelFrame.origin.x = (frameWidth / 2.0) - (textLabelMaxWidth / 2.0);

        if (imageExists) {
            if (self.iconPosition == XYAlertViewButtonIconPositionLeft) {
                textLabelFrame.origin.x += (imageSize.width / 2.0) + (XYAlertViewButtonImageOffsetFromTitle / 2.0);
            }
            else {
                textLabelFrame.origin.x -= (imageSize.width / 2.0) + (XYAlertViewButtonImageOffsetFromTitle / 2.0);
            }
        }
    }

    if (XYAlertViewHelper.isNotRetina) {
        textLabelFrame = CGRectIntegral(textLabelFrame);
    }

    self.textLabel.frame = textLabelFrame;

    // -----

    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;

        CGRect imageViewFrame = CGRectMake(NSNotFound,
                                           (frameHeight / 2.0) - (imageSize.height / 2.0),
                                           imageSize.width,
                                           imageSize.height);

        if (self.textLabel.textAlignment == NSTextAlignmentCenter) {
            CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(textLabelMaxWidth, CGFLOAT_MAX)];
            CGFloat imageAndTextWidth = imageSize.width + textLabelSize.width + XYAlertViewButtonImageOffsetFromTitle;

            if (self.iconPosition == XYAlertViewButtonIconPositionLeft) {
                imageViewFrame.origin.x = (frameWidth / 2.0) - (imageAndTextWidth / 2.0);
            }
            else {
                imageViewFrame.origin.x = (frameWidth / 2.0) + (imageAndTextWidth / 2.0) - imageSize.width;
            }
        }
        else {
            if (self.iconPosition == XYAlertViewButtonIconPositionLeft) {
                imageViewFrame.origin.x = XYAlertViewPaddingWidth;
            }
            else {
                imageViewFrame.origin.x = frameWidth - imageSize.width - XYAlertViewPaddingWidth;
            }
        }

        if (XYAlertViewHelper.isNotRetina) {
            imageViewFrame = CGRectIntegral(imageViewFrame);
        }

        self.imageView.frame = imageViewFrame;
    }

    // -----

    if (!self.separatorView.hidden) {
        self.separatorView.frame = CGRectMake(0.0,
                                              CGRectGetHeight(self.bounds) - XYAlertViewHelper.separatorHeight,
                                              CGRectGetWidth(self.bounds),
                                              XYAlertViewHelper.separatorHeight);
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    if (highlighted) {
        self.textLabel.textColor = self.titleColorHighlighted;
        self.imageView.image = self.imageHighlighted;
        self.backgroundColor = self.backgroundColorHighlighted;
    }
    else {
        [self setEnabled:self.enabled];
    }

    [self clearBackgrounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.textLabel.textColor = self.titleColorHighlighted;
        self.imageView.image = self.imageHighlighted;
        self.backgroundColor = self.backgroundColorHighlighted;
    }
    else {
        [self setEnabled:self.enabled];
    }

    [self clearBackgrounds];
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;

    self.userInteractionEnabled = enabled;

    if (enabled) {
        self.textLabel.textColor = self.titleColor;
        self.imageView.image = self.image;
        self.backgroundColor = self.backgroundColorNormal;
    }
    else {
        self.textLabel.textColor = self.titleColorDisabled;
        self.imageView.image = self.imageDisabled;
        self.backgroundColor = self.backgroundColorDisabled;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeForTextLabel = size;
    sizeForTextLabel.width -= XYAlertViewPaddingWidth * 2.0;

    if (self.imageView.image) {
        sizeForTextLabel.width -= self.imageView.image.size.width + XYAlertViewButtonImageOffsetFromTitle;
    }

    CGSize labelSize = [self.textLabel sizeThatFits:size];

    CGSize resultSize;

    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;

        CGFloat width = MAX(labelSize.width, imageSize.width);
        width = MIN(width, size.width);

        CGFloat height = MAX(labelSize.height, imageSize.height);

        resultSize = CGSizeMake(width, height);
    }
    else {
        resultSize = labelSize;
    }

    resultSize.height += XYAlertViewPaddingHeight * 2.0;

    return resultSize;
}

- (void)clearBackgrounds {
    self.textLabel.backgroundColor = UIColor.clearColor;
    self.imageView.backgroundColor = UIColor.clearColor;
}

@end
