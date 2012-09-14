//
//  StudentKarma.m
//  MyClassroom
//
//  Created by Dmitry on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StudentKarma.h"

@implementation StudentKarma

@synthesize _sender;
@synthesize _fvController;

-(void) viewDidLoad
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
    myClass = [myClasses objectAtIndex:[[prefs objectForKey:@"currentClass"] intValue]];
    myStudent = [myClass objectAtIndex:[_sender tag]-1];
    
    display.text = [NSString stringWithFormat:@"%i",myStudent.fudge];

    if (![myStudent.name isEqualToString:@""])
        name.text = myStudent.name;
    
    [grade setSelectedSegmentIndex:myStudent.grade];
    
    //NSLog(@"Current student. Name: %@, Points %i, Grade: %i",myStudent.name,myStudent.fudge, myStudent.grade);
    
}


-(IBAction) addFudge
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    ++myStudent.fudge;
    display.text = [NSString stringWithFormat:@"%i",myStudent.fudge];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    [prefs setObject:myData forKey:@"classes"];
    [prefs synchronize];
    
}

-(IBAction) substractFudge
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    --myStudent.fudge;
    display.text = [NSString stringWithFormat:@"%i",myStudent.fudge];
    
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    [prefs setObject:myData forKey:@"classes"];
    [prefs synchronize];
}

-(IBAction) clear
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    myStudent.fudge = 0;
    myStudent.grade = 0;
    
    display.text = [NSString stringWithFormat:@"%i",myStudent.fudge];
    [grade setSelectedSegmentIndex:myStudent.grade];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    [prefs setObject:myData forKey:@"classes"];
    [prefs synchronize];
}

-(IBAction) submitName: (id)sender
{
    [sender resignFirstResponder];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    myStudent.name = [name text];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    [prefs setObject:myData forKey:@"classes"];
    [prefs synchronize];
    
    [_fvController updateInterface];
}

-(IBAction) changeGrade:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    myStudent.grade = [control selectedSegmentIndex];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    [prefs setObject:myData forKey:@"classes"];
    [prefs synchronize];
}

@end
