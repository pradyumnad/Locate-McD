//
//  UINavigationController+Custom.m
//  McD Tracker
//
//  Created by Pradyumna Doddala on 6/6/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "UINavigationBar+Custom.h"

@implementation UINavigationBar (Custom)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"NavBar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}

- (void)setBackgroundImage:(UIImage*)image {
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    [self addSubview:aTabBarBackground];
    [self sendSubviewToBack:aTabBarBackground];
    [aTabBarBackground release];
}

@end
