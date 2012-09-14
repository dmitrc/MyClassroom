//
//  FudgeViewController.m
//  MyClassroom
//
//  Created by Dmitry on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
Tags:
 0 - UI Elements
 1-100 - Circles (students)
 101-200 - Desks
 500 - Names
 */

#import "FudgeViewController.h"
#import "Student.h"
#import "Toast+UIView.h"

@implementation FudgeViewController

@synthesize classPicker;
@synthesize karmaController;

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void) viewWillAppear:(BOOL)animated
{
	[self updateInterface];
}

-(void) updateInterface
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	//Current class value
	
	int class = [[prefs objectForKey:@"currentClass"] intValue];
	//NSLog(@"Updating interface... Class ID: %i", class);
	
	className.text = [[prefs objectForKey:@"periodNames"] objectAtIndex:class];
	
	// Remove everything
	
	for (UIView *view in self.view.subviews) {
        if (view.tag != 0)
            [view removeFromSuperview];
    }    
	
	// Put desks
	
	NSArray *deskLocations = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]];
    
    for (UIButton* desk in deskLocations)
    {
        desk.highlighted = NO;
        [self.view addSubview:desk];
    }
	
	// Put students
	
    NSArray *studentLocations = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"studentLocations"]];
	
    for (UIButton* student in studentLocations)
    {
        student.highlighted = NO;
		[student addTarget:self action:@selector(pickedStudentWithTag:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:student];
	}
	
	//Put welcome label if no students and desks are available
	
	if ([[prefs objectForKey:@"emptyMessage"] boolValue])
		if ([studentLocations count] == 0 && [deskLocations count] == 0)
		{
			UIImageView *emptyRoom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty.png"]];
			emptyRoom.tag = 400;
			emptyRoom.frame = CGRectMake(139, 128, 600, 800);
			
			[self.view addSubview:emptyRoom];
			
			UIButton *help = [[UIButton alloc] init];
			help.tag = 400;
			help.frame = CGRectMake(383,179,35,35);
			[help addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchDown];
			
			[self.view addSubview:help];
		}

	// Color named students
	// Put name labels (if needed)
	
	NSMutableArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
	NSMutableArray *myClass = [myClasses objectAtIndex:[[prefs objectForKey:@"currentClass"] intValue]];
	
	for (int i=0;i<100;++i)
		if (![[[myClass objectAtIndex:i] name] isEqualToString:@""])
			for (UIView *view in [self.view subviews])
				if (view.tag == i+1)
				{
					UIButton *button = (UIButton*)view;
					[button setImage:[UIImage imageNamed:@"circleGreen.png"] forState:UIControlStateNormal];
					
					if ([[prefs objectForKey:@"showNames"] boolValue]) {
						
						UILabel *name = [[UILabel alloc] init];
						[name setFrame:CGRectMake(button.frame.origin.x - 10, button.frame.origin.y + 64, 84, 20)];
						name.tag = 500;
						name.backgroundColor = [UIColor clearColor];
						name.font = [UIFont systemFontOfSize:14];
						name.textAlignment = UITextAlignmentCenter;
						name.text = [[myClass objectAtIndex:i] name];
						
						[self.view addSubview:name];
					}
					
				}
	
	[self.view bringSubviewToFront:menu];
	
}

-(IBAction)pickedStudentWithTag:(id)sender
{
	StudentKarma *controller = (StudentKarma *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"studentkarma"];
	
	controller._sender = sender;
	controller._fvController = self;
	
	self.karmaController = [[UIPopoverController alloc] initWithContentViewController:controller];
	
	[self.karmaController setPopoverContentSize:CGSizeMake(250, 250)];	
	[self.karmaController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction) randomStudent
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
	NSMutableArray *myClass = [myClasses objectAtIndex:[[prefs objectForKey:@"currentClass"] intValue]];
	NSMutableArray *namedPeople = [NSMutableArray array];
	
	for (UIButton *button in [self.view subviews])
		if (button.tag>0 && button.tag<101)
			if ([button.imageView.image isEqual: [UIImage imageNamed:@"circleGreen.png"]])
				 [namedPeople addObject:button];
	
	if ([namedPeople count] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There are no active students in this classroom. Add students and specify their names in order to make them active."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		return;
	}
	
	int n = arc4random() % [namedPeople count];	
	UIButton *selectedStudent = [namedPeople objectAtIndex:n];
	
	[self pickedStudentWithTag:selectedStudent];
	
	[self.view makeToast:[NSString stringWithFormat:@"%@ has been selected.",[[myClass objectAtIndex:selectedStudent.tag-1] name]]
				duration:2.0
				position:@"bottom"
				   title:@"Random student:"
				   image:[UIImage imageNamed:@"randomStudent.png"]];

}

-(IBAction) giveFudgeToEveryone: (id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you really like to assign one point for everybody in this classroom?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	actionSheet.tag = 1;
	
	[actionSheet showFromRect:[sender frame] inView:self.view animated:YES];
}

-(IBAction) clearFudge: (id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you really like to clear points and grades of all students in this classroom?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	actionSheet.tag = 2;
	
	[actionSheet showFromRect:[sender frame] inView:self.view animated:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
	NSArray *myClass = [myClasses objectAtIndex:[[prefs objectForKey:@"currentClass"] intValue]];
	
	if (buttonIndex == 0) //clicked actual button
	{
		
		if (actionSheet.tag == 1) //give to everyone
		{
			for (Student *student in myClass)
			{
				++student.fudge;
			}
			
			NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
			[prefs setObject:myData forKey:@"classes"];
			
			[self.view makeToast:@"Points were assigned." duration:1.5 position:@"bottom"];
			
		}
		
		else if (actionSheet.tag == 2)  //clear all
		{
			for (Student *student in myClass)
			{
				student.fudge = 0;
				student.grade = 0;
			}
			
			NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
			[prefs setObject:myData forKey:@"classes"];
			
			[self.view makeToast:@"Grades and points were cleared." duration:1.5 position:@"bottom"];
		}
	}
	
	[prefs synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) { //table views (NAV)
		
		UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
		
		if ([[navController visibleViewController] isKindOfClass:[ClassPicker class]]) { //classpicker
			
			ClassPicker* viewController = (ClassPicker*)[navController visibleViewController];
			viewController._fvController = self;
			
			UIStoryboardPopoverSegue* popoverSegue = (UIStoryboardPopoverSegue*)segue;
			[viewController setPopoverController:[popoverSegue popoverController]];
		}
    } //end of NAV
	
	else if ([[segue destinationViewController] isKindOfClass:[EditRoomController class]]) { //editroom
		
		EditRoomController *editRoomController = (EditRoomController*)[segue destinationViewController];
		editRoomController.delegate = self;
	}
	
}

-(IBAction) hideMenu: (UIButton*)sender
{
	if (menu.frame.origin.x == 0)
	{
		[UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4]; 
        
		[menu setFrame:CGRectMake(-92, -20, menu.frame.size.width, menu.frame.size.height)];
		[sender setFrame:CGRectMake(0, 20, sender.frame.size.width, sender.frame.size.height)];
                
        [UIView commitAnimations];
		[sender setImage:[UIImage imageNamed:@"openMenu.png"] forState:UIControlStateNormal];
	}
	
	else if (menu.frame.origin.x == -92)
	{
		[UIView beginAnimations:NULL context:NULL];
		[UIView setAnimationDuration:0.4]; 
		
		[menu setFrame:CGRectMake(0, -20, menu.frame.size.width, menu.frame.size.height)];
		[sender setFrame:CGRectMake(92, 20, sender.frame.size.width, sender.frame.size.height)];
		
		[UIView commitAnimations];
		[sender setImage:[UIImage imageNamed:@"closeMenu.png"] forState:UIControlStateNormal];
	}
}

-(void) returnAlpha
{
	for (UIView *view in self.view.subviews)
		if (view.tag != 0)
			view.alpha = 1;
}

-(IBAction) help
{
	double time = 5.0;
	
	for (UIView *view in self.view.subviews) if (view.tag != 0) view.alpha = 0.2;
	[NSTimer scheduledTimerWithTimeInterval:time+0.4 target:self selector:@selector(returnAlpha) userInfo:nil repeats:NO];
	
	
	[self.view makeToast:@"Show/hide menu." duration:time position:[NSValue valueWithCGPoint:CGPointMake(230, 40)]];
	
	[self.view makeToast:@"Credits." duration:time position:[NSValue valueWithCGPoint:CGPointMake(725, 60)]];
	 
	[self.view makeToast:@"Manage periods and choose the active one." duration:time position:[NSValue valueWithCGPoint:CGPointMake(280, 165)]];
	
	[self.view makeToast:@"View list of all the active students in this class." duration:time position:[NSValue valueWithCGPoint:CGPointMake(290, 265)]];
	
	[self.view makeToast:@"Pick a random student." duration:time position:[NSValue valueWithCGPoint:CGPointMake(220, 365)]];
	
	[self.view makeToast:@"Give one point to everyone in this class." duration:time position:[NSValue valueWithCGPoint:CGPointMake(270, 550)]];
	
	[self.view makeToast:@"Clear all the points and grades." duration:time position:[NSValue valueWithCGPoint:CGPointMake(250, 650)]];
	
	[self.view makeToast:@"Edit the map of the class (put desks and students)." duration:time position:[NSValue valueWithCGPoint:CGPointMake(315, 840)]];
	
	[self.view makeToast:@"Settings." duration:time position:[NSValue valueWithCGPoint:CGPointMake(170, 945)]];
	
	[self.view makeToast:@"Click on student to call the\nmenu, where you can change\nname, points and grades." duration:time position:[NSValue valueWithCGPoint:CGPointMake(620, 450)]];
	
	[self.view makeToast:@"Note: To make student active,\n so you can use him in all the\n features, you need to specify\nhis name in the given period. " duration:time position:[NSValue valueWithCGPoint:CGPointMake(620, 600)]];

}

-(IBAction) credits
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"Thank you for choosing My Classroom for your class!\n\nThis application and all of its graphics were made by Dmitrii Cucleschin, currently getting BSc in Computer Science. Original concept was tried in my Calculus class, taught by Sondra Edwards (Southridge HS).\n\nI would like to thank all the people, who contributed to this application by suggesting features and design tweaks!\n\nFeel free to contact me with any questions, comments, suggestions or concerns:\n\nfd@flexibleblog.ru\nhttp://facebook.com/fdmitry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end
