//
//  popoverOptionsViewController.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "PopoverIngredientButton.h"

@protocol popoverOptionsViewControllerDelegate <NSObject>

- (void)buttonChosen;

@end

@interface popoverOptionsViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic) BOOL scrollEnabled;

@property (nonatomic, weak) PopoverIngredientButton *presentingButton;

@property (nonatomic, weak) id <popoverOptionsViewControllerDelegate> delegate;

@end
