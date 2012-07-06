//
//  RecipesTableViewController.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "CreateRecipeModalViewController.h"
#import "RecipeViewController.h"

@interface RecipesTableViewController : CoreDataTableViewController <CreateRecipeModalViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIManagedDocument *recipeDatabase;

//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;




@end
