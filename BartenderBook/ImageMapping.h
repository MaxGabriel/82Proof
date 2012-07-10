//
//  ImageMapping.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

@interface ImageMapping : NSObject


@property (nonatomic, strong) OrderedDictionary *methodDictionary;
@property (nonatomic, strong) OrderedDictionary *glassDictionary;
@property (nonatomic, strong) OrderedDictionary *iceDictionary;
@property (nonatomic, strong) OrderedDictionary *garnishDictionary;

+ (ImageMapping *)sharedInstance;

@end
