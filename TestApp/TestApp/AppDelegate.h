//
//  AppDelegate.h
//  TestApp
//
//  Created by makintosh on 13.01.2021.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void) saveContext;

@end

