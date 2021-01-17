//
//  UsersTableViewController.m
//  TestApp
//
//  Created by makintosh on 15.01.2021.
//

#import "UsersTableViewController.h"
#import "User+CoreDataClass.h"
#import "UserDetailViewController.h"
#import "AddFriendsViewController.h"

@interface UsersTableViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end

@implementation UsersTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[AMDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"My friends";
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    
    self.navigationItem.leftBarButtonItem = addButton;
}

#pragma mark - Actions

- (void) actionEdit:(UIBarButtonItem*) sender{
    
    bool isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}

- (void) actionAdd:(UIBarButtonItem*) sender{
    
    AddFriendsViewController* vc = [[AddFriendsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSFetchedResultsController*) fetchedResultsController{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFriend == true"];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor* firstNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    NSSortDescriptor* lastNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    [request setEntity:description];
    
    NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                               initWithFetchRequest:request
                                                               managedObjectContext:self.managedObjectContext
                                                               sectionNameKeyPath:nil
                                                               cacheName:@"Users_cache"];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError* error = nil;
    
    NSArray* friends = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    self.friendsArray = (NSMutableArray*) friends;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    if (user.isFriend) {
        cell.detailTextLabel.text = @"is my friend";
    } else{
        cell.detailTextLabel.text = @"isn`t my friend";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.friendsArray];
    
    [tempArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    self.friendsArray = tempArray;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            if ([anObject isKindOfClass:[User class]]) {
                User* user = (User*)anObject;
                user.isFriend = false;
                NSError* error = nil;
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [_managedObjectContext deleteObject:user];
                [_managedObjectContext save:&error];
            }
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* vc = [[UserDetailViewController alloc] init];
    vc.user = user;
    vc.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
