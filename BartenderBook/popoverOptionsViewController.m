//
//  popoverOptionsViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "popoverOptionsViewController.h"




@interface popoverOptionsViewController() <UIScrollViewDelegate>


@end

@implementation popoverOptionsViewController

@synthesize scrollView = _scrollView;
@synthesize buttons = _buttons;

@synthesize scrollEnabled = _scrollEnabled;
@synthesize presentingButton = _presentingButton;

@synthesize delegate = _delegate;



#pragma mark - View lifecycle

//probably need to set this. 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        int height = ([_buttons count] / 4)*190;
//        
//        NSLog(@"%i",[_buttons count]);
//        
//        self.contentSizeForViewInPopover = CGSizeMake(310, height);
    }
    return self;
}

- (void)buttonPressed:(ingredientButton *)sender
{
    
    [_presentingButton setImage:sender.currentImage forState:UIControlStateNormal];
    _presentingButton.name = sender.name;
    [_presentingButton addLabel];
    
    [self.delegate buttonChosen];
}

#define INITIAL_X 3
#define INITIAL_Y 2
#define WIDTH_SHIFT 77
#define HEIGHT_SHIFT 98

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Configure view/scrollView frames based off of the number of buttons to show. 
    
    double buttons = [_buttons count];
    int height = ceil((buttons/4.0))*98;
    
    
    if (height == 0) { // checks for <4 buttons. 
        height = 98;
    }
    
    if (height > 98*2) {
        self.contentSizeForViewInPopover = CGSizeMake(310,  98*2 + 20);
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 98*2 + 20)];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 310, 98*2 + 20)];
    } else {
        self.contentSizeForViewInPopover = CGSizeMake(310, height);
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, height)];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 310, height)];
    }
    
    
    self.view.clipsToBounds = YES;
    [self.view addSubview:_scrollView];
    
    
    // Configure the scrollView
    
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(310, height);

    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, height)];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisyPurpleStitched.png"]];
    [_scrollView addSubview:background];

    [_scrollView sendSubviewToBack:background];

    
    if (_scrollEnabled == NO) {
        _scrollView.scrollEnabled = NO;
    } else {
        _scrollView.scrollEnabled = YES;
    }
    
         
    if (_scrollView.scrollEnabled == YES) {
        _scrollView.canCancelContentTouches = YES;
    } // Not sure if this actually helps, but the docs say it does. 
    
    
    
    // Add buttons to the scroll View
    
    int buttonsInRow = 0;
    
    int xPosition = INITIAL_X;
    int yPosition = INITIAL_Y;
    
    
    for (ingredientButton *button in _buttons) {
        
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (buttonsInRow == 4) {
            xPosition = INITIAL_X;
            yPosition += HEIGHT_SHIFT;
            buttonsInRow = 0;
        }
        
        button.frame = CGRectMake(xPosition, yPosition, button.currentImage.size.width, button.currentImage.size.height);
        [_scrollView addSubview:button];
        
        
        // Make sure to add label under button here. 
        // After I decide on the font choice and size, I can redo the stitching. 
        // Ugh deciding on font choices... I'm thinking something professional, crisp. Not handwrity. 
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Futura-Medium" size:(11)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = button.name;
        label.textAlignment = UITextAlignmentCenter;
//        label.frame = CGRectMake(xPosition, yPosition+HEIGHT_SHIFT-21, button.currentImage.size.width, 12);
        label.frame = CGRectMake(xPosition, yPosition+75+1, button.currentImage.size.width, 12);
        [_scrollView addSubview:label];
        
        xPosition += WIDTH_SHIFT;
        buttonsInRow++;
    }
    
    
    
    
    // PREVIOUS CODE: This seperates items, but doesn't take the stitching into account.
    
    
    //self.contentSizeForViewInPopover.width
//    int heightMargin = 5;
//    int widthMargin = 5;
//    int widthAvailableForButtons = self.contentSizeForViewInPopover.width - widthMargin*2;
//    
//    int spacing = widthMargin;
//    int ySpacing = heightMargin;
//    
//    
//    int xPosition = widthMargin;
//    int yPosition = heightMargin;
//    int greatestYPosition = 0;
//    
//    for (UIButton *button in _buttons) {
//        
////        NSLog(@"%g",button.currentImage.size.width);
//        
//        if (button.currentImage.size.height > greatestYPosition) {
//            greatestYPosition = button.currentImage.size.height;
//        }
//        
//        //if the next button would take up too much of the screen, go to next row and reset x/y Position.
//        if (xPosition + button.currentImage.size.width > widthAvailableForButtons) {
//            NSLog(@"Going to next row.");
//            yPosition = greatestYPosition + ySpacing;
//            xPosition = widthMargin;
//            greatestYPosition = 0;
//            if (button.currentImage.size.height > greatestYPosition) {
//                greatestYPosition = button.currentImage.size.height;
//            }
//        }
//        
//        
////        NSLog(@"%g",button.currentImage.size.width);
//        
//        button.frame = CGRectMake(xPosition,yPosition, button.currentImage.size.width, button.currentImage.size.height);
//        [_scrollView addSubview:button];
//         
//        xPosition += (spacing + button.currentImage.size.width);
//        
//    }
    
//    int xOffSet = 10;
//    int yOffSet = 10;
//    
//    int xPosition = xOffSet;
//    int yPosition = yOffSet;
//    
//    for (UIButton *button in _buttons) {
//        NSLog(@"%@",button);
//
//        button.frame = CGRectMake(xPosition, yPosition, button.currentImage.size.width, button.currentImage.size.height);
//        [_scrollView addSubview:button];
//        xPosition += button.frame.size.width + 10;
//        
//        if (xPosition+button.frame.size.width > _scrollView.bounds.size.width - xOffSet) {
//            xPosition = xOffSet;
//            yPosition += yOffSet;
//        }
//        
//        //add selector for button to call method, this method will communicate back to delegate what button was pressed. 
//    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
