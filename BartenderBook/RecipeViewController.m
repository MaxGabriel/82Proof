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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

#define LABEL_HEIGHT 35
#define BULLET_OFFSET 10

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Print ingredients of recipe + name and such
//    NSLog(@"%@",_recipe);
//    for (Ingredient *ingredient in _recipe.hasIngredients) {
//        NSLog(@"%@",ingredient.name);
//    }
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moleskine.png"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    
    if (_recipe.notes == nil || [_recipe.notes isEqualToString:@""]) {
        _scrollView.contentSize = CGSizeMake(320, 480 + ([_recipe.hasIngredients count]*LABEL_HEIGHT) - _notes.frame.size.height - _notesLabel.frame.size.height-30);
    } else {
        _scrollView.contentSize = CGSizeMake(320, 480 + ([_recipe.hasIngredients count]*LABEL_HEIGHT));
    }
    

    
    _recipeName.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:28];
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
    

    

    
    _notesLabel.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:15];
    
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
    
    if (!_recipe.photo) {
        _photoButton.hidden = YES;
        
        _recipeName.frame = CGRectMake(38-BULLET_OFFSET, _recipeName.frame.origin.y, _recipeName.frame.size.width, _recipeName.frame.size.height);
        
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:_recipe.photo];
        NSLog(@"%@",image);
        //_photoButton.imageView.image = [UIImage imageWithContentsOfFile:_recipe.photo];
        
        [_photoButton setImage:image forState:UIControlStateNormal];
        
    }
    
    
    int yPosition = 197;
    
    if (popoverButtonsHidden == 4) { // (All buttons)
        // Change yPosition for hidden buttons
    }
    

    
    for (Ingredient *ingredient in _recipe.hasIngredients) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, yPosition, 262, LABEL_HEIGHT)];
        label.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:20];
        label.text = ingredient.name;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 15;
        label.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:label];

        UIImageView *bullet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
        //Make it same height as the text, and then put it in center. 
        bullet.frame = CGRectMake(label.frame.origin.x-BULLET_OFFSET, label.frame.origin.y, 4, label.frame.size.height);
        bullet.contentMode = UIViewContentModeCenter;
        
        [_scrollView addSubview:bullet];
        
        yPosition += label.frame.size.height;
        
    }
   
    
    if (_recipe.notes == nil || [_recipe.notes isEqualToString:@""]) {
        _notes.layer.hidden = YES;
        _notesLabel.layer.hidden = YES;
        
    } else {
        _notes.text = _recipe.notes;
        
# warning Test later to see if this is in the same position as the creation screen; seems there's more room on the bottom?
        
        _notes.frame = CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y + ([_recipe.hasIngredients count]*LABEL_HEIGHT), _notes.frame.size.width, _notes.frame.size.height);
        _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, _notesLabel.frame.origin.y + ([_recipe.hasIngredients count]*LABEL_HEIGHT), _notesLabel.frame.size.width, _notesLabel.frame.size.height);
    }
    
    

    
//    _recipeName.text = _recipe.name;
//    CGFloat yPosition = _recipeName.frame.origin.y;
//    for (Ingredient *ingredient in _recipe.hasIngredients) {
//        yPosition += 25;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_recipeName.frame.origin.x, yPosition, 250, 15)];
//        label.text = ingredient.name;
//        [self.view addSubview:label];
//    }
}


//- (void)viewDidUnload
//{
////    [self setRecipeName:nil];
//    [self setMixButton:nil];
//    [self setGlassButton:nil];
//    [self setIceButton:nil];
//    [self setGarnishButton:nil];
//    [self setPhotoButton:nil];
//    [self setRecipeName:nil];
//    [self setNotesLabel:nil];
//    [self setNotes:nil];
//    [self setScrollView:nil];
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"edit recipe"]) {
        
        EditRecipeModalViewController *controller = (EditRecipeModalViewController *)segue.destinationViewController;
        
        controller.recipe = _recipe;
        
    }
}


@end
