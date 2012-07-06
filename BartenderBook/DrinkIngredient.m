//
//  DrinkIngredient.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkIngredient.h"

@implementation DrinkIngredient

@synthesize name = _name;
@synthesize amount = _amount;

- (DrinkIngredient *)initWithName:(NSString *)name andAmount:(NSNumber *)amount
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.amount = amount;
    }
    
    return self;
}

@end
