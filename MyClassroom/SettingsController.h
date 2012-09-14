//
//  SettingsController.h
//  MyClassroom
//
//  Created by Dmitrii Cucleschin on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPasscodeLock.h"
#import "KKPasscodeSettingsViewController.h"

@interface SettingsController : UITableViewController <KKPasscodeSettingsViewControllerDelegate>

-(void)didSettingsChanged:(KKPasscodeSettingsViewController*)viewController;
-(IBAction) done;

-(void) changeNames: (id)sender;
-(void) emptyMessage: (id)sender;

@end
