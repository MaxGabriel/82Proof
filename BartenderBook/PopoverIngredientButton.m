//
//  PopoverIngredientButton.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


// I really hate this code lol. 

#import "PopoverIngredientButton.h"

@implementation PopoverIngredientButton

@synthesize ingredientLabel = _ingredientLabel;

- (void)addLabel
{
    if (!_ingredientLabel) { //Create
        
        _ingredientLabel = [[UILabel alloc] init];
        
        int height = self.frame.size.height;
        int width = self.frame.size.width;
        
        _ingredientLabel.frame = CGRectMake(0, height-14, width, 10);
        
        
        
        _ingredientLabel.font = [UIFont fontWithName:@"Futura-Medium" size:(11)];
        _ingredientLabel.backgroundColor = [UIColor clearColor];
        _ingredientLabel.textColor = [UIColor whiteColor];
        _ingredientLabel.textAlignment = UITextAlignmentCenter;
        _ingredientLabel.text = self.name;
        
        
        [self addSubview:_ingredientLabel];
        [self bringSubviewToFront:_ingredientLabel];
    } else { //Just change text
        _ingredientLabel.text = self.name;
    }
}

@end
