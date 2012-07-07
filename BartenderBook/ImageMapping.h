//
//  ImageMapping.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMapping : NSObject


@property (nonatomic, strong) NSDictionary *methodDictionary;
@property (nonatomic, strong) NSDictionary *glassDictionary;
@property (nonatomic, strong) NSDictionary *iceDictionary;
@property (nonatomic, strong) NSDictionary *garnishDictionary;

+ (ImageMapping *)sharedInstance;

@end
