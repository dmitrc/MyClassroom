//
//  ClassPicker.h
//  MyClassroom
//
//  Created by Dmitry on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FudgeViewController.h"

@class FudgeViewController;

@interface ClassPicker : UITableViewController <UIAlertViewDelegate>
{
    
    IBOutlet UIBarButtonItem *editButton;
    
    __unsafe_unretained FudgeViewController *_fvController;
    
}

-(IBAction) add:(id)sender;
-(IBAction) edit:(id)sender;

-(int) numberOfPeriods;

@property (weak, nonatomic) UIPopoverController* popoverController;
@property (unsafe_unretained) FudgeViewController *_fvController;

@end
