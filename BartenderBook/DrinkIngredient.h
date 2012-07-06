//
//  DrinkIngredient.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrinkIngredient : NSObject

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSNumber *amount;

- (DrinkIngredient *)initWithName:(NSString *)name andAmount:(NSNumber *)amount;

@end
