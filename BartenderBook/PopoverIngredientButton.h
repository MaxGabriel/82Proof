//
//  PopoverIngredientButton.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ingredientButton.h"

// The buttons that cause a popover to be displayed. 

@interface PopoverIngredientButton : ingredientButton

@property (nonatomic, strong) UILabel *ingredientLabel;

- (void)addLabel;

@end
