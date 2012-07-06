//
//  Ingredient+Create.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ingredient+Create.h"

@implementation Ingredient (Create)

+ (Ingredient *)ingredientWithName:(NSString *)name
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    Ingredient *ingredient = nil;
    
    ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    
    ingredient.name = name;
    
    return ingredient;
}

@end
