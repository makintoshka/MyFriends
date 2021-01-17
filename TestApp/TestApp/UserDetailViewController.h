//
//  UserDetailViewController.h
//  TestApp
//
//  Created by makintosh on 15.01.2021.
//

#import "AMCoreDataViewController.h"
#import "User+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailViewController : AMCoreDataViewController

@property (strong, nonatomic) User* user;

@end

NS_ASSUME_NONNULL_END
