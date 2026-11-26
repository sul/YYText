//
//  YYTextCopyPasteExample.m
//  YYKitExample
//
//  Created by ibireme on 15/9/12.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextCopyPasteExample.h"
#import "YYText.h"
#import "UIImage+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYTextExampleHelper.h"

static NSString *const kGIFUTType = @"com.compuserve.gif";
static NSString *const kAttachmentDataKey = @"imageData";
static NSString *const kAttachmentTypeKey = @"imageType";

@interface YYTextCopyPasteExample ()<YYTextViewDelegate>
@property (nonatomic, assign) YYTextView *textView;
@end

@implementation YYTextCopyPasteExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSString *text = @"You can copy image from browser or photo album and paste it to here. It support animated GIF and APNG. \n\nYou can also copy attributed string from other YYTextView.\n\nCopy this animated GIF and paste it to other apps: ";
    
    YYTextSimpleMarkdownParser *parser = [YYTextSimpleMarkdownParser new];
    [parser setColorWithDarkTheme];
    
    YYTextView *textView = [YYTextView new];
    textView.text = text;
    textView.font = [UIFont systemFontOfSize:17];
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.allowsPasteImage = YES; /// Pasts image
    textView.allowsPasteAttributedString = YES; /// Paste attributed string
    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:textView];
    self.textView = textView;
    
    NSString *path = [[NSBundle mainBundle] pathForScaledResource:@"022" ofType:@"gif" inDirectory:@"EmoticonQQ.bundle"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    YYTextAttachment *attachment = [self attachmentWithImageData:gifData type:kGIFUTType];
    if (attachment) {
        NSMutableAttributedString *attText = textView.attributedText.mutableCopy;
        UIView *view = attachment.content;
        NSMutableAttributedString *gifText = [NSMutableAttributedString yy_attachmentStringWithContent:view contentMode:UIViewContentModeCenter attachmentSize:view.size alignToFont:textView.font alignment:YYTextVerticalAlignmentCenter];
        [gifText yy_setTextAttachment:attachment range:NSMakeRange(0, gifText.length)];
        [attText appendAttributedString:gifText];
        [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        textView.attributedText = attText;
    }
    
    textView.selectedRange = NSMakeRange(textView.text.length, 0);
    [textView becomeFirstResponder];
}

/// Decode GIF/APNG data with your own decoder, and keep the encoded data in `userInfo` for copying.
- (YYTextAttachment *)attachmentWithImageData:(NSData *)data type:(NSString *)type {
    UIImage *image = [UIImage yy_imageWithSmallGIFData:data scale:2];
    if (!image) return nil;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    YYTextAttachment *attachment = [YYTextAttachment attachmentWithContent:imageView];
    attachment.userInfo = @{kAttachmentDataKey : data, kAttachmentTypeKey : type};
    return attachment;
}

#pragma mark - YYTextViewDelegate (custom image encoding)

- (NSArray<NSDictionary<NSString *, id> *> *)textView:(YYTextView *)textView pasteboardItemsForAttachment:(YYTextAttachment *)attachment {
    NSData *data = attachment.userInfo[kAttachmentDataKey];
    NSString *type = attachment.userInfo[kAttachmentTypeKey];
    if (!data || !type) return nil;
    return @[@{type : data}];
}

- (id)textView:(YYTextView *)textView attachmentContentFromPasteboard:(UIPasteboard *)pasteboard {
    NSData *gif = pasteboard.yy_GIFData;
    if (gif) return [self attachmentWithImageData:gif type:kGIFUTType];
    NSData *png = pasteboard.yy_PNGData; // APNG
    if (png) return [self attachmentWithImageData:png type:@"public.png"];
    return nil;
}

- (void)edit:(UIBarButtonItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
