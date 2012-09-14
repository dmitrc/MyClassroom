//
//  FudgeViewController.h
//  MyClassroom
//
//  Created by Dmitry on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassPicker.h"
#import "EditRoomController.h"
#import "StudentKarma.h"

@interface FudgeViewController : UIViewController <UIActionSheetDelegate,EditRoomDelegate> {

    NSDictionary *currentClass;

    IBOutlet UIView *menu;
    IBOutlet UILabel *className;
    UIPopoverController *karmaController;
}

@property (strong) IBOutlet UIButton *classPicker;
@property (strong) UIPopoverController *karmaController;

-(void) updateInterface;
-(void) returnAlpha;

-(IBAction) clearFudge: (id)sender;
-(IBAction) giveFudgeToEveryone: (id)sender;
-(IBAction) pickedStudentWithTag: (id)sender;
-(IBAction) hideMenu: (id)sender;
-(IBAction) credits;
-(IBAction) randomStudent;
-(IBAction) help;

@end
