//
//  Recipe+Create.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recipe+Create.h"
#import "Ingredient+Create.h"

@implementation Recipe (Create)

+ (Recipe *)createRecipeWithName:(NSString *)name
                       andMethod:(NSString *)method
                        andGlass:(NSString *)glass
                          andIce:(NSString *)ice
                      andGarnish:(NSString *)garnish
                    andPhotoName:(NSString *)photo
                        andNotes:(NSString *)notes
                  andIngredients:(NSOrderedSet *)ingredients
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    Recipe *recipe = nil;

    recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    
    recipe.name = name;
    recipe.method = method;
    recipe.glass = glass;
    recipe.ice = ice;
    recipe.garnish = garnish;
    recipe.photo = photo;
    recipe.notes = notes;
    
    NSMutableOrderedSet *ingredientsToAdd = [[NSMutableOrderedSet alloc] init];
    for (NSString *ingredient in ingredients) {
        Ingredient *ingredientToAdd = [Ingredient ingredientWithName:ingredient inManagedObjectContext:context];
        [ingredientsToAdd addObject:ingredientToAdd];
    }
    NSOrderedSet *ingredientsFinal = [[NSOrderedSet alloc] initWithOrderedSet:ingredientsToAdd];
    recipe.hasIngredients = ingredientsFinal;
    return recipe;
}

@end
