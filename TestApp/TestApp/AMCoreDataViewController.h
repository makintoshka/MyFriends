//
//  AMCoreDataViewController.h
//  TestApp
//
//  Created by makintosh on 13.01.2021.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSFetchRequest.h>
#import "AMDataManager.h"
#import "User+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMCoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
