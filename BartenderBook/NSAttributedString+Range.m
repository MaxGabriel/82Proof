//
//  NSAttributedString+Range.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import "NSAttributedString+Range.h"

@implementation NSAttributedString (Range)

- (NSRange)range
{
    return NSMakeRange(0, self.length);
}

- (BOOL)containsAttribute:(NSString *)attributeName
{
    __block BOOL containsAttribute = NO;
    [self enumerateAttribute:attributeName
                                     inRange:self.range
                                     options:0
                                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                                      if (value) {
                                          containsAttribute = YES;
                                          *stop = YES;
                                      }
                                  }];
    return containsAttribute;
}

- (BOOL)containsAttribute:(NSString *)attributeName withValue:(id)value
{
    __block BOOL containsAttribute = NO;
    [self enumerateAttribute:attributeName
                     inRange:self.range
                     options:0
                  usingBlock:^(id currentValue, NSRange range, BOOL *stop) {
                      if ([currentValue isEqual:value]) {
                          containsAttribute = YES;
                          *stop = YES;
                      }
                  }];
    return containsAttribute;
}

@end
