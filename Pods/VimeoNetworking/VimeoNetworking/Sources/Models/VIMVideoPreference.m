//
//  VIMVideoPreference.m
//  VimeoNetworking
//
//  Created by Hanssen, Alfie on 6/16/15.
//  Copyright (c) 2015 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "VIMVideoPreference.h"

@implementation VIMVideoPreference

#pragma mark - VIMMappable

- (void)didFinishMapping
{
    // In API version 3.3.1, privacy changed from a string to a VIMPrivacy object.
    // This is a migration to convert pre-3.3.1 versions to the new version. [ghking] 2/23/17
    
    if ([self.privacy isKindOfClass:[NSString class]])
    {
        VIMPrivacy *privacy = [VIMPrivacy new];
        privacy.view = (NSString *)self.privacy;
        self.privacy = privacy;
    }
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"privacy"])
    {
        return [VIMPrivacy class];
    }
    
    return nil;
}

@end
