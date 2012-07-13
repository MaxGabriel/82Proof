//
//  EditRecipeModalViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditRecipeModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageMapping.h"

@interface EditRecipeModalViewController() <UITextFieldDelegate,popoverOptionsViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) int currentTag;
@property (nonatomic, weak) UITextField *activeField;
    
@end

@implementation EditRecipeModalViewController

@synthesize delegate = _delegate;
@synthesize notesLabel = _notesLabel;
@synthesize notes = _notes;
@synthesize scrollView = _scrollView;
@synthesize photoButton = _photoButton;
@synthesize methodButton = _methodButton;
@synthesize glassButton = _glassButton;
@synthesize iceButton = _iceButton;
@synthesize garnishButton = _garnishButton;
@synthesize recipeName = _recipeName;
@synthesize navigationBar = _navigationBar;
@synthesize recipe = _recipe;

@synthesize currentTag = _currentTag;
@synthesize activeField = _activeField;

@synthesize popoverController;

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


// 
// 1. Set up UI for step 2. 
// 1.5: Set up ingredients and names.
// 2. Set up controller based on recipe given (so fill out the recipe name, etc.)
// 3. Add in delete button. 

#define textFieldXPosition 38
#define textFieldWidth 262
#define textFieldHeight 35
#define DELETE_MARGIN 10

#define LAST_ITEM 114

- (void)addNewUITextField:(CGFloat)lastTextField
{
    
}

#define DELETE_ACTION_SHEET_TAG 10

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == DELETE_ACTION_SHEET_TAG) {
        switch (buttonIndex) {
            case 0: // destructive Button
                
                [self.delegate deletedRecipe];
                break;
            case 1: // cancel
                break; // do nothing
        }
    }
}

- (void)deleteButtonPressed:(UIButton *)sender
{
    NSLog(@"Delete Pressed");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Recipe" otherButtonTitles: nil];
    actionSheet.tag = 10;
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",_recipe);
    
    // STEP 1
    
    _navigationBar.tintColor = [UIColor colorWithRed:123/255.0f green:160/255.0f blue:179/255.0f alpha:1]; 
    
    
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320, 480 + ([_recipe.hasIngredients count]*textFieldHeight));
    
# warning set this later based on size of scroll view, right? Also, set view to this background to prevent white on scrollView bounce. But I think (can't see) this solves the red pixel crap. 
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moleskine.png"]];
    [_scrollView addSubview:background];
    
    [_scrollView sendSubviewToBack:background];
    
    _recipeName.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:28];
    _recipeName.delegate = self;
    _recipeName.tag = 99;
    
    _iceButton.layer.masksToBounds = YES;
    _iceButton.layer.cornerRadius = 5.0f;
    _iceButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _glassButton.layer.masksToBounds = YES;
    _glassButton.layer.cornerRadius = 5.0f;
    _glassButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _methodButton.layer.masksToBounds = YES;
    _methodButton.layer.cornerRadius = 5.0f;
    _methodButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
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
    
    
    // STEP 1.5 : set up ingredients
    
    _currentTag = 100;
    CGFloat yPosition = 197;
    
    for (Ingredient *ingredient in _recipe.hasIngredients) {
        
        // SET UP UITextField
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldXPosition, yPosition, textFieldWidth, textFieldHeight)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:20];
        textField.placeholder = @"ingredient";
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.returnKeyType = UIReturnKeyNext;
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;    
        textField.backgroundColor = [UIColor clearColor]; // [UIColor lightTextColor];
        textField.delegate = self;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 15;
        textField.text = ingredient.name;
        
        textField.tag = _currentTag;
        [self.scrollView addSubview:textField];
        
        UIImageView *bullet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
        //Make it same height as the text, and then put it in center. 
        bullet.frame = CGRectMake(textFieldXPosition-10, textField.frame.origin.y, 4, textField.frame.size.height);
        bullet.contentMode = UIViewContentModeCenter;
        bullet.tag = -_currentTag;
        [self.scrollView addSubview:bullet];
        
        // modify values for next one.
        yPosition += textField.frame.size.height;
        _currentTag++;
        
    }
    
    if (_currentTag <= LAST_ITEM) {
        [self addNewUITextField:yPosition];
    }
    
    _notes.frame = CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y + ([_recipe.hasIngredients count]*textFieldHeight), _notes.frame.size.width, _notes.frame.size.height);
    _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, _notesLabel.frame.origin.y + ([_recipe.hasIngredients count]*textFieldHeight), _notesLabel.frame.size.width, _notesLabel.frame.size.height);
    
    // STEP 2
    
    
    
    _recipeName.text = _recipe.name;
    _notes.text = _recipe.notes;
    
    
    if ([_recipe.method isEqualToString:@"None"]) {
        
        _methodButton.name = @"Method";
        [_methodButton addLabel];
        
    } else {
        
        _methodButton.name = _recipe.method;
        [_methodButton addLabel];
        NSString *imageName = [[[ImageMapping sharedInstance] methodDictionary] objectForKey:_recipe.method];
        
        if (!imageName) {
            // Do nothing for now. Later add feature for arbitrary garnish/method etc.
        } else {
            [_methodButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }
    
    if ([_recipe.glass isEqualToString:@"None"]) {
        
        _glassButton.name = @"Glass";
        [_glassButton addLabel];
        
    } else {
        
        _glassButton.name = _recipe.glass;
        [_glassButton addLabel];
        NSString *imageName = [[[ImageMapping sharedInstance] glassDictionary] objectForKey:_recipe.glass];
        
        if (!imageName) {
            // Do nothing for now. Later add feature for arbitrary garnish/method etc.
        } else {
            [_glassButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }

    if ([_recipe.ice isEqualToString:@"None"]) {
        
        _iceButton.name = @"ice";
        [_iceButton addLabel];
        
    } else {
        
        _iceButton.name = _recipe.ice;
        [_iceButton addLabel];
        NSString *imageName = [[[ImageMapping sharedInstance] iceDictionary] objectForKey:_recipe.ice];
        
        if (!imageName) {
            // Do nothing for now. Later add feature for arbitrary garnish/method etc.
        } else {
            [_iceButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }
    
    if ([_recipe.garnish isEqualToString:@"None"]) {
        
        _garnishButton.name = @"garnish";
        [_garnishButton addLabel];
        
    } else {
        
        _garnishButton.name = _recipe.garnish;
        [_garnishButton addLabel];
        NSString *imageName = [[[ImageMapping sharedInstance] garnishDictionary] objectForKey:_recipe.garnish];
        
        if (!imageName) {
            // Do nothing for now. Later add feature for arbitrary garnish/method etc.
        } else {
            [_garnishButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }
    
    if (_recipe.photo) {
        [_photoButton setImage:[UIImage imageNamed:_recipe.photo] forState:UIControlStateNormal];
    }
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y+_notes.frame.size.height+DELETE_MARGIN, _notes.frame.size.width, 44)];
    
    
    
    [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteButton setTitle:@"Delete Recipe" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    deleteButton.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    
    UIImage *deleteImage = [UIImage imageNamed:@"deleteButton.png"];
    
    UIImage *resizedImage = [deleteImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    [deleteButton setBackgroundImage:resizedImage forState:UIControlStateNormal];
    
    [_scrollView addSubview:deleteButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark NavBar Buttons

- (IBAction)cancel:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
}

# pragma mark Popover Buttons

- (void)buttonChosen
{
    [self.popoverController dismissPopoverAnimated:YES];
}

- (IBAction)chooseMethod:(PopoverIngredientButton *)sender {
    
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    
    [self.popoverController dismissPopoverAnimated:YES];
    
    
    popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
    
    contentViewController.scrollEnabled = YES;
    
    
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] init];
    for (NSString *key in [[ImageMapping sharedInstance] methodDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] methodDictionary] objectForKey:key]];
        [mutableButtons addObject:button];
        
    }
    
    contentViewController.buttons = [NSArray arrayWithArray:mutableButtons];
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    
    self.popoverController = nil;
    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _glassButton, _iceButton, _garnishButton, nil];
    
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)chooseGlass:(PopoverIngredientButton *)sender {
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    [self.popoverController dismissPopoverAnimated:YES];
    
    popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
    contentViewController.scrollView.scrollEnabled = YES;
    
    
    
    
    // Using ImageMapping as a data source, get keys (ingredient button names) and their values (image names). 
    
    NSMutableArray *mutableIceButtons = [[NSMutableArray alloc] init];
    for (NSString *key in [[ImageMapping sharedInstance] iceDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] iceDictionary] objectForKey:key]];
        [mutableIceButtons addObject:button];
        
    }
    
    NSArray *iceButtons = [[NSArray alloc] initWithArray:mutableIceButtons];
    
    
    
    
    contentViewController.buttons = iceButtons;
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    
    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _iceButton, _methodButton, _garnishButton, nil];
    
    
    
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)chooseIce:(PopoverIngredientButton *)sender {
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    [self.popoverController dismissPopoverAnimated:YES];
    popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
    
    contentViewController.scrollEnabled = YES;
    
    
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] init];
    for (NSString *key in [[ImageMapping sharedInstance] glassDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] glassDictionary] objectForKey:key]];
        [mutableButtons addObject:button];
        
    }
    
    contentViewController.buttons = [NSArray arrayWithArray:mutableButtons];
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    //    contentViewController.buttons = [contentViewController.buttons sortedArrayUsingComparator:^(ingredientButton *a, ingredientButton *b){
    //        NSString *first =  [NSString stringWithString: a.name];
    //        NSString *second =  [NSString stringWithString: b.name];
    //        return [first compare:second];
    //    }];
    
    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _methodButton ,_glassButton, _garnishButton, nil];
    
    
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)chooseGarnish:(PopoverIngredientButton *)sender {
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    [self.popoverController dismissPopoverAnimated:YES];
    popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
    
    contentViewController.scrollEnabled = YES;
    
    
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] init];
    for (NSString *key in [[ImageMapping sharedInstance] garnishDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] garnishDictionary] objectForKey:key]];
        [mutableButtons addObject:button];
        
    }
    
    contentViewController.buttons = [NSArray arrayWithArray:mutableButtons];
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _iceButton ,_methodButton, _glassButton, nil];
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
@end
