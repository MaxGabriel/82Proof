//
//  RecipesTableViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipesTableViewController.h"

#import "Recipe+Create.h"


// Category on NSString. 

@implementation NSString (FetchedGroupByString)


// This code makes characters like ç (like in Curaçao) be grouped with e.g. c, like in the contacts app.
// http://stackoverflow.com/a/2169926/1176156 
 
+ (NSString*) decomposeAndFilterString: (NSString*) string
{
    NSMutableString *decomposedString = [[string decomposedStringWithCanonicalMapping] mutableCopy];
    NSCharacterSet *nonBaseSet = [NSCharacterSet nonBaseCharacterSet];
    NSRange range = NSMakeRange([decomposedString length], 0);
    
    while (range.location > 0) {
        range = [decomposedString rangeOfCharacterFromSet:nonBaseSet
                                                  options:NSBackwardsSearch range:NSMakeRange(0, range.location)];
        if (range.length == 0) {
            break;
        }
        [decomposedString deleteCharactersInRange:range];
    }
    
    return decomposedString;
}

// This code isn't ideal: { will still be a seperate category. Probably not a huge deal, worth learning how to do this right at some point though. 


// Provides an initial for grouping, and groups numbers and some symbols under #. 


// This has some problems for e.g. Arabic characters, just with the index titles not being wrong. I can worry about supporting Arabic later.
- (NSString *)stringGroupByFirstInitial {
    if (!self.length) {
        return self;
    } else {
        NSString *result = [NSString decomposeAndFilterString:self];
        if (result.length ==1) {
            if ([result compare:@"A"] == -1) {
                return @"#";
            } else {
                return result;
            }
        } else {
            if ([result compare:@"A"] == -1) {
                return @"#";
            } else {
                return [result substringToIndex:1];
            }
        }
    }
}
    
@end

@interface RecipesTableViewController() 

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSString *savedSearchTerm;

@property (nonatomic, strong) UIViewController *modalViewController;

@end

@implementation RecipesTableViewController

@synthesize recipeDatabase = _recipeDatabase;
//@synthesize searchBar = _searchBar;

@synthesize searchResults = _searchResults;
@synthesize savedSearchTerm = _savedSearchTerm;

@synthesize modalViewController = _modalViewController;


- (void)handleSearchForTerm:(NSString *)searchTerm
{
    _savedSearchTerm = searchTerm;
    
}

- (void)cancelCreateRecipeModalViewController
{
    
    //[self.modalViewController dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];

}

- (void)createRecipeModalViewController:(CreateRecipeModalViewController *)sender
                      makeRecipeWithName:(NSString *)name 
                               andMethod:(NSString *)method 
                                andGlass:(NSString *)glass
                                  andIce:(NSString *)ice
                              andGarnish:(NSString *)garnish
                                andPhoto:(NSString *)photo
                          andIngredients:(NSOrderedSet *)ingredients
{
    NSLog(@"Saving");
    [self.recipeDatabase.managedObjectContext performBlock:^{
        [Recipe createRecipeWithName:name andMethod:method andGlass:glass andIce:ice andGarnish:garnish andPhotoName:photo andIngredients:ingredients inManagedObjectContext:self.recipeDatabase.managedObjectContext];
        NSLog(@"Created");
        [self.recipeDatabase saveToURL:self.recipeDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        NSLog(@"Saved");
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
//    if (_savedSearchTerm) {
//        self.searchDisplayController.searchBar.text = _savedSearchTerm;
//    }
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:123/255.0f green:160/255.0f blue:179/255.0f alpha:1]; 
}


//- (void) newRecipeModalViewController:(NewRecipeModalViewController *)sender 
//                createdRecipeWithName:(NSString *)name
//                      withIngredients:(NSOrderedSet *)ingredients
//                           withMethod:(NSString *)method
//                              withIce:(NSString *)ice
//                            withGlass:(NSString *)glass 
//                        withBartender:(NSString *)bartender
//{
//    // ADD TO CORE DATA DATABASE HERE AND SAVE
//    
//    NSLog(@"ADD DATA TO CORE DATA HERE");
//    
//    
//    NSLog(@"%@",name);
//    NSLog(@"%@",ingredients);
//    NSLog(@"%@",method);
//    NSLog(@"%@",ice);
//    NSLog(@"%@",bartender);
//    
//    NSString *notes = @"default notes";
//    
//    [self.recipeDatabase.managedObjectContext performBlock:^{
//        [Recipe createRecipeWithName:name andIngredients:ingredients usingMethod:method inGlass:glass withIce:ice byBartender:bartender withNotes: notes inManagedObjectContext: self.recipeDatabase.managedObjectContext];
//        [self.recipeDatabase saveToURL:self.recipeDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
//    }];
//    
//    [self dismissModalViewControllerAnimated:YES];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
}

- (void)setupFetchedResultsController //attached anNSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector (localizedCaseInsensitiveCompare:)]];
    
    // no predicate because we want all the recipes. 
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.recipeDatabase.managedObjectContext
                                                                          sectionNameKeyPath:@"name.stringGroupByFirstInitial"
                                                                                   cacheName:nil];

    
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.recipeDatabase.fileURL path]]) {
        // does not exist in disk, so create it.
        [self.recipeDatabase saveToURL:self.recipeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.recipeDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it.
        
        [self.recipeDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.recipeDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to  use
            [self setupFetchedResultsController];
    }
}

- (void)setRecipeDatabase:(UIManagedDocument *)recipeDatabase
{
    if (_recipeDatabase != recipeDatabase) {
        _recipeDatabase = recipeDatabase;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.recipeDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Recipe Database"];
        self.recipeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recipe";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        // Configure the cell...
    Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = recipe.name;
    
    
    

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"create recipe"]) {
        //NewRecipeModalViewController *controller = (NewRecipeModalViewController *)segue.destinationViewController;
        //controller.delegate = self;
        
        NSLog(@"%@",[segue.destinationViewController class]);

        CreateRecipeModalViewController *controller = (CreateRecipeModalViewController *)segue.destinationViewController;
        controller.delegate = self;
        
        _modalViewController = controller;

        
    } else if ([segue.identifier hasPrefix:@"show recipe"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];

        RecipeViewController *controller = (RecipeViewController *)segue.destinationViewController;
        
        controller.recipe = recipe;
        
        
        
    }
}

//- (void)viewDidUnload {
//    self.savedSearchTerm = self.searchDisplayController.searchBar.text;
//    [self setSearchBar:nil];
//    [super viewDidUnload];
//}
@end
