//
//  UIFont+AllFonts.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/30/13.
//
//

#import "UIFont+AllFonts.h"

@implementation UIFont (AllFonts)

+ (NSArray *)allFontNames
{
    NSMutableArray *allFontNames = [@[] mutableCopy];
    for (NSString *familyName in [UIFont familyNames]) {
        [allFontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:familyName]];
    }
    return allFontNames;
}

@end
