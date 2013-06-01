//
//  CreateRecipeModalViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateRecipeModalViewController.h"
#import "popoverOptionsViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

// View Controller for creating recipes. 4 distinct secions
// 1. Popover buttons for choosing garnish, ice, etc.
// 2. Photo button, methods for UIImagePicker and ActionSheet
// 3. Ingredient text field methods
// 4. Database delegate method




@interface CreateRecipeModalViewController() <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, popoverOptionsViewControllerDelegate, UIActionSheetDelegate> 

@property (nonatomic) int currentTag;
@property (nonatomic) BOOL ignoreKeyboard;
@property (nonatomic, weak) UITextField *activeField;

@property (nonatomic, strong) UIActionSheet *actionSheet;


@end

@implementation CreateRecipeModalViewController


//NOTE: this is not set as _popoverController
@synthesize popoverController;

@synthesize scrollView = _scrollView;
@synthesize mixButton = _mixButton;
@synthesize iceButton = _iceButton;
@synthesize glassButton = _glassButton;
@synthesize garnishButton = _garnishButton;
@synthesize photoButton = _photoButton;
@synthesize notes = _notes;
@synthesize notesLabel = _notesLabel;
@synthesize recipeName = _recipeName;


@synthesize actionSheet = _actionSheet;
@synthesize currentTag = _currentTag;
@synthesize firstIngredient = _firstIngredient;
@synthesize ignoreKeyboard = _ignoreKeyboard;

@synthesize navigationBar = _navigationBar;
@synthesize doneButton = _doneButton;
@synthesize activeField = _activeField;

@synthesize delegate = _delegate;



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    
    
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{

    if (_ignoreKeyboard == YES) {
        // do nothing
    } else {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        CGPoint point = CGPointMake(_activeField.frame.origin.x, _activeField.frame.origin.y+_activeField.frame.size.height);
        
        
        if (!CGRectContainsPoint(aRect, point) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y+_activeField.frame.size.height-kbSize.height);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    _ignoreKeyboard = NO;
    
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    _scrollView.contentInset = contentInsets;
//    _scrollView.scrollIndicatorInsets = contentInsets;
//    
//    Old code from StackOverflow, I actually found Apple's worked best after I modified it to take into account height.  http://stackoverflow.com/a/4837510/1176156
//    
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    
//    CGPoint origin;
//    if (_activeField) {
//        origin = _activeField.frame.origin;
//        
//    } else {
//        origin = _notes.frame.origin;
//    }
//    
//    origin.y -= _scrollView.contentOffset.y;
//    
//    
//    if (!CGRectContainsPoint(aRect, origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-(aRect.size.height)); 
//        [_scrollView setContentOffset:scrollPoint animated:YES];
//    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  
    if (_ignoreKeyboard == YES) {
        // do nothing
    } else {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
    }
    
}


- (void)enteredBackground:(NSNotification *)notification
{
    if (_actionSheet.tag == 1) {
        [_actionSheet dismissWithClickedButtonIndex:3 animated:YES];
    } else if (_actionSheet.tag == 2) {
        [_actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    }
    
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#define DEFAULT_METHOD @"Method"
#define DEFAULT_GLASS @"Glass"
#define DEFAULT_ICE @"Ice"
#define DEFAULT_GARNISH @"Garnish"

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Set background
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moleskine.png"]];
//    [self.view addSubview:backgroundView];
//    [self.view sendSubviewToBack:backgroundView];
    
    // ScrollView settings
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320, 480);
    
    //recipeName
    _recipeName.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:28];
    _recipeName.delegate = self;
    _recipeName.tag = 99;
    
    //textField (firstIngredient)
    _currentTag = 100;
    _firstIngredient.delegate = self;
    _firstIngredient.tag = _currentTag;
    _firstIngredient.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:20];
    _firstIngredient.adjustsFontSizeToFitWidth = YES;
    _firstIngredient.minimumFontSize = 15;
    
    // HEX 535A80
    //_navigationBar.tintColor = [UIColor colorWithRed:83/255.0f green:90/255.0f blue:128/255.0f alpha:1]; 
    
    // HEX 240826
    _navigationBar.tintColor = [UIColor colorWithRed:123/255.0f green:160/255.0f blue:179/255.0f alpha:1]; 
    
    //first bullet 
    UIImageView *bullet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
    //Make it same height as the text, and then put it in center. 
    bullet.frame = CGRectMake(_firstIngredient.frame.origin.x-10, _firstIngredient.frame.origin.y, 4, _firstIngredient.frame.size.height);
    bullet.contentMode = UIViewContentModeCenter;
    bullet.alpha = .2;
    bullet.tag = -_currentTag;
    
    [self.scrollView addSubview:bullet];
    

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
    
    _notes.scrollsToTop = NO; // Enables status bar shortcut.
    
    _notes.layer.shouldRasterize = YES;
    _notes.layer.rasterizationScale = [UIScreen mainScreen].scale;


    _notesLabel.font = [UIFont fontWithName:@"dearJoe 5 CASUAL" size:15];
    
    _glassButton.name = DEFAULT_GLASS;
    [_glassButton addLabel];
    
    _iceButton.name = DEFAULT_ICE;
    [_iceButton addLabel];
    
    _garnishButton.name = DEFAULT_GARNISH;
    [_garnishButton addLabel];
    
    _mixButton.name = DEFAULT_METHOD;
    [_mixButton addLabel];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enteredBackground:) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification 
                                                  object:nil];
}


#pragma mark Text Fields


- (void)addNewUITextField:(UITextField *)lastTextField
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
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{ _notes.frame = CGRectMake(_notes.frame.origin.x, _notes.frame.origin.y+height, _notes.frame.size.width, _notes.frame.size.height); _notesLabel.frame = CGRectMake(_notesLabel.frame.origin.x, _notesLabel.frame.origin.y+height, _notesLabel.frame.size.width, _notesLabel.frame.size.height); } completion:NULL];

    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+height);
}



#define LAST_ITEM 114

// _activeField used for dismissing keyboard and scrolling in keyboard methods. 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    //Make bullet black. 
    NSArray *subviews = [[NSArray alloc] initWithArray:[_scrollView subviews]];
    for (UIView *view in subviews) {
        if (view.tag == -textField.tag) {
            view.alpha = 1;
        }
    }
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    
    
    if (textField.tag > 99 && [string isEqualToString:@" "]) {
        _ignoreKeyboard = YES;

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
    

    if (textField.tag == _currentTag && textField.tag != LAST_ITEM && textField.tag != 99) {
            [self addNewUITextField:textField];
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

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
    _ignoreKeyboard = NO;
    
    if ([textField.text length] == 0 || textField.tag == LAST_ITEM) {

        [textField resignFirstResponder];
        return YES;
    } else {

        [[[self view] viewWithTag:textField.tag+1] becomeFirstResponder];
        return YES;
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Popover Buttons


// Dismiss popover upon choosing a button (e.g. snifter, collins)
- (void)buttonChosen
{
    [self.popoverController dismissPopoverAnimated:YES];
}



- (IBAction)chooseShakeStir:(PopoverIngredientButton *)sender
{
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

- (IBAction)chooseIce:(PopoverIngredientButton *)sender 
{
    
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
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _glassButton, _mixButton, _garnishButton, nil];
        
        
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

- (IBAction)chooseGlass:(PopoverIngredientButton *)sender 
{
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
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _iceButton ,_mixButton, _garnishButton, nil];

    
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
}

- (IBAction)chooseGarnish:(PopoverIngredientButton *)sender 
{
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
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _iceButton ,_mixButton, _glassButton, nil];
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}





#pragma mark Photo

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0: // Destructive Button
                
                [_photoButton setImage:nil forState:UIControlStateNormal];
                _photoButton.imageView.image = nil;
                break;
            case 1: // Take Photo
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                    if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                        picker.allowsEditing = YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                break;
            case 2: // Choose Photo // photolibrary versus savedphotoalbums?
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                        picker.allowsEditing = YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                break;
            case 3: // Cancel

                break;
            default:
                break;
        }
    } else if (actionSheet.tag ==2) {
        switch (buttonIndex) {
            case 0: // Take Photo
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                    if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                        picker.allowsEditing = YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                break;
            case 1: // Choose Photo
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                        picker.allowsEditing = YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                break;
            case 2: // Cancel
                break;
            default:
                break;
        } 


        }
        
}



- (IBAction)addPhoto:(id)sender
{
    
    
    if (_photoButton.imageView.image) {
        
            _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
            _actionSheet.tag = 1;
        
    } else {
        
            _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
            _actionSheet.tag = 2;
        
    }
    
    [_actionSheet showInView:self.view];
    
}

- (void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        _photoButton.layer.masksToBounds =YES;
        _photoButton.layer.cornerRadius = 5.0f;
        _photoButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
        [self.photoButton setImage:image forState:UIControlStateNormal];
    }
    [self dismissImagePicker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}

# pragma mark database
//Data base.


- (IBAction)donePressed:(id)sender 
{
    
    // BEGIN black magicks I am unfamiliar with. Need to read about bridging, uniqueIDs. 
    
    if (_recipeName.text) {
        
        
        // INGREDIENTS 
        NSMutableOrderedSet *ingredients = [[NSMutableOrderedSet alloc] init];
        [ingredients addObject:_firstIngredient.text];
        

        for (UIView *view in [_scrollView subviews]) {
            if (view.tag > 100) {
                UITextField *textField = (UITextField *)view;
                if (textField.text) {
                    if ([textField.text isEqualToString:@""] == NO) {

                        [ingredients addObject:textField.text];
                    }
                }
                
                
            }
        }
        NSOrderedSet *ingredientsFinal = (NSOrderedSet *)ingredients;
        
        // NOTES
        NSString *notes = _notes.text;
        
        // POPOVER INGREDIENTS
    
        // This feels like a hack and bad coding practice:
        
        NSString *method;
        if ([_mixButton.name isEqualToString:DEFAULT_METHOD]) {
            method = @"None";
        } else {
            method = _mixButton.name;
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
        
        // PHOTO
        // Always make a path and keep that path for the given recipe. If there isn't an image, when we call imageFromFile later it will return nil. 
        NSString *path = nil;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];

            
        CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        
        // 
        path = [path stringByAppendingPathComponent:(__bridge_transfer NSString *)newUniqueIDString];
        path = [path stringByAppendingPathExtension:@"PNG"];
            
            
        NSData *PNGImage = [NSData dataWithData:UIImagePNGRepresentation(_photoButton.imageView.image)];
        [PNGImage writeToFile:path atomically:YES];
            

        
        [self.delegate createRecipeModalViewController:self makeRecipeWithName:_recipeName.text andMethod:method andGlass:glass andIce:ice andGarnish:garnish andPhoto:path andNotes:notes andIngredients:ingredientsFinal];
        
    }
}




@end






