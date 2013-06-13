//
//  ATheme.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import "ATheme.h"

@implementation ATheme

- (UIFont *)recipeNameFont
{
    return [UIFont fontWithName:kGoudyBookletter size:32];
}
- (UIFont *)ingredientFont
{
    return [UIFont fontWithName:kGoudyBookletter size:20];
}
- (UIFont *)notesLabelFont
{
    return [UIFont fontWithName:kGoudyBookletter size:16]; // was 15
}

@end
