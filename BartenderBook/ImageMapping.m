//
//  ImageMapping.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageMapping.h"

@implementation ImageMapping


@synthesize methodDictionary = _methodDictionary;
@synthesize glassDictionary = _glassDictionary;
@synthesize garnishDictionary = _garnishDictionary;
@synthesize iceDictionary = _iceDictionary;

+ (ImageMapping *)sharedInstance
{
    static ImageMapping *instance = nil;
    
    
    if (!instance) {
        instance = [[ImageMapping alloc] init];
        
        instance.methodDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"cobblerShaker.png",@"Shake",@"blender.png",@"Blend",@"spoons4.png",@"Stir",@"dryShake.png",@"Dry Shake",@"Layer.png",@"Layer",@"whipper2.png",@"Whipper", nil];
                
        instance.glassDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"collins.png",@"Collins",@"Martini2.png",@"Cocktail",@"rocksGlass.png",@"Rocks",@"straightShotGlass.png",@"Shot",@"margarita.png",@"Margarita",@"snifter.png",@"Snifter",@"PousseCafe.png",@"Pousse-Café",@"hurricaneWhite.png",@"Hurricane", nil];
        
        
        instance.iceDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ice140x151.png",@"On the Rocks",@"no-Ice140x151.png",@"No Ice",@"malletWithCracked2.png",@"Cracked",@"tallSnowCone.png",@"Shaved", nil];
        
        instance.garnishDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"cherryBig.png",@"Cherry",@"olive.png",@"Olive",@"celeryStickBig.png",@"Celery Stick",@"limeWheel2.png",@"Lime Wheel",@"mint2.png",@"Mint",@"bigPineapple.png",@"Pineapple", nil];
    }
    
    return instance;
}

@end
