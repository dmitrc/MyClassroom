//
//  EditRoomController.h
//  MyClassroom
//
//  Created by Dmitry on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@class EditRoomController;

@protocol EditRoomDelegate <NSObject>
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end

@interface EditRoomController : UIViewController <UIActionSheetDelegate>
{
    BOOL isRotateOn;
    BOOL isRemoveOn;
    BOOL isResizeOn;
    
    IBOutlet UIButton *resizeButton;
    IBOutlet UIButton *removeButton;
    IBOutlet UIButton *rotateButton;
    IBOutlet UIView *menu;
}

-(IBAction) addStudent;
-(IBAction) addDesk;
-(IBAction) clearAll:(id)sender;
-(IBAction) done;
-(IBAction) hideMenu: (id)sender;
-(IBAction) credits;
-(IBAction) help;

-(IBAction) rotate: (id)sender;
-(IBAction) resize: (id)sender;
-(IBAction) remove: (id)sender;

-(IBAction) studentAction: (id)sender;
-(IBAction) deskAction: (id)sender;

- (IBAction)studentDrag: (id)sender withEvent: (UIEvent *) event;
- (IBAction)deskDrag: (id)sender withEvent: (UIEvent *) event;

-(void) returnAlpha;

@property (nonatomic, weak) id <EditRoomDelegate> delegate;

@end
