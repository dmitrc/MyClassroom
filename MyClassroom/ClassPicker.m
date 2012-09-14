//
//  ClassPicker.m
//  MyClassroom
//
//  Created by Dmitry on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassPicker.h"

@implementation ClassPicker

@synthesize popoverController;
@synthesize _fvController;

-(int) numberOfPeriods;
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
    
    return [myClasses count];
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfPeriods];
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[prefs objectForKey:@"periodNames"] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"#%i",indexPath.row+1];
    cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"currentClass"];
    [prefs synchronize];
    
    [popoverController dismissPopoverAnimated:YES]; 
    [_fvController updateInterface];

}

-(IBAction) add:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
    NSMutableArray *periodNames = [[prefs objectForKey:@"periodNames"] mutableCopy];
    
        
    [myClasses addObject:[NSMutableArray array]];
        
    for (int k=0; k<100; k++)
        [[myClasses lastObject] addObject:[Student defaultStudent]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
    
    [periodNames addObject:@"New Period"];
    
    [prefs setObject:periodNames forKey:@"periodNames"];
    [prefs setObject:data forKey:@"classes"];
    [prefs synchronize];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self numberOfPeriods]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(IBAction) edit:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
        [self.tableView reloadData];
        
        [editButton setStyle:UIBarButtonItemStyleBordered];
        [editButton setTitle:@"Edit"];     
        
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        
        [editButton setStyle:UIBarButtonItemStyleDone];
        [editButton setTitle:@"Done"];
    }

}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([self numberOfPeriods] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You can not delete this period. Your classroom needs to have at least one active period in order to function." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            [editButton setStyle:UIBarButtonItemStyleBordered];
            [editButton setTitle:@"Edit"]; 
            self.editing = NO;
            
            return;
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSMutableArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
        NSMutableArray *periodNames = [[prefs objectForKey:@"periodNames"] mutableCopy];


        [myClasses removeObjectAtIndex:indexPath.row];
        [periodNames removeObjectAtIndex:indexPath.row];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myClasses];
        
        [prefs setObject:data forKey:@"classes"];
        [prefs setObject:periodNames forKey:@"periodNames"];
        
        if ([[prefs objectForKey:@"currentClass"] intValue]+1 > [self numberOfPeriods])
        {
            [prefs setObject:[NSNumber numberWithInt:0] forKey:@"currentClass"];
        }   
        
        [_fvController updateInterface];
        [prefs synchronize];
        [self.tableView reloadData];
        
    }
}


-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Name for this period:" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    myAlertView.tag = indexPath.row;
    
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    
    [myAlertView show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *textField = (UITextField *)[alertView.subviews objectAtIndex:[alertView.subviews count]-1];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *periodNames = [[prefs objectForKey:@"periodNames"] mutableCopy];
        
        [periodNames replaceObjectAtIndex:alertView.tag withObject:textField.text];
        
        [prefs setObject:periodNames forKey:@"periodNames"];
        [prefs synchronize];
        
        [self.tableView reloadData];
        [_fvController updateInterface];
    }
}

@end
