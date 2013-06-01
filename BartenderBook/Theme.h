//
//  Theme.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/26/13.
//
//

#import <Foundation/Foundation.h>

@protocol BBTheme <NSObject>

@end

@interface Theme : NSObject

+ (instancetype)sharedTheme;

extern NSString * const kDearJoeCasualFontName;

extern NSString * const kOstrichSansRoundedMedium;

extern NSString * const kGoudyBookletter;

@end
