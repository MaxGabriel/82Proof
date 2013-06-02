//
//  RecipeViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeViewController.h"
#import "Ingredient.h"
#import <QuartzCore/QuartzCore.h>

#import "ImageMapping.h"

#import "EditRecipeModalViewController.h"

@interface RecipeViewController() <UIScrollViewDelegate>


@end

@implementation RecipeViewController



@synthesize recipe = _recipe;
@synthesize scrollView = _scrollView;
@synthesize recipeName = _recipeName;

@synthesize photoButton = _photoButton;
@synthesize mixButton = _mixButton;
@synthesize glassButton = _glassButton;
@synthesize iceButton = _iceButton;
@synthesize garnishButton = _garnishButton;
@synthesize notesLabel = _notesLabel;
@synthesize notes = _notes;
@synthesize managedDocument = _managedDocument;

-(void)deletedRecipe
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [_recipe.managedObjectContext deleteObject:_recipe];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editedRecipe:(Recipe *)recipe
{
    [_managedDocument saveToURL:self.managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success)
    {
        _recipe = recipe;
        [self update];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"After dismiss");
    } ];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

#define LABEL_HEIGHT 44 // was 35
#define BULLET_OFFSET 10

//#define ORIGINAL_NOTES_LABEL_X 236
#define ORIGINAL_NOTES_LABEL_Y 240 
//#define ORIGINAL_NOTES_LABEL_WIDTH 64
//#define ORIGINAL_NOTES_LABEL_HEIGHT 20

//#define ORIGINAL_NOTES_X 20
#define ORIGINAL_NOTES_Y 268
//#define ORIGINAL_NOTES_WIDTH 280
//#define ORIGINAL_NOTES_HEIGHT 128


- (void)update
{
 
    
    if (_recipe.notes == nil || [_recipe.notes isEqualToString:@""]) {
        _scrollView.contentSize = CGSizeMake(320, 480 + ([_recipe.hasIngredients count]*LABEL_HEIGHT) - _notes.frame.size.height - _notesLabel.frame.size.height-30);
    } else {
        _scrollView.contentSize = CGSizeMake(320, 480 + ([_recipe.hasIngredients count]*LABEL_HEIGHT));
    }
    
    int popoverButtonsHidden = 0;
    
    if (!_recipe.method || [_recipe.method isEqualToString:@"None"]) {
        _mixButton.hidden = YES;
        popoverButtonsHidden++;
    } else {
        _mixButton.name = _recipe.method;
        [_mixButton addLabel];
        
        NSString *imageName = [[[ImageMapping sharedInstance] methodDictionary] objectForKey:_recipe.method];
        
        
        if (!imageName) {
            // Do nothing because image is already set to X. 
        } else {
            [_mixButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
        }
        
    }
    
    if (!_recipe.glass || [_recipe.glass isEqualToString:@"None"]) {
        _glassButton.hidden = YES;
        popoverButtonsHidden++;
    } else {
        _glassButton.name = _recipe.glass;
        [_glassButton addLabel];
        
        NSString *imageName = [[[ImageMapping sharedInstance] glassDictionary] objectForKey:_recipe.glass];
        
        
        if (!imageName) {
            // Do nothing because image is already set to X. 
        } else {
            [_glassButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
        }
    }
    
    if (!_recipe.ice || [_recipe.ice isEqualToString:@"None"]) {
        _iceButton.hidden = YES;
        popoverButtonsHidden++;
    } else {
        _iceButton.name = _recipe.ice;
        [_iceButton addLabel];
        
        NSString *imageName = [[[ImageMapping sharedInstance] iceDictionary] objectForKey:_recipe.ice];
        
        
        if (!imageName) {
            // Do nothing because image is already set to X. 
        } else {
            [_iceButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
        }
        
    }
    
    if (!_recipe.garnish || [_recipe.garnish isEqualToString:@"None"]) {
        _garnishButton.hidden = YES;
        popoverButtonsHidden++;
    } else {
        _garnishButton.name = _recipe.garnish;
        [_garnishButton addLabel];
        
        NSString *imageName = [[[ImageMapping sharedInstance] garnishDictionary] objectForKey:_recipe.garnish];
        
        
        if (!imageName) {
            // Do nothing because image is already set to X. 
        } else {
            [_garnishButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
        }
    }
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:_recipe.photo];
    NSLog(@"%@",_recipe.photo);
    if (!image) {
        _photoButton.hidden = YES;
        
        _recipeName.frame = CGRectMake(38-BULLET_OFFSET, _recipeName.frame.origin.y, _recipeName.frame.size.width, _recipeName.frame.size.height);
    } else {
        [_photoButton setImage:image forState:UIControlStateNormal];
    }
    
    
    int yPosition = 197;
    

    if (popoverButtonsHidden == 4) { // (All buttons)
        yPosition = 92;
    }
    
    
    // Delete existing UITextFields
    
    for (UIView *view in [_scrollView subviews]) {
        if (view.tag >=100) { // Only the ingredients. 
            [view removeFromSuperview];
        }
    }
    
    int ingredientTag = 100;
    
    for (Ingredient *ingredient in _recipe.hasIngredients) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, yPosition, 262, LABEL_HEIGHT)];
        label.tag = ingredientTag;

        label.font = [UIFont fontWithName:kGoudyBookletter size:20];
        label.text = ingredient.name;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 15;
        label.backgroundColor = [UIColor clearColor];
        label.userInteractionEnabled = YES;
        
        [label addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(toggleStrikethrough:)]];
        
        
        [_scrollView addSubview:label];
        
        UIImageView *bullet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
        bullet.tag = ingredientTag;
        //Make it same height as the text, and then put it in center. 
        bullet.frame = CGRectMake(label.frame.origin.x-BULLET_OFFSET, label.frame.origin.y, 4, label.frame.size.height);
        bullet.contentMode = UIViewContentModeCenter;
        
        [_scrollView addSubview:bullet];
        
        yPosition += label.frame.size.height;
        ingredientTag++;
        
    }
    
    
    if (_recipe.notes == nil || [_recipe.notes isEqualToString:@""]) {
        _notes.layer.hidden = YES;
        _notesLabel.layer.hidden = YES;
        
    } else {
        _notes.text = _recipe.notes;
        
# warning Test later to see if this is in the same position as the creation screen; seems there's more room on the bottom?
        
        _notes.frame = CGRectMake(_notes.frame.origin.x, ORIGINAL_NOTES_Y + ([_recipe.hasIngredients count]*LABEL_HEIGHT), _notes.frame.size.width, _notes.frame.size.height);
        _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, ORIGINAL_NOTES_LABEL_Y + ([_recipe.hasIngredients count]*LABEL_HEIGHT), _notesLabel.frame.size.width, _notesLabel.frame.size.height);
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Print ingredients of recipe + name and such
//    NSLog(@"%@",_recipe);
//    for (Ingredient *ingredient in _recipe.hasIngredients) {
//        NSLog(@"%@",ingredient.name);
//    }
    
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moleskine.png"]];
//    [self.view addSubview:backgroundView];
//    [self.view sendSubviewToBack:backgroundView];
    
    
    
//    self.view.backgroundColor = [UIColor colorWithRGBHex:0xfff9d0];
    
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    
    

    
    _recipeName.font = [UIFont fontWithName:kGoudyBookletter size:32]; //was 28
    _recipeName.text = _recipe.name;
    

    
    _iceButton.layer.masksToBounds = YES;
    _iceButton.layer.cornerRadius = 5.0f;
    _iceButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _glassButton.layer.masksToBounds = YES;
    _glassButton.layer.cornerRadius = 5.0f;
    _glassButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _mixButton.layer.masksToBounds = YES;
    _mixButton.layer.cornerRadius = 5.0f;
    _mixButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _garnishButton.layer.masksToBounds = YES;
    _garnishButton.layer.cornerRadius = 5.0f;
    _garnishButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _photoButton.layer.masksToBounds = YES;
    _photoButton.layer.cornerRadius = 5.0f;
    _photoButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _notes.layer.masksToBounds = NO;
    _notes.layer.cornerRadius = 5.0f;
    
    _notes.layer.shadowOffset = CGSizeMake(0, 1);
    _notes.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    _notes.layer.shadowRadius = 3.0f;
    _notes.layer.shadowOpacity = 0.8f;
    
    _notes.layer.shouldRasterize = YES;
    _notes.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _notes.scrollsToTop = NO; // Enables status bar shortcut.
    
    _notes.font = [UIFont fontWithName:kGoudyBookletter size:16]; //unsure of previous font size
    

    
    _notesLabel.font = [UIFont fontWithName:kGoudyBookletter size:15]; 
    
    
    [self update];
    

}


- (void)toggleStrikethrough:(UIGestureRecognizer *)recognizer
{
    UILabel * const label = (UILabel *) recognizer.view;
    NSLog(@"Label.frame = %@",NSStringFromCGRect(label.frame));
    
//    label.attributedText = [[NSAttributedString alloc] initWithString:label.text];
//    return;
    const BOOL isUnderlined = [label.attributedText containsAttribute:NSStrikethroughStyleAttributeName withValue:@(NSUnderlineStyleSingle)];

    NSNumber * const underlineStyle = isUnderlined ? @(NSUnderlineStyleNone) : @(NSUnderlineStyleSingle);
    
    label.attributedText =  [[NSAttributedString alloc] initWithString:label.text
                                                            attributes:
                             @{
                                     NSStrikethroughStyleAttributeName: underlineStyle,
                             }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"edit recipe"]) {
        
        EditRecipeModalViewController *controller = (EditRecipeModalViewController *)segue.destinationViewController;
        
        controller.recipe = _recipe;
        controller.delegate = self;
        
    }
}

@end
