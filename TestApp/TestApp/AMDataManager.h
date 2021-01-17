//
//  AMDataManager.h
//  TestApp
//
//  Created by makintosh on 13.01.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMDataManager : NSObject

@property (readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

+(AMDataManager*) sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

NS_ASSUME_NONNULL_END
