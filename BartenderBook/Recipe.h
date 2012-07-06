// MAX
//  Recipe.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * glass;
@property (nonatomic, retain) NSString * ice;
@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * garnish;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSOrderedSet *hasIngredients;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)insertObject:(Ingredient *)value inHasIngredientsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasIngredientsAtIndex:(NSUInteger)idx;
- (void)insertHasIngredients:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasIngredientsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasIngredientsAtIndex:(NSUInteger)idx withObject:(Ingredient *)value;
- (void)replaceHasIngredientsAtIndexes:(NSIndexSet *)indexes withHasIngredients:(NSArray *)values;
- (void)addHasIngredientsObject:(Ingredient *)value;
- (void)removeHasIngredientsObject:(Ingredient *)value;
- (void)addHasIngredients:(NSOrderedSet *)values;
- (void)removeHasIngredients:(NSOrderedSet *)values;
@end
