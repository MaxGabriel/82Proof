//
//  Theme.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import "Theme.h"
#import "ATheme.h"

@implementation Theme

// Font names

NSString * const kDearJoeCasualFontName = @"DearJoe5CASUAL";


NSString * const kOstrichSansRoundedMedium = @"OstrichSansRounded-Medium";

NSString * const kGoudyBookletter = @"GoudyBookletter1911";

+ (instancetype)sharedTheme
{
    static id <BBTheme> theme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theme = [[ATheme alloc] init];
    });
    return theme;
}



@end
