//
//  ingredientButton.h
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ingredientButton : UIButton
@property (nonatomic, strong) NSString *name;

- (ingredientButton *)initWithName:(NSString *)name andImageName:(NSString *)imageName;

@end
