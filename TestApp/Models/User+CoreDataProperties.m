//
//  User+CoreDataProperties.m
//  TestApp
//
//  Created by makintosh on 13.01.2021.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic isFriend;
@dynamic email;
@dynamic phoneNumber;
@dynamic photo;

@end
