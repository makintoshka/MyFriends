//
//  AMDataManager.m
//  TestApp
//
//  Created by makintosh on 13.01.2021.
//

#import "AMDataManager.h"
#import "User+CoreDataClass.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static NSString* emails[] = {
    
    @"rsrmed_aliu@cjakeuapr.gq", @"mbaraa.alk@qzick.com", @"8ahmed.ayad.hasac@dwfguqpsf.ga",
    @"cdeven@btcmod.com", @"1maando.agendai@caidime.gq", @"ogkayoul@tenipen.tk",
    @"6mostafamotawea8l@cronx.com", @"zsilvan.colp@guideborn.site", @"minderbhullar989@polmaru.ga",
    @"3nermin.sousou.92@hustletussle.com", @"0ahona_sexygirl@slamroll.com", @"nahmed.i@summitgg.com"
    
};

static NSString* numbers[] = {
    
    @"+86 591 684 2925", @"+972 55 496 0982", @"+350 21 1163 9305",
    @"+38 050 145 8815", @"+48 575 842 486", @"+81 75 633 4534",
    @"+234 706 267 9510", @"+7 401 972 1030", @"+34 305 438 353"
    
};

@implementation AMDataManager

+ (AMDataManager*) sharedManager {
    
    static AMDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMDataManager alloc] init];
    });
    
    return manager;
}

- (User*) addRandomUser{
    
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    
    user.firstName = firstNames[arc4random_uniform(50)];
    user.lastName = lastNames[arc4random_uniform(50)];
    user.email = emails[arc4random_uniform(12)];
    user.phoneNumber = numbers[arc4random_uniform(9)];
    user.isFriend = arc4random() % 2;
    
    return user;
}

- (void) printArray:(NSArray*) array{
    
    for (id obj in array){
        
        if ([obj isKindOfClass:[User class]]) {
            
            User* user = (User*) obj;
            
            NSLog(@"%@ %@, email: %@, phone: %@", user.firstName, user.lastName, user.email, user.phoneNumber);
        }
        
    }
}

- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"User"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) printAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    [self printArray:allObjects];
}

- (void) deleteAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}

- (void) generateFriends{
    /*
    [self deleteAllObjects];
    
    NSError* error = nil;
    
    for (int i = 0 ; i < 50; i++) {
        
        User* user = [self addRandomUser];
        
    }
    
    [self.managedObjectContext save:&error];
    */
    [self saveContext];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* firstNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    NSSortDescriptor* lastNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFriend"];
    
    [request setPredicate:predicate];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    
    NSArray* friends = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    [self printArray:friends];
    
    [self printAllObjects];
    
    User* user = [[User alloc] init];
    
    [user setValue:@"Petya" forKey:@"firstName"];
    
    user.firstName = @"Petya";
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectModel = _managedObjectModel;

- (NSManagedObjectModel *)managedObjectModel {
   if (_managedObjectModel != nil){
      return _managedObjectModel;
   }

   NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyModel" withExtension:@"momd"];
   _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];

   return _managedObjectModel;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}


@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext {
   if(_managedObjectContext != nil){
      return _managedObjectContext;
   }

   NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
   if(coordinator != nil){
      _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
      [_managedObjectContext setPersistentStoreCoordinator:coordinator];
   }

   return _managedObjectContext;
}

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TestApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (NSURL *)applicationDocumentsDirectory{
   return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
