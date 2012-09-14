//
//  Student.m
//  MyClassroom
//
//  Created by Dmitry on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Student.h"

@implementation Student

@synthesize name;
@synthesize fudge;
@synthesize grade;

+(Student *) defaultStudent
{
    Student *student = [[Student alloc] init];
    
    student.name = @"";
    student.fudge = 0;
    student.grade = 0;
    
    return student;
}

-(void) setToDefault
{
    self.name = @"";
    self.fudge = 0;
    self.grade = 0;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.fudge = [decoder decodeIntForKey:@"fudge"];
        self.grade = [decoder decodeIntForKey:@"grade"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeInt:fudge forKey:@"fudge"];
    [encoder encodeInt:grade forKey:@"grade"];
}

@end
