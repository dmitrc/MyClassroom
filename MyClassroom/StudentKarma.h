//
//  StudentKarma.h
//  MyClassroom
//
//  Created by Dmitry on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FudgeViewController.h"
#import "Student.h"

@class FudgeViewController;

@interface StudentKarma : UIViewController
{
    
    IBOutlet UILabel *display;
    IBOutlet UISegmentedControl *grade;
    IBOutlet UITextField *name;
    
    __unsafe_unretained FudgeViewController *_fvController;
    __unsafe_unretained id _sender;
    
    NSArray *myClasses;
    NSArray *myClass;
    Student *myStudent;
    
}

-(IBAction) addFudge;
-(IBAction) substractFudge;
-(IBAction) clear;
-(IBAction) submitName: (id)sender;
-(IBAction) changeGrade: (id) sender;

@property (unsafe_unretained) id _sender;
@property (unsafe_unretained) FudgeViewController *_fvController;

@end
