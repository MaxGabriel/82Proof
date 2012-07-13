//
//  EditRecipeModalViewController.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverIngredientButton.h"
#import "Recipe.h"
#import "Ingredient.h"
#import "WEPopoverController.h"
#import "popoverOptionsViewController.h"

@protocol EditRecipeModalViewControllerDelegate <NSObject>

-(void)deletedRecipe;
-(void)editedRecipe:(Recipe *)recipe;

@end

@interface EditRecipeModalViewController : UIViewController <UIScrollViewDelegate>

// Model
@property (strong, nonatomic) Recipe *recipe;

// Delegate
@property (weak, nonatomic) id <EditRecipeModalViewControllerDelegate> delegate;

// User Interface
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@property (strong, nonatomic) IBOutlet PopoverIngredientButton *methodButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *glassButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *iceButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *garnishButton;
@property (strong, nonatomic) IBOutlet UITextField *recipeName;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;


@property (nonatomic, strong) WEPopoverController *popoverController;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (IBAction)chooseMethod:(id)sender;
- (IBAction)chooseGlass:(id)sender;
- (IBAction)chooseIce:(id)sender;
- (IBAction)chooseGarnish:(id)sender;







@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notes;

@end
