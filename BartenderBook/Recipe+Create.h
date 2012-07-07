//
//  Recipe+Create.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"

@interface Recipe (Create)
//
//@property (nonatomic, retain) NSString * glass;
//@property (nonatomic, retain) NSString * ice;
//@property (nonatomic, retain) NSString * method;
//@property (nonatomic, retain) NSString * name;
//@property (nonatomic, retain) NSString * garnish;
//@property (nonatomic, retain) NSString * photo;
//@property (nonatomic, retain) NSOrderedSet *hasIngredients;

+ (Recipe *)createRecipeWithName:(NSString *)name
                       andMethod:(NSString *)method
                        andGlass:(NSString *)glass
                          andIce:(NSString *)ice
                      andGarnish:(NSString *)garnish
                    andPhotoName:(NSString *)photo
                        andNotes:(NSString *)notes
                  andIngredients:(NSOrderedSet *)ingredients
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
