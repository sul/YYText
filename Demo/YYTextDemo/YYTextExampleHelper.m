//
//  YYTextExampleHelper.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextExampleHelper.h"
#import "YYText.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"

static BOOL DebugEnabled = NO;

@implementation YYTextExampleHelper

+ (void)addDebugOptionToViewController:(UIViewController *)vc {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:(DebugEnabled ? @"Debug: ON" : @"Debug")
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(_toggleDebug:)];
    vc.navigationItem.rightBarButtonItem = item;
}

+ (void)_toggleDebug:(UIBarButtonItem *)item {
    [self setDebug:!DebugEnabled];
    item.title = DebugEnabled ? @"Debug: ON" : @"Debug";
}

+ (void)setDebug:(BOOL)debug {
    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
    if (debug) {
        debugOptions.baselineColor = [UIColor redColor];
        debugOptions.CTFrameBorderColor = [UIColor redColor];
        debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
        debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
    } else {
        [debugOptions clear];
    }
    [YYTextDebugOption setSharedDebugOption:debugOptions];
    DebugEnabled = debug;
}

+ (BOOL)isDebug {
    return DebugEnabled;
}

@end
