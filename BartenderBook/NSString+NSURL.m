//
//  NSString+NSURL.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/1/13.
//
//

#import "NSString+NSURL.h"

@implementation NSString (NSURL)

- (NSURL *)URL
{
    return [NSURL URLWithString:self];
}

@end
