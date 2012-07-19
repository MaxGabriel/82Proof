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
        
        instance.methodDictionary = [OrderedDictionary dictionaryWithObjectsAndKeys:@"cobblerShaker.png",@"Shake",@"spoons4.png",@"Stir",@"blender.png",@"Blend",@"dryShake.png",@"Dry Shake",@"Layer.png",@"Layer",@"whipper2.png",@"Whipper", @"opaqueNone2.png",@"None", nil];
                
        instance.glassDictionary = [OrderedDictionary dictionaryWithObjectsAndKeys:@"Martini2.png",@"Cocktail",@"collins.png",@"Collins",@"hurricaneWhite.png",@"Hurricane",@"margarita.png",@"Margarita",@"PousseCafe.png",@"Pousse-Café",@"rocksGlass.png",@"Rocks",@"straightShotGlass.png",@"Shot",@"snifter.png",@"Snifter", @"opaqueNone2.png",@"None", nil];
        
        instance.iceDictionary = [OrderedDictionary dictionaryWithObjectsAndKeys:@"ice140x151.png",@"On the Rocks",@"malletWithCracked2.png",@"Cracked",@"tallSnowCone.png",@"Shaved",@"no-Ice140x151.png",@"No Ice", @"opaqueNone2.png",@"None", nil];
        
        instance.garnishDictionary = [OrderedDictionary dictionaryWithObjectsAndKeys:@"cherryBig.png",@"Cherry",@"olive.png",@"Olive",@"limeWedge2D.png",@"Lime",@"limeWheel2.png",@"Lime Wheel",@"lemonWedge.png",@"Lemon",@"bigLemonTwist.png",@"Lemon Twist",@"orangeWedge.png",@"Orange",@"filledZest.png",@"Orange Zest",@"celeryStickBig.png",@"Celery Stick",@"mint2.png",@"Mint",@"bigPineapple.png",@"Pineapple", @"opaqueNone2.png",@"None", nil];
    }
    
    return instance;
}

@end
