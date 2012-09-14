//
//  ListOfFudge.h
//  MyClassroom
//
//  Created by Dmitry on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface ListOfFudge : UITableViewController
{
    NSMutableArray *namedPeople;
    IBOutlet UISegmentedControl *sort;
}

-(IBAction) sortPeople;

@end
