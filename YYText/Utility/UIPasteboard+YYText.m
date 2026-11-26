//
//  UIPasteboard+YYText.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/4/2.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIPasteboard+YYText.h"
#import "NSAttributedString+YYText.h"


// Dummy class for category
@interface UIPasteboard_YYText : NSObject @end
@implementation UIPasteboard_YYText @end


NSString *const YYTextPasteboardTypeAttributedString = @"com.ibireme.NSAttributedString";
NSString *const YYTextUTTypeWEBP = @"com.google.webp";

static NSString *const YYTextUTTypePNG = @"public.png";
static NSString *const YYTextUTTypeJPEG = @"public.jpeg";
static NSString *const YYTextUTTypeGIF = @"com.compuserve.gif";
static NSString *const YYTextUTTypeImage = @"public.image";

@implementation UIPasteboard (YYText)


- (void)setYy_PNGData:(NSData *)PNGData {
    [self setData:PNGData forPasteboardType:YYTextUTTypePNG];
}

- (NSData *)yy_PNGData {
    return [self dataForPasteboardType:YYTextUTTypePNG];
}

- (void)setYy_JPEGData:(NSData *)JPEGData {
    [self setData:JPEGData forPasteboardType:YYTextUTTypeJPEG];
}

- (NSData *)yy_JPEGData {
    return [self dataForPasteboardType:YYTextUTTypeJPEG];
}

- (void)setYy_GIFData:(NSData *)GIFData {
    [self setData:GIFData forPasteboardType:YYTextUTTypeGIF];
}

- (NSData *)yy_GIFData {
    return [self dataForPasteboardType:YYTextUTTypeGIF];
}

- (void)setYy_WEBPData:(NSData *)WEBPData {
    [self setData:WEBPData forPasteboardType:YYTextUTTypeWEBP];
}

- (NSData *)yy_WEBPData {
    return [self dataForPasteboardType:YYTextUTTypeWEBP];
}

- (void)setYy_ImageData:(NSData *)imageData {
    [self setData:imageData forPasteboardType:YYTextUTTypeImage];
}

- (NSData *)yy_ImageData {
    return [self dataForPasteboardType:YYTextUTTypeImage];
}

- (void)setYy_AttributedString:(NSAttributedString *)attributedString {
    self.string = [attributedString yy_plainTextForRange:NSMakeRange(0, attributedString.length)];
    NSData *data = [attributedString yy_archiveToData];
    if (data) {
        NSDictionary *item = @{YYTextPasteboardTypeAttributedString : data};
        [self addItems:@[item]];
    }
    [attributedString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(YYTextAttachment *attachment, NSRange range, BOOL *stop) {
        
        // save image
        UIImage *simpleImage = nil;
        if ([attachment.content isKindOfClass:[UIImage class]]) {
            simpleImage = attachment.content;
        } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
            simpleImage = ((UIImageView *)attachment.content).image;
        }
        if (simpleImage) {
            NSDictionary *item = @{@"com.apple.uikit.image" : simpleImage};
            [self addItems:@[item]];
        }
    }];
}

- (NSAttributedString *)yy_AttributedString {
    for (NSDictionary *items in self.items) {
        NSData *data = items[YYTextPasteboardTypeAttributedString];
        if (data) {
            return [NSAttributedString yy_unarchiveFromData:data];
        }
    }
    return nil;
}

@end
