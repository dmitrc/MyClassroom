//
//  ListOfFudge.m
//  MyClassroom
//
//  Created by Dmitry on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListOfFudge.h"

@implementation ListOfFudge

-(void) viewWillAppear:(BOOL)animated
{
    namedPeople= [NSMutableArray array];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSArray *myClasses = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"classes"]];
    NSArray *myClass = [myClasses objectAtIndex:[[prefs objectForKey:@"currentClass"] intValue]];
    
    for (Student *student in myClass)
        if (![student.name isEqualToString:@""])
            [namedPeople addObject:student];
    
    [self sortPeople];
}

-(IBAction) sortPeople
{
    
    switch ([sort selectedSegmentIndex])
    {
        case 0:
            [namedPeople sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                
                Student *s1 = (Student *)obj1;
                Student *s2 = (Student *)obj2;
                
                return [s1.name compare: s2.name];
            }];

            break;
            
        case 1:
            [namedPeople sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                
                Student *s1 = (Student *)obj1;
                Student *s2 = (Student *)obj2;
                
                int grade1 = s1.grade;
                int grade2 = s2.grade;
                
                if (grade1==0) grade1=6;
                if (grade2==0) grade2=6;
                
                return [[NSNumber numberWithInt:grade1] compare: [NSNumber numberWithInt:grade2]];
            }];
            break;
            
        case 2:
            [namedPeople sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                
                Student *s1 = (Student *)obj1;
                Student *s2 = (Student *)obj2;
        
                return [[NSNumber numberWithInt:s2.fudge] compare: [NSNumber numberWithInt:s1.fudge]];
            }];
            break;
    }

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [namedPeople count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellGrade;
    
    switch ([[namedPeople objectAtIndex:indexPath.row] grade])
    {
        case 0:
            cellGrade = @"-";
            break;
            
        case 1:
            cellGrade = @"A";
            break;
            
        case 2:
            cellGrade = @"B";
            break;
            
        case 3:
            cellGrade = @"C";
            break;
            
        case 4:
            cellGrade = @"D";
            break;
            
        case 5:
            cellGrade = @"F";
            break;
    }
            
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[namedPeople objectAtIndex:indexPath.row] name]];   
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %i  ",cellGrade, [[namedPeople objectAtIndex:indexPath.row] fudge]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
