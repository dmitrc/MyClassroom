//
//  Student.h
//  MyClassroom
//
//  Created by Dmitry on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject <NSCoding>
{
    NSString *name;
    int fudge;
}

+(Student *) defaultStudent;
-(void) setToDefault;

@property (strong) NSString *name;
@property int fudge;
@property int grade;

@end
