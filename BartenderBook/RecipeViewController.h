//
//  RecipeViewController.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "PopoverIngredientButton.h"

@interface RecipeViewController : UIViewController


// MODEL
@property (strong, nonatomic) Recipe *recipe;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *recipeName;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@property (strong, nonatomic) IBOutlet PopoverIngredientButton *mixButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *glassButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *iceButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *garnishButton;

@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notes;


@end
