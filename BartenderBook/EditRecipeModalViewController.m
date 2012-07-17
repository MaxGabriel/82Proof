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
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic) BOOL imageChanged;
    
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
@synthesize doneButton = _doneButton;
@synthesize recipe = _recipe;

@synthesize currentTag = _currentTag;
@synthesize activeField = _activeField;
@synthesize deleteButton = _deleteButton;
@synthesize imageChanged = _imageChanged;

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

#pragma mark Keyboard Methods

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    //CODE FROM STACK OVERFLOW corrects apple's http://stackoverflow.com/a/4837510/1176156
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = _activeField.frame.origin;
    origin.y -= _scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-(aRect.size.height)); 
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
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
    

    
#warning Missing moleskine.png, just have @2x
    // Set background
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moleskine.png"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
//    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moleskine.png"]];
//    [_scrollView addSubview:background];
    
//    [_scrollView sendSubviewToBack:background];
    
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
    int count = 0;
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
        count++;

        if (count == [_recipe.hasIngredients count] && _currentTag <= LAST_ITEM) {
            [self addNewUITextField:textField animated:NO];
        }
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
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y+_notes.frame.size.height+DELETE_MARGIN, _notes.frame.size.width, 44)];
    
    
    
    [_deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteButton setTitle:@"Delete Recipe" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _deleteButton.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    
    UIImage *deleteImage = [UIImage imageNamed:@"deleteButton.png"];
    
    UIImage *resizedImage = [deleteImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    [_deleteButton setBackgroundImage:resizedImage forState:UIControlStateNormal];
    
    [_scrollView addSubview:_deleteButton];
    
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


#pragma mark Text Fields

- (void)addNewUITextField:(UITextField *)lastTextField animated:(BOOL)animated
{
    double xPosition = lastTextField.frame.origin.x;
    double yPosition = lastTextField.frame.origin.y;
    double width = lastTextField.frame.size.width;
    double height = lastTextField.frame.size.height;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, yPosition+height, width, height)];
    textField.borderStyle = UITextBorderStyleNone; //UITextBorderStyleRoundedRect;
    
    textField.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:lastTextField.font.pointSize]; //initially set in viewDidLoad
    
    //textField.font = [UIFont systemFontOfSize:15];
    
    // This sets the text to 404040, a grey. Based on some testing, I'll stay with black. 
    // Specifically, black works better at a low brightness, and I've read a little saying grey is hard to read.
    //    textField.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    
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
    
    
    _currentTag++;
    textField.tag = _currentTag;
    textField.alpha = 0;
    [self.scrollView addSubview:textField];
    
    UIImageView *bullet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
    //Make it same height as the text, and then put it in center. 
    bullet.frame = CGRectMake(xPosition-10, textField.frame.origin.y, 4, textField.frame.size.height);
    bullet.contentMode = UIViewContentModeCenter;
    bullet.alpha = 0;
    bullet.tag = -_currentTag;
    
    [self.scrollView addSubview:bullet];
    
    
    
    //.2 seems like correct alpha for the bullet to match placeholder. 
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{ bullet.alpha = .2; } completion:NULL];
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{ textField.alpha = 1; } completion:NULL];
    
    if (animated) {
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{ _notes.frame = CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y+height, _notes.frame.size.width, _notes.frame.size.height); 
            _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, _notesLabel.frame.origin.y+height, _notesLabel.frame.size.width, _notesLabel.frame.size.height); 
            _deleteButton.frame = CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+height, _deleteButton.frame.size.width, _deleteButton.frame.size.height);} completion:NULL];
    } else {
        _notes.frame = CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y+height, _notes.frame.size.width, _notes.frame.size.height); 
        _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, _notesLabel.frame.origin.y+height, _notesLabel.frame.size.width, _notesLabel.frame.size.height); 
        _deleteButton.frame = CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+height, _deleteButton.frame.size.width, _deleteButton.frame.size.height);
    }
    
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+height);
}


#define LAST_ITEM 114

// Scroll to appropriate place -- need to use notifications because this isn't taking keyboard into account. 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"DID BEGIN1");
    _activeField = textField;
    
    NSArray *subviews = [[NSArray alloc] initWithArray:[_scrollView subviews]];
    for (UIView *view in subviews) {
        if (view.tag == -textField.tag) {
            view.alpha = 1;
        }
    }
    NSLog(@"DID BEGIN2");
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSLog(@"shouldChangeChars..");
    //    if ([textField.text length] > 0) {
    //        NSLog(@"if statement");
    //  
    
    
    //Is 0-indexed. 
    //    NSLog(@"%@",textField.text);
    
    
    
    
    
    
    if (textField.tag > 99 && [string isEqualToString:@" "]) {
        
        textField.keyboardType = UIKeyboardTypeDefault;
        [textField resignFirstResponder];
        [textField becomeFirstResponder];
    }
    
    
    // This isn't ideal because you can select all and delete all the text. I just saw UITextFieldTextDidChangeNotification, maybe that would work? 
    if (textField.tag == 99) {  
        if (([textField.text length] ==1) && [string isEqualToString:@""]) {
            _doneButton.enabled = NO;
        } else {
            _doneButton.enabled = YES;
        }
    }
    
    //    unichar lastChar = [textField.text characterAtIndex:[textField.text length]];
    //    
    //    NSString *lastString = [NSString stringWithFormat:@"%C",lastChar];
    //    if ([lastString isEqualToString:@" "]) {
    //        textField.keyboardType = UIKeyboardTypeDefault;
    //    }
    if (textField.tag == _currentTag && textField.tag != LAST_ITEM && textField.tag != 99) {
        [self addNewUITextField:textField animated:YES];
    }
    //    }
    
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    NSLog(@"TEXT FIELD DID END EDITING");
    _activeField = nil;
    
    NSArray *subviews = [[NSArray alloc] initWithArray:[_scrollView subviews]];
    if ([textField.text isEqualToString:@""]) {
        for (UIView *view in subviews) {
            if (view.tag == -textField.tag) {
                view.alpha = .2;
            }
        }
    }
    
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn got called");
    if ([textField.text length] == 0 || textField.tag == LAST_ITEM) {
        //        NSLog(@"FIRST OPTION");
        [textField resignFirstResponder];
        return YES;
    } else {
        //        NSLog(@"SHOULD RESIGN FIRST RESPONDER");
        [[[self view] viewWithTag:textField.tag+1] becomeFirstResponder];
        return YES;
        
        
        // NOTE: This needs to scroll down so that you can see the next ingredient. 
    }
}

#pragma mark NavBar Buttons

- (IBAction)cancel:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

#define DEFAULT_METHOD @"Method"
#define DEFAULT_GLASS @"Glass"
#define DEFAULT_ICE @"Ice"
#define DEFAULT_GARNISH @"Garnish"

- (IBAction)done:(id)sender 
{
    if (_recipeName.text) {
        
        
        // INGREDIENTS 
        NSMutableOrderedSet *ingredients = [[NSMutableOrderedSet alloc] init];
        
        
        // Tested this, it works fine adding to ingredientsFinal (NSOrderedSet)
        for (UIView *view in [_scrollView subviews]) {
            if (view.tag >= 100) {
                UITextField *textField = (UITextField *)view;
                if (textField.text) {
                    if ([textField.text isEqualToString:@""] == NO) {
                        Ingredient *ingredientToAdd = [Ingredient ingredientWithName:textField.text inManagedObjectContext:_recipe.managedObjectContext];
                        [ingredients addObject:ingredientToAdd];
                    }
                }
                
                
            }
        }
        NSOrderedSet *ingredientsFinal = (NSOrderedSet *)ingredients;
        
        
        NSString *notes = _notes.text;
        
        // POPOVER INGREDIENTS
        
        // This feels like a hack and bad coding practice:

        NSString *method;
        if ([_methodButton.name isEqualToString:DEFAULT_METHOD]) {
            method = @"None";
        } else {
            method = _methodButton.name;
        }
        NSString *glass;
        if ([_glassButton.name isEqualToString:DEFAULT_GLASS]) {
            glass = @"None";
        } else {
            glass = _glassButton.name;
        }
        
        NSString *ice;
        if ([_iceButton.name isEqualToString:DEFAULT_ICE]) {
            ice = @"None";
        } else {
            ice = _iceButton.name;
        }
        
        NSString *garnish;
        if ([_garnishButton.name isEqualToString:DEFAULT_GARNISH]) {
            garnish = @"None";
        } else {
            garnish = _garnishButton.name;
        }
        
#warning I may have to create a new path, not sure. Test this.
        if (_imageChanged) {
            NSData *PNGImage = [NSData dataWithData:UIImagePNGRepresentation(_photoButton.imageView.image)];
            [PNGImage writeToFile:_recipe.photo atomically:YES];
        }
        
        _recipe.name = _recipeName.text;
        _recipe.method = method;
        _recipe.glass = glass;
        _recipe.ice = ice;
        _recipe.garnish = garnish;
        _recipe.notes = notes;
        _recipe.hasIngredients = ingredientsFinal;
        
        
//        [_recipe.managedObjectContext save:NULL];
        

        [_delegate editedRecipe:_recipe];
        
    }
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
    
    NSMutableArray *mutableGlassButtons = [[NSMutableArray alloc] init];
    for (NSString *key in [[ImageMapping sharedInstance] glassDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] glassDictionary] objectForKey:key]];
        [mutableGlassButtons addObject:button];
        
    }
    
    NSArray *glassButtons = [[NSArray alloc] initWithArray:mutableGlassButtons];
    
    
    
    
    contentViewController.buttons = glassButtons;
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
    for (NSString *key in [[ImageMapping sharedInstance] iceDictionary]) {
        
        ingredientButton *button = [[ingredientButton alloc] initWithName:key andImageName:[[[ImageMapping sharedInstance] iceDictionary] objectForKey:key]];
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
