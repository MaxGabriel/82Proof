//
//  Ingredient+Create.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ingredient.h"

@interface Ingredient (Create)

+ (Ingredient *)ingredientWithName:(NSString *)name
            inManagedObjectContext:(NSManagedObjectContext *)context;

@end
