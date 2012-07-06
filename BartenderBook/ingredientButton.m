//
//  ingredientButton.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ingredientButton.h"

@implementation ingredientButton

@synthesize name = _name;

- (ingredientButton *)initWithName:(NSString *)name andImageName:(NSString *)imageName
{
    self = [super init];
    self.name = name;
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return self;
}

@end
