//
//  RSTransitionEffectViewController.m
//  RSTransitionEffect
//
//  Created by R0CKSTAR on 12/11/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSTransitionEffectViewController.h"

#import "RSBasicItem.h"

@interface RSTransitionEffectViewController ()

@property (nonatomic, strong) NSDictionary *targetFrames;

@property (nonatomic, strong) UIColor *backgroundColor;

- (void)__bindItem;

- (void)__buildTargetFrames;

- (void)__switchToSourceFrames:(BOOL)isSource;

@end

@implementation RSTransitionEffectViewController

#pragma mark - Private

- (void)__bindItem
{
    self.imageView.image = self.item.image;
    self.textLabel.text = self.item.text;
    [self.textLabel sizeToFit];
    self.detailTextLabel.text = self.item.detailText;
    [self.detailTextLabel sizeToFit];
}

- (void)__buildTargetFrames
{
    NSMutableDictionary *frames = [NSMutableDictionary dictionary];
    
    [frames setObject:[NSValue valueWithCGRect:self.cell.frame] forKey:@"cell"];
    
    [frames setObject:[NSValue valueWithCGRect:self.imageView.frame] forKey:@"imageView"];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = roundf((self.view.bounds.size.width - frame.size.width) / 2.0f);
    [frames setObject:[NSValue valueWithCGRect:frame] forKey:@"textLabel"];
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = roundf((self.view.bounds.size.width - frame.size.width) / 2.0f);
    [frames setObject:[NSValue valueWithCGRect:frame] forKey:@"detailTextLabel"];
    
    self.targetFrames = [NSDictionary dictionaryWithDictionary:frames];
}

- (void)__switchToSourceFrames:(BOOL)isSource
{
    NSDictionary *frames = nil;
    CGRect toolbarFrame = self.toolbar.frame;
    if (isSource) {
        frames = self.sourceFrames;
        self.backgroundView.alpha = 1;
        toolbarFrame.origin.y += toolbarFrame.size.height;
    } else {
        frames = self.targetFrames;
        self.backgroundView.alpha = 0;
        toolbarFrame.origin.y -= toolbarFrame.size.height;
    }
    
    self.cell.frame = [[frames objectForKey:@"cell"] CGRectValue];
    self.imageView.frame = [[frames objectForKey:@"imageView"] CGRectValue];
    self.textLabel.frame = [[frames objectForKey:@"textLabel"] CGRectValue];
    self.detailTextLabel.frame = [[frames objectForKey:@"detailTextLabel"] CGRectValue];
    self.toolbar.frame = toolbarFrame;
}

#pragma mark - RSTransitionEffectViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [window.layer renderInContext:context];
        self.backgroundColor = [UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        self.animationDuration = 1.0f;
        
        self.cellBackgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    
    self.cell.backgroundColor = self.cellBackgroundColor;
    
    [self __bindItem];
    
    [self __buildTargetFrames];
    
    [self __switchToSourceFrames:YES];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self __switchToSourceFrames:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self __switchToSourceFrames:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.cell.alpha = 0;
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
}

@end
