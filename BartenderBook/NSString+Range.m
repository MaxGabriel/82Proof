//
//  NSString+Range.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import "NSString+Range.h"

@implementation NSString (Range)

- (NSRange)range
{
    return NSMakeRange(0, self.length);
}

@end
