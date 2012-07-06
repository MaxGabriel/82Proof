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


@interface CreateRecipeModalViewController() <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, popoverOptionsViewControllerDelegate, UIActionSheetDelegate> 

@property (nonatomic) int currentTag;
@property (nonatomic, weak) UITextField *activeField;
@property (nonatomic) BOOL keyboardIsShown;
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

@synthesize navigationBar = _navigationBar;
@synthesize doneButton = _doneButton;
@synthesize activeField = _activeField;
@synthesize keyboardIsShown = _keyboardIsShown;
@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    
    
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

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
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moleskine.png"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
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
//    _notes.layer.borderWidth = 1.5f;
//    _notes.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // Testing shadows.
    
    _notes.layer.shadowOffset = CGSizeMake(0, 1);
    _notes.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    _notes.layer.shadowRadius = 3.0f;
    _notes.layer.shadowOpacity = 0.8f;
    

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

//- (void)viewDidUnload
//{
//    
//    
//    [self setMixButton:nil];
//    [self setIceButton:nil];
//    [self setScrollView:nil];
//    [self setFirstIngredient:nil];
//    [self setGlassButton:nil];
//    [self setGarnishButton:nil];
//    [self setPhotoButton:nil];
//    [self setRecipeName:nil];
//    [self setNavigationBar:nil];
//    [self setNotes:nil];
//    [self setNotesLabel:nil];
//    [self setDoneButton:nil];
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

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
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textField.returnKeyType = UIReturnKeyNext;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;    
    textField.backgroundColor = [UIColor clearColor]; // [UIColor lightTextColor];
    textField.delegate = self;
    textField.adjustsFontSizeToFitWidth = YES;
    _firstIngredient.minimumFontSize = 15;
    
    
    
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

// Scroll to appropriate place -- need to use notifications because this isn't taking keyboard into account. 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    
    NSArray *subviews = [[NSArray alloc] initWithArray:[_scrollView subviews]];
    for (UIView *view in subviews) {
        if (view.tag == -textField.tag) {
            view.alpha = 1;
        }
    }
    
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
            [self addNewUITextField:textField];
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
    
//    if (!self.popoverController) {
        
        popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
        
    contentViewController.scrollEnabled = NO;
    
    ingredientButton *bostonShaker = [[ingredientButton alloc] initWithName:@"Shake" andImageName:@"cobblerShaker.png"];
    
    ingredientButton *blender = [[ingredientButton alloc] initWithName:@"Blend" andImageName:@"blender.png"];
    
    ingredientButton *stir = [[ingredientButton alloc] initWithName:@"Stir" andImageName:@"spoons4.png"];
    
    ingredientButton *dryShake = [[ingredientButton alloc] initWithName:@"Dry Shake" andImageName:@"dryShake.png"];
    
    ingredientButton *layer = [[ingredientButton alloc] initWithName:@"Layer" andImageName:@"Layer.png"];
        
    contentViewController.buttons = [NSArray arrayWithObjects:bostonShaker, stir, blender, dryShake, layer, nil];
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
        //        WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties new];
        //        props.bgImageName = @"first.png";
        //        props.topBgCapSize = 20.0;
        //        props.leftBgCapSize = 20.0;
    self.popoverController = nil;
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _glassButton, _iceButton, _garnishButton, nil];
        //        self.popoverController.containerViewProperties.bgImageName = @"first.png";
        //        self.popoverController.containerViewProperties.topBgCapSize = 14.0;
        //        self.popoverController.containerViewProperties.leftBgCapSize = 14.0;
        
        //        self.popoverController.containerViewProperties = props;
        
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        
//    } else {
//        [self.popoverController dismissPopoverAnimated:YES];
//        self.popoverController = nil;
//    }
    
}

- (IBAction)chooseIce:(PopoverIngredientButton *)sender 
{
    
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    [self.popoverController dismissPopoverAnimated:YES];
//    if (!self.popoverController) {
        
        popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
        
        contentViewController.scrollEnabled = NO;
    
    
    ingredientButton *iceOn = [[ingredientButton alloc] initWithName:@"On the Rocks" andImageName:@"ice140x151.png"];
        
    ingredientButton *iceOff = [[ingredientButton alloc] initWithName:@"No Ice" andImageName:@"no-Ice140x151.png"];
        
        
    ingredientButton *crackedIce = [[ingredientButton alloc] initWithName:@"Cracked" andImageName:@"malletWithCracked2.png"];
    
    ingredientButton *crushedIce = [[ingredientButton alloc] initWithName:@"Shaved" andImageName:@"tallSnowCone.png"];
        
    NSArray *iceButtons = [[NSArray alloc] initWithObjects:iceOn, crackedIce, crushedIce, iceOff, nil];
    
    
    contentViewController.buttons = iceButtons;
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
//                WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties new];
//                props.bgImageName = @"purpleRect.png";
//                props.topBgCapSize = 35.0;
//                props.leftBgCapSize = 35.0;
        
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _glassButton, _mixButton, _garnishButton, nil];
        //        self.popoverController.containerViewProperties.bgImageName = @"first.png";
        //        self.popoverController.containerViewProperties.topBgCapSize = 14.0;
        //        self.popoverController.containerViewProperties.leftBgCapSize = 14.0;
        
//                self.popoverController.containerViewProperties = props;
        
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//        NSLog(@"exists dismiss");
        
//    } else {
//        [self.popoverController dismissPopoverAnimated:YES];
//        self.popoverController = nil;
//        
//    }
}

- (IBAction)chooseGlass:(PopoverIngredientButton *)sender 
{
    [_activeField resignFirstResponder];
    [_notes resignFirstResponder];
    [self.popoverController dismissPopoverAnimated:YES];
    popoverOptionsViewController *contentViewController = [[popoverOptionsViewController alloc] init];
    
    contentViewController.scrollEnabled = NO;
    
    ingredientButton *collinsGlass = [[ingredientButton alloc] initWithName:@"Collins" andImageName:@"collins.png"];
    
    ingredientButton *martiniGlass = [[ingredientButton alloc] initWithName:@"Cocktail" andImageName:@"Martini2.png"];
    
    ingredientButton *rocksGlass = [[ingredientButton alloc] initWithName:@"Rocks" andImageName:@"rocksGlass.png"];
    
    ingredientButton *shotGlass = [[ingredientButton alloc] initWithName:@"Shot" andImageName:@"straightShotGlass.png"];
    
    ingredientButton *margaritaGlass = [[ingredientButton alloc] initWithName:@"Margarita" andImageName:@"margarita.png"];
    
    ingredientButton *snifter = [[ingredientButton alloc] initWithName:@"Snifter" andImageName:@"snifter.png"];
    
    ingredientButton *pousseCafe = [[ingredientButton alloc] initWithName:@"Pousse-Café" andImageName:@"PousseCafe.png"];
    
    ingredientButton *hurricaneGlass = [[ingredientButton alloc] initWithName:@"Hurricane" andImageName:@"hurricaneWhite.png"];
    
    contentViewController.buttons = [NSArray arrayWithObjects:collinsGlass, martiniGlass, shotGlass, rocksGlass, margaritaGlass, snifter, pousseCafe, hurricaneGlass, nil];
    
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    contentViewController.buttons = [contentViewController.buttons sortedArrayUsingComparator:^(ingredientButton *a, ingredientButton *b){
        NSString *first =  [NSString stringWithString: a.name];
        NSString *second =  [NSString stringWithString: b.name];
        return [first compare:second];
    }];
    
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

    contentViewController.scrollEnabled = NO;
    
    ingredientButton *cherry = [[ingredientButton alloc] initWithName:@"Cherry" andImageName:@"cherryBig.png"];
    
    ingredientButton *olive = [[ingredientButton alloc] initWithName:@"Olive" andImageName:@"olive.png"];
    
    ingredientButton *celeryStick = [[ingredientButton alloc] initWithName:@"Celery Stick" andImageName:@"celeryStickBig.png"];
    ingredientButton *limeWheel = [[ingredientButton alloc] initWithName:@"Lime Wheel" andImageName:@"limeWheel2.png"];
    
    contentViewController.buttons = [NSArray arrayWithObjects:cherry, olive, limeWheel, celeryStick, nil];
    contentViewController.presentingButton = sender;
    contentViewController.delegate = self;
    
    self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    self.popoverController.passthroughViews = [NSArray arrayWithObjects: _iceButton ,_mixButton, _glassButton, nil];
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

#warning Not listening for notification about app being dismissed and responding by dismissing action sheet. 

#pragma mark Photo

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Destructive Button
            
            
            NSLog(@"Deleting image");
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
            NSLog(@"%i",buttonIndex);
            break;
        default:
            break;
    }
}

// Need to present action sheet based off of camera availability

- (IBAction)addPhoto:(id)sender
{
//    BOOL cameraOK = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    BOOL photoLibOK = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
    
    // Note to self: need to change to action sheet to prompt for photos or camera.
    // also check difference between 'albums' and photo library option.
    if (_photoButton.imageView.image) {
        NSLog(@"Called");
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        [_actionSheet showInView:self.view];
    } else {
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
    }
    
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
    
//    NSLog(@"saving png");
//	NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
//	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
//	[data1 writeToFile:pngFilePath atomically:YES];
//    
//	NSLog(@"saving jpeg");
//	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
//	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
//	[data2 writeToFile:jpegFilePath atomically:YES];
//    
//	NSLog(@"saving image done");
    if (_recipeName.text && _firstIngredient.text) {
        
        
        // INGREDIENTS 
        NSMutableOrderedSet *ingredients = [[NSMutableOrderedSet alloc] init];
        [ingredients addObject:_firstIngredient.text];
        

        // Tested this, it works fine adding to ingredientsFinal (NSOrderedSet)
        for (UIView *view in [_scrollView subviews]) {
            if (view.tag > 100) {
                UITextField *textField = (UITextField *)view;
                if (textField.text) {
                    if ([textField.text isEqualToString:@""] == NO) {
                        NSLog(@"%@",textField.text);
                        [ingredients addObject:textField.text];
                    }
                }
                
                
            }
        }
        NSOrderedSet *ingredientsFinal = (NSOrderedSet *)ingredients;
        
        // POPOVER INGREDIENTS
    
        // This feels like a hack and bad coding practice:
        
        NSString *method;
        if ([_mixButton.name isEqualToString:DEFAULT_METHOD]) {
            method = nil;
        } else {
            method = _mixButton.name;
        }
        NSString *glass;
        if ([_glassButton.name isEqualToString:DEFAULT_GLASS]) {
            glass = nil;
        } else {
            glass = _glassButton.name;
        }
        
        NSString *ice;
        if ([_iceButton.name isEqualToString:DEFAULT_ICE]) {
            ice = nil;
        } else {
            ice = _iceButton.name;
        }
        
        NSString *garnish;
        if ([_garnishButton.name isEqualToString:DEFAULT_GARNISH]) {
            garnish = nil;
        } else {
            garnish = _garnishButton.name;
        }
        
        
        NSString *path = nil;
        // PHOTO 
        if (_photoButton.imageView.image) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [paths lastObject];
            
            //    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
            //	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
            //	path = [path stringByAppendingPathComponent:(NSString *)newUniqueIdString];
            //	path = [path stringByAppendingPathExtension: @"MOV"];
            //	CFRelease(newUniqueId);
            //	CFRelease(newUniqueIdString);
            
            CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
            CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
            
            path = [path stringByAppendingPathComponent:(__bridge_transfer NSString *)newUniqueIDString];
            path = [path stringByAppendingPathExtension:@"PNG"];
            
            //    NSString *PNGFilePath = [NSString stringWithFormat:@"%@/test.png",documentsPath];
            NSData *PNGImage = [NSData dataWithData:UIImagePNGRepresentation(_photoButton.imageView.image)];
            [PNGImage writeToFile:path atomically:YES];
            
        }
        
        [self.delegate createRecipeModalViewController:self makeRecipeWithName:_recipeName.text andMethod:method andGlass:glass andIce:ice andGarnish:garnish andPhoto:path andIngredients:ingredientsFinal];
        
        
    }
    
    
    
}




@end






