//
//  SettingsController.m
//  MyClassroom
//
//  Created by Dmitrii Cucleschin on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "FudgeViewController.h"

@implementation SettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction) done
{
    FudgeViewController *parentController = (FudgeViewController*)[self presentingViewController];
    [parentController updateInterface];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Security";
    
    else if (section == 1)
        return @"Appearance";
    
    else return @"";
}

-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return @"Be sure to remember the password and save it somewhere safely. There is no possibility to reset the password or access the data in this application in case of losing it.";
    
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    else if (section == 1) return 2;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) { //password
        
        cell.textLabel.text = NSLocalizedString(@"Passcode Lock", "");
        if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
            cell.detailTextLabel.text = NSLocalizedString(@"On", "");
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"Off", "");
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } 
    
    else if (indexPath.section == 1 && indexPath.row == 0) { //show names
        
        cell.textLabel.text = @"Show names";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showNames"] boolValue]) 
            [switchView setOn:YES animated:NO]; 
        else  [switchView setOn:NO animated:NO];
        
        [switchView addTarget:self action:@selector(changeNames:) forControlEvents:UIControlEventValueChanged];
    }
    
    else if (indexPath.section == 1 && indexPath.row == 1) { //show names
        
        cell.textLabel.text = @"Show placeholder for empty classroom";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"emptyMessage"] boolValue]) 
            [switchView setOn:YES animated:NO]; 
        else  [switchView setOn:NO animated:NO];
        
        [switchView addTarget:self action:@selector(emptyMessage:) forControlEvents:UIControlEventValueChanged];
    }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KKPasscodeSettingsViewController *vc = [[KKPasscodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } 
}

-(void) changeNames: (id)sender
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UISwitch *showNames = (UISwitch*)sender;
    
	if ([showNames isOn])
		[prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"showNames"];
	else
		[prefs setObject:[NSNumber numberWithBool:FALSE] forKey:@"showNames"];
	
	[prefs synchronize];
}

-(void) emptyMessage: (id)sender
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UISwitch *eMessage = (UISwitch*)sender;
    
	if ([eMessage isOn])
		[prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"emptyMessage"];
	else
		[prefs setObject:[NSNumber numberWithBool:FALSE] forKey:@"emptyMessage"];
	
	[prefs synchronize];
}

- (void)didSettingsChanged:(KKPasscodeSettingsViewController*)viewController
{
    [self.tableView reloadData];
}

@end
