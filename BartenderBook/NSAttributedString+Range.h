//
//  NSAttributedString+Range.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Range)

@property (nonatomic, readonly) NSRange range;

- (BOOL)containsAttribute:(NSString *)attributeName;
- (BOOL)containsAttribute:(NSString *)attributeName withValue:(id)value;

@end
