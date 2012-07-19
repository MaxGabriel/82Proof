//
//  ingredientButton.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// Each of the buttons you can choose in a popover is an ingredient button. 

@interface ingredientButton : UIButton
@property (nonatomic, strong) NSString *name;

- (ingredientButton *)initWithName:(NSString *)name andImageName:(NSString *)imageName;

@end
