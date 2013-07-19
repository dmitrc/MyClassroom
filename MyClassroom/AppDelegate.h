//
//  AppDelegate.h
//  MyClassroom
//
//  Created by Dmitry on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "FudgeViewController.h"
#import "KKPasscodeLock.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, KKPasscodeViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) IBOutlet FudgeViewController *fvc;

@end

/*
 
 TOP PRIORITY:
 
 TODO:
    1. Error mistakes / Logs
    2. Optimize code (!)
    3. Memory management while moving desks (not as often saving)

 IDEAS FOR FUTURE UPDATES:
    1. Notes for students
    2. Ascending or descending sort
    3. Add student/desk by dragging them from he view.
    4. Second click on help to dismiss it, timer = 10 sec.
    5. ...
 
*/