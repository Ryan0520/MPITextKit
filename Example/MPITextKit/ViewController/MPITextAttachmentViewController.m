//
//  MPITextAttachmentViewController.m
//  MPITextKit_Example
//
//  Created by Tpphha on 2019/3/31.
//  Copyright © 2019 美图网. All rights reserved.
//

#import "MPITextAttachmentViewController.h"
#import <RMPITextKit/MPITextKit.h>
#import <YYImage/YYImage.h>

#import "MPIExampleHelper.h"

#import "NSBundle+MPIExample.h"
#import "UIView+MPIExample.h"

@interface MPITextAttachmentViewController () <
    MPILabelDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic, strong) MPILabel *mpiLabel;

@property (nonatomic, strong) UIView *dotView;

@end

@implementation MPITextAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MPIExampleHelper addDebugOptionToViewController:self];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    {
        NSString *title = @"This is top aligned  UIView attachment: ";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        UISwitch *switcher = [UISwitch new];
        [switcher sizeToFit];
        switcher.on = YES;
        
        MPITextAttachment *at = [MPITextAttachment new];
        at.content = switcher;
        at.verticalAligment = MPITextVerticalAlignmentTop;
        NSMutableAttributedString *attachText = [[NSMutableAttributedString attributedStringWithAttachment:at] mutableCopy];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }
    
    {
        NSString *title = @"This is center aligned UIImage attachment:";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        MPITextAttachment *attach = [MPITextAttachment new];
        attach.content = image;
        NSMutableAttributedString *attachText = [[NSAttributedString attributedStringWithAttachment:attach] mutableCopy];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }
    
    {
        NSString *title = @"This is bottom aligned UIView attachment: ";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        UISwitch *switcher = [UISwitch new];
        [switcher sizeToFit];
        switcher.on = YES;
        
        MPITextAttachment *at = [MPITextAttachment new];
        at.content = switcher;
        at.verticalAligment = MPITextVerticalAlignmentBottom;
        NSMutableAttributedString *attachText = [[NSMutableAttributedString attributedStringWithAttachment:at] mutableCopy];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }
    
    {
        NSString *title = @"This is Animated Image attachment:";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        NSArray *names = @[@"001", @"022", @"019",@"056",@"085"];
        for (NSString *name in names) {
            NSString *path = [[NSBundle mainBundle] pathForScaledResource:name ofType:@"gif" inDirectory:@"EmoticonQQ.bundle"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            YYImage *image = [YYImage imageWithData:data scale:2];
            image.preloadAllAnimatedImageFrames = YES;
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
            
            MPITextAttachment *attach = [MPITextAttachment new];
            attach.content = imageView;
            NSMutableAttributedString *attachText = [[NSAttributedString attributedStringWithAttachment:attach] mutableCopy];
            [text appendAttributedString:attachText];
        }
        
        YYImage *image = [YYImage imageNamed:@"pia"];
        image.preloadAllAnimatedImageFrames = YES;
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.autoPlayAnimatedImage = NO;
        [imageView startAnimating];
        
        MPITextAttachment *attach = [MPITextAttachment new];
        attach.content = imageView;
        attach.verticalAligment = MPITextVerticalAlignmentBottom;
        NSMutableAttributedString *attachText = [[NSAttributedString attributedStringWithAttachment:attach] mutableCopy];
        [attachText addAttribute:MPITextBackedStringAttributeName
                           value:[MPITextBackedString stringWithString:@":)"]
                           range:attachText.mpi_rangeOfAll];
        [text appendAttributedString:attachText];
        
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }
    
    [text addAttribute:NSFontAttributeName value:font range:text.mpi_rangeOfAll];
    
    _mpiLabel = [MPILabel new];
    _mpiLabel.numberOfLines = 0;
    _mpiLabel.attributedText = text;
    _mpiLabel.truncationAttributedToken = [[NSAttributedString alloc] initWithString:@"..."];
    _mpiLabel.additionalTruncationAttributedMessage = [[NSAttributedString alloc] initWithString:@"more" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000], MPITextLinkAttributeName: [MPITextLink new]}];
    _mpiLabel.selectable = YES;
    _mpiLabel.layer.borderWidth = 0.5;
    _mpiLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000].CGColor;
    _mpiLabel.frame = CGRectMake(0, 0, 260, 300);
    _mpiLabel.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    _mpiLabel.delegate = self;
    [self.view addSubview:_mpiLabel];

    
    UIView *dot = [self newDotView];
    dot.center = CGPointMake(_mpiLabel.width, _mpiLabel.height);
    dot.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [_mpiLabel addSubview:dot];
    
    _dotView = dot;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (UIView *)newDotView {
    UIView *view = [UIView new];
    view.size = CGSizeMake(50, 50);
    
    UIView *dot = [UIView new];
    dot.size = CGSizeMake(10, 10);
    dot.backgroundColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000];
    dot.clipsToBounds = YES;
    dot.layer.cornerRadius = dot.height / 2;
    dot.center = CGPointMake(view.width / 2, view.height / 2);
    [view addSubview:dot];
    
    return view;
}

#pragma mark - Action

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [pan locationInView:self.view];
        CGPoint labelOrigin = _mpiLabel.frame.origin;
        CGSize labelMinSize = CGSizeMake(30, 30);
        
        CGFloat width = location.x - labelOrigin.x;
        CGFloat height = location.y - labelOrigin.y;
        
        if (width < labelMinSize.width ||
            height < labelMinSize.height) {
            return;
        }
        
        _mpiLabel.size = CGSizeMake(width, height);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGRect dotViewFrame = [_dotView convertRect:_dotView.bounds toView:self.view];
    return CGRectContainsPoint(dotViewFrame, location);
}

#pragma mark - MPILabelDelegate

- (void)label:(MPILabel *)label didInteractWithLink:(MPITextLink *)link forAttributedText:(NSAttributedString *)attributedText inRange:(NSRange)characterRange interaction:(MPITextItemInteraction)interaction {
    if (interaction == MPITextItemInteractionTap) {
        [_mpiLabel sizeToFit];
    }
}


@end
