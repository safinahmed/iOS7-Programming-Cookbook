//
//  chapter7ViewController.h
//  Portfolio
//
//  Created by Safin Ahmed on 17/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chapter7ViewController : UIViewController

typedef NSString* (^IntToStringConverter)(NSUInteger paramInteger);

typedef struct
{
    char *title;
    char *message;
    char *cancelButtonTitle;
} AlertViewData;

@end
