//
//  RSTransitionEffectViewController.m
//  MJTransitionEffect
//
//  Created by R0CKSTAR on 12/11/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "RSTransitionEffectViewController.h"

#import "RSBasicItem.h"

@interface RSTransitionEffectViewController ()

@property (nonatomic, strong) UIColor *backgroundColor;

- (void)__bindItem;

- (void)__prepareTargetFrames;

- (void)__changeFrames:(BOOL)is2Source;

@end

@implementation RSTransitionEffectViewController

#pragma mark - Private

- (void)__bindItem
{
    self.textLabel.text = self.item.text;
    self.detailTextLabel.text = self.item.detailText;
    self.imageView.image = self.item.image;
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
}

- (void)__prepareTargetFrames
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

- (void)__changeFrames:(BOOL)is2Source
{
    NSDictionary *frames = nil;
    CGRect toolbarFrame = self.toolbar.frame;
    if (is2Source) {
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    
    [self __bindItem];
    
    [self __prepareTargetFrames];
    
    [self __changeFrames:YES];
    
    [UIView animateWithDuration:1.0f animations:^{
        [self __changeFrames:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        [self __changeFrames:YES];
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

@end
