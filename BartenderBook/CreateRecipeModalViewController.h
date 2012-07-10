//
//  CreateRecipeModalViewController.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "ingredientButton.h"
#import "PopoverIngredientButton.h"


#import "ImageMapping.h"

@class CreateRecipeModalViewController;
@protocol CreateRecipeModalViewControllerDelegate <NSObject>

- (void)cancelCreateRecipeModalViewController;

- (void)createRecipeModalViewController:(CreateRecipeModalViewController *)sender
                      makeRecipeWithName:(NSString *)name 
                               andMethod:(NSString *)method 
                                andGlass:(NSString *)glass
                                  andIce:(NSString *)ice
                              andGarnish:(NSString *)garnish
                                andPhoto:(NSString *)photo
                               andNotes:(NSString *)notes
                         andIngredients:(NSOrderedSet *)ingredients;

@end


@interface CreateRecipeModalViewController : UIViewController


@property (nonatomic, retain) WEPopoverController *popoverController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *mixButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *iceButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *glassButton;
@property (strong, nonatomic) IBOutlet PopoverIngredientButton *garnishButton;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@property (strong, nonatomic) IBOutlet UITextView *notes;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;


@property (strong, nonatomic) IBOutlet UITextField *recipeName;
@property (strong, nonatomic) IBOutlet UITextField *firstIngredient;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) id <CreateRecipeModalViewControllerDelegate>delegate;

- (IBAction)chooseShakeStir:(id)sender;
- (IBAction)chooseIce:(id)sender;
- (IBAction)chooseGlass:(id)sender;
- (IBAction)chooseGarnish:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)donePressed:(id)sender;

@end
