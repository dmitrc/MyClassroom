//
//  EditRoomController.m
//  MyClassroom
//
//  Created by Dmitry on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditRoomController.h"
#import "Toast+UIView.h"

@implementation EditRoomController

@synthesize delegate;

-(void) viewDidLoad
{
    isRemoveOn = NO;
    isResizeOn = NO;
    isRotateOn = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSArray *deskLocations = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]];
    
    for (UIButton* desk in deskLocations)
    {
        desk.highlighted = NO;
        [desk addTarget:self action:@selector(deskDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [desk addTarget:self action:@selector(deskAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:desk];
    }
    
    NSArray *studentLocations = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"studentLocations"]];
    
    for (UIButton* student in studentLocations)
    {
        student.highlighted = NO;
        [student addTarget:self action:@selector(studentDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [student addTarget:self action:@selector(studentAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:student];
    }
    
    [self.view bringSubviewToFront:menu];
                    
}

-(IBAction) addDesk
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int n = arc4random() % 41;
    
    UIButton *newDesk = [[UIButton alloc] initWithFrame:CGRectMake(313, 406+n, 200, 44)]; 
    //using maximum possible width, to be sure that all methods will work perfectly
    
    [newDesk setImage:[UIImage imageNamed:@"desk.png"] forState:UIControlStateNormal];
    [newDesk setImage:[UIImage imageNamed:@"desk.png"] forState:UIControlStateHighlighted];
    [newDesk addTarget:self action:@selector(deskDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [newDesk addTarget:self action:@selector(deskAction:) forControlEvents:UIControlEventTouchDown];
    
    NSMutableArray *deskLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]] mutableCopy];
    [deskLocations addObject:newDesk];
    
    newDesk.tag = [deskLocations count]+100;
    //NSLog(@"%i",[deskLocations count]);
    
    if (newDesk.tag > 136)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You can't add more than 35 desks in the classroom! (and, speaking sincerely, you've got no space left on the screen)..\n Please, try changing size of existing desks or delete some desks and try again."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    [self.view insertSubview:newDesk atIndex:1];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deskLocations];
    
    [prefs setObject:data forKey:@"deskLocations"];
    [prefs synchronize];

}

- (IBAction)deskDrag: (id)sender withEvent: (UIEvent *) event {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    UIButton *selected = (UIButton *)sender;
    selected.center = [[[event allTouches] anyObject] locationInView:self.view];
    
    NSMutableArray *deskLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]] mutableCopy];
    [deskLocations replaceObjectAtIndex:selected.tag-101 withObject:selected];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deskLocations];
    
    [prefs setObject:data forKey:@"deskLocations"];
    [prefs synchronize];
} 

-(IBAction) deskAction:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIButton *desk = (UIButton *)sender;
    
    if (isRotateOn) {
        desk.transform = CGAffineTransformRotate(desk.transform, M_PI/4);
        NSMutableArray *deskLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]] mutableCopy];
        [deskLocations replaceObjectAtIndex:desk.tag-101 withObject:desk];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deskLocations];
        
        [prefs setObject:data forKey:@"deskLocations"];
        [prefs synchronize];
        
        if (rotateButton.tag == 1)
        {
            rotateButton.tag = 2;
            [self rotate:nil];
        }
        
    }
    
    if (isResizeOn) 
    {

        //changing picture
        
        if ([desk.imageView.image isEqual:[UIImage imageNamed:@"deskS.png"]])
        {
            [desk setImage:[UIImage imageNamed:@"desk.png"] forState:UIControlStateNormal];
            [desk setImage:[UIImage imageNamed:@"desk.png"] forState:UIControlStateHighlighted];
        }
        else if ([desk.imageView.image isEqual:[UIImage imageNamed:@"desk.png"]])
        {
            [desk setImage:[UIImage imageNamed:@"deskM.png"] forState:UIControlStateNormal];
            [desk setImage:[UIImage imageNamed:@"deskM.png"] forState:UIControlStateHighlighted];
        }
        else if ([desk.imageView.image isEqual:[UIImage imageNamed:@"deskM.png"]])
        {
            [desk setImage:[UIImage imageNamed:@"deskL.png"] forState:UIControlStateNormal];
            [desk setImage:[UIImage imageNamed:@"deskL.png"] forState:UIControlStateHighlighted];
        }
        else if ([desk.imageView.image isEqual:[UIImage imageNamed:@"deskL.png"]])
        {
            [desk setImage:[UIImage imageNamed:@"deskS.png"] forState:UIControlStateNormal];
            [desk setImage:[UIImage imageNamed:@"deskS.png"] forState:UIControlStateHighlighted];
        }
        
        //changing frame, according to size of the picture
        //maintaining same center to fix 45deg. ones and to make expansion to both sides
        
        CGFloat angle = atan2(desk.transform.b, desk.transform.a);
        CGPoint center = desk.center;
        
        if (angle == 0 || (int)(angle*100) == 314)
            desk.frame = CGRectMake(desk.frame.origin.x, desk.frame.origin.y, desk.imageView.image.size.width, desk.imageView.image.size.height);
        
        else if ((int)(angle*100) == 157 || (int)(angle*100) == -157)
            desk.frame = CGRectMake(desk.frame.origin.x, desk.frame.origin.y, desk.imageView.image.size.height, desk.imageView.image.size.width);
        
        else if ((int)(angle*100) == 78 || (int)(angle*100) == -78 || (int)(angle*100) == 235 || (int)(angle*100) == -235)
        {
            //rotating to default angle, resizing and returning back
            desk.transform = CGAffineTransformRotate(desk.transform, -angle); 
            desk.frame = CGRectMake(desk.frame.origin.x, desk.frame.origin.y, desk.imageView.image.size.width, desk.imageView.image.size.height);
            desk.transform = CGAffineTransformRotate(desk.transform, angle);
        } 
        
        desk.center = center; 
        
        NSMutableArray *deskLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]] mutableCopy];
        [deskLocations replaceObjectAtIndex:desk.tag-101 withObject:desk];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deskLocations];
        
        [prefs setObject:data forKey:@"deskLocations"];
        [prefs synchronize];
        
        if (resizeButton.tag == 1)
        {
            resizeButton.tag = 2;
            [self resize:nil];
        }
    }
    if (isRemoveOn)
    {
        int tag = desk.tag;
        
        [desk removeFromSuperview];
        
        for (UIView *view in [self.view subviews])
            if (view.tag > tag && view.tag < 1000)
                --view.tag;
        
        
        NSMutableArray *deskLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"deskLocations"]] mutableCopy];
        [deskLocations removeObjectAtIndex:tag-101];
        
        for (UIButton *button in deskLocations)
            if (button.tag > tag)
                --button.tag;

        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deskLocations];
        
        [prefs setObject:data forKey:@"deskLocations"];
        [prefs synchronize];
        
        if (removeButton.tag == 1)
        {
            removeButton.tag = 2;
            [self remove:nil];
        }
    }
}

-(IBAction) addStudent
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int n = arc4random() % 21;
    
    UIButton *newStudent = [[UIButton alloc] initWithFrame:CGRectMake(380, 506+n, 66, 66)];
    [newStudent setImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
    [newStudent addTarget:self action:@selector(studentDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [newStudent addTarget:self action:@selector(studentAction:) forControlEvents:UIControlEventTouchDown];
    
    NSMutableArray *studentLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"studentLocations"]] mutableCopy];
    [studentLocations addObject:newStudent];
    
    newStudent.tag = [studentLocations count];
    //NSLog(@"%i",newStudent.tag);
    
    if (newStudent.tag > 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You can't add more than 100 students in the classroom! (and, speaking sincerely, you've got no space left on the screen)..\n Please, delete some students and try again."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self.view addSubview:newStudent];
     [self.view bringSubviewToFront:menu];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:studentLocations];
    [prefs setObject:data forKey:@"studentLocations"];
                    
    [prefs synchronize];
}


- (IBAction)studentDrag: (id)sender withEvent: (UIEvent *) event {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    UIButton *selected = (UIButton *)sender;
    selected.center = [[[event allTouches] anyObject] locationInView:self.view];
    
    NSMutableArray *studentLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"studentLocations"]] mutableCopy];
    [studentLocations replaceObjectAtIndex:selected.tag-1 withObject:selected];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:studentLocations];
    
    [prefs setObject:data forKey:@"studentLocations"];
    [prefs synchronize];
} 

-(IBAction) studentAction:(id)sender
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIButton *student = (UIButton *) sender;
    
    if (isRemoveOn)
    {
        int tag = student.tag;
        [student removeFromSuperview];
        
        for (UIView *view in [self.view subviews])
            if (view.tag > tag && view.tag < 101)
                --view.tag;
        
        
        NSMutableArray *studentLocations = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"studentLocations"]] mutableCopy];
        
        [studentLocations removeObjectAtIndex:tag-1];
        
        for (UIButton *button in studentLocations)
            if (button.tag > tag)
                --button.tag;
        
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:studentLocations];
        [prefs setObject:data1 forKey:@"studentLocations"];
        
        NSArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
        
        for (NSMutableArray *array in myClasses)
        {
            [array removeObjectAtIndex:tag-1];
            [array addObject:[Student defaultStudent]];
        }
        
        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
        [prefs setObject:data2 forKey:@"classes"];
        
        [prefs synchronize];
        
        if (removeButton.tag == 1)
        {
            removeButton.tag = 2;
            [self remove:nil];
        }
    }
}

-(IBAction) clearAll: (id)sender
{
    UIActionSheet *warning = [[UIActionSheet alloc] initWithTitle:@"Are you sure, that you want to clear the classroom? All student data, including names, points and grades will be deleted." delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    warning.tag = 1;
    
    UIButton *button = (UIButton*)sender;
    [warning showFromRect:button.frame inView:self.view animated:YES];
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        if (actionSheet.tag == 1) //clear all
    {
        
        for (UIView *view in self.view.subviews) {
            if (view.tag != 0)
                [view removeFromSuperview];
        }    
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]];
        
        [prefs setObject:data forKey:@"studentLocations"];
        [prefs setObject:data forKey:@"deskLocations"];
        
        NSMutableArray *defaultClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
        
        for (NSMutableArray* array in defaultClasses)
        {
            [array removeAllObjects];
            for (int i=0; i<100; i++)
                [array addObject:[Student defaultStudent]];
        }
        
		NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:defaultClasses];
        [prefs setObject:data1 forKey:@"classes"];
        
        [prefs synchronize];
        
        [self.view makeToast:@"Successfully cleared." duration:1.5 position:@"bottom"];

    }
}

-(IBAction) remove: (id)sender
{

   if (!isRemoveOn)
   {
       isRemoveOn = YES;
       isResizeOn = NO;
       isRotateOn = NO;

       [removeButton setImage:[UIImage imageNamed:@"removeOnce.png"] forState:UIControlStateNormal];
       [rotateButton setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
       [resizeButton setImage:[UIImage imageNamed:@"resize.png"] forState:UIControlStateNormal];
       
       removeButton.tag = 1;
       
   }
    else if (isRemoveOn && removeButton.tag == 1) 
    {
        [removeButton setImage:[UIImage imageNamed:@"removeConstant.png"] forState:UIControlStateNormal];
        removeButton.tag = 2;
    }
    else if (isRemoveOn && removeButton.tag == 2)
    {
        isRemoveOn = NO;
        removeButton.tag = 0;
        [removeButton setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];   
    }
}

-(IBAction) rotate: (id)sender
{
    
    if (!isRotateOn)
    {
        isRotateOn = YES;
        isResizeOn = NO;
        isRemoveOn = NO;
        
        [rotateButton setImage:[UIImage imageNamed:@"rotateOnce.png"] forState:UIControlStateNormal];
        [removeButton setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
        [resizeButton setImage:[UIImage imageNamed:@"resize.png"] forState:UIControlStateNormal];
        
        rotateButton.tag = 1;
        
    }
    else if (isRotateOn && rotateButton.tag == 1) 
    {
        [rotateButton setImage:[UIImage imageNamed:@"rotateConstant.png"] forState:UIControlStateNormal];
        rotateButton.tag = 2;
    }
    else if (isRotateOn && rotateButton.tag == 2)
    {
        isRotateOn = NO;
        rotateButton.tag = 0;
        [rotateButton setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
    }
}

-(IBAction) resize: (id)sender
{
    
    if (!isResizeOn)
    {
        isResizeOn = YES;
        isRemoveOn = NO;
        isRotateOn = NO;
        
        [resizeButton setImage:[UIImage imageNamed:@"resizeOnce.png"] forState:UIControlStateNormal];
        [rotateButton setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
        [removeButton setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
        
        resizeButton.tag = 1;
        
    }
    else if (isResizeOn && resizeButton.tag == 1) 
    {
        [resizeButton setImage:[UIImage imageNamed:@"resizeConstant.png"] forState:UIControlStateNormal];
        resizeButton.tag = 2;
    }
    else if (isResizeOn && resizeButton.tag == 2)
    {
        isResizeOn = NO;
        resizeButton.tag = 0;
        [resizeButton setImage:[UIImage imageNamed:@"resize.png"] forState:UIControlStateNormal];
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

-(IBAction) done
{
    //Dismiss the view (interface will be updated in viewDidAppear: method)
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) credits
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"Thank you for choosing My Classroom for your class!\n\nThis application and all of its graphics were made by Dmitrii Cucleschin, currently getting BSc in Computer Science. Original concept was tried in my Calculus class, taught by Sondra Edwards (Southridge HS).\n\nI would like to thank all the people, who contributed to this application by suggesting features and design tweaks!\n\nFeel free to contact me with any questions, comments, suggestions or concerns:\n\nfd@flexibleblog.ru\nhttp://facebook.com/fdmitry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
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
    
	[self.view makeToast:@"Add student." duration:time position:[NSValue valueWithCGPoint:CGPointMake(175, 145)]];
	
	[self.view makeToast:@"Add desk." duration:time position:[NSValue valueWithCGPoint:CGPointMake(170, 255)]];
	
	[self.view makeToast:@"Rotate" duration:time position:[NSValue valueWithCGPoint:CGPointMake(170, 430)]];
	
	[self.view makeToast:@"Resize." duration:time position:[NSValue valueWithCGPoint:CGPointMake(170, 530)]];
	
	[self.view makeToast:@"Delete." duration:time position:[NSValue valueWithCGPoint:CGPointMake(170, 625)]];
    
    [self.view makeToast:@"After selecting the mode, click the object you want to change.\nYou can have only one mode activated at a time." duration:time position:[NSValue valueWithCGPoint:CGPointMake(500, 430)]];
    
    [self.view makeToast:@"Click once to make a single change (orange status).\nDouble-click will constantly work, until deactivated (red status).\nClicking third time turns editing mode off." duration:time position:[NSValue valueWithCGPoint:CGPointMake(500, 530)]];
	
	[self.view makeToast:@"Erase everything." duration:time position:[NSValue valueWithCGPoint:CGPointMake(195, 840)]];
	
	[self.view makeToast:@"Save changes." duration:time position:[NSValue valueWithCGPoint:CGPointMake(185, 940)]];
	
	[self.view makeToast:@"Note: You can't rotate or resize students." duration:time position:[NSValue valueWithCGPoint:CGPointMake(540, 625)]];
    
}


@end
