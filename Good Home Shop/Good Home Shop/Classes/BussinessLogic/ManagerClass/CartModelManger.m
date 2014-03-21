//
//  CartModelManger.m
//  Good Home Shop
//
//  Created by Aniruddha  on 18/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import "CartModelManger.h"
#import "Cart.h"
#import "Utility.h"


static CartModelManger * sharedInstance;

@implementation CartModelManger
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
+ (CartModelManger *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[CartModelManger alloc] init];
    }
    
    
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


#pragma mark - Initialise Setup Coredata Interface

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create Sqlite file in Documents directory
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"TKCoreDataModal.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

// Returns Document directory Path

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Insert Method Database


- (void)addEntrytocartForitem:(NSDictionary *)dictionary withQuanity:(int)quanity
{
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    Cart * newEntry ;
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cart"
                                        inManagedObjectContext:[self managedObjectContext]]];
    [fetchRequest setFetchLimit:1];
    
    // check whether the entity exists or not
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"prodid == %@", [dictionary valueForKey:@"ProductID"]]];
    
    // if get a entity, that means exists, so fetch it.
    
    if ([[self managedObjectContext] countForFetchRequest:fetchRequest error:&error])
        newEntry = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
    // if not exists, just insert a new entity
    else
        newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"Cart"
                                                     inManagedObjectContext:[self managedObjectContext]];
    
    
    newEntry.prodcategory = [dictionary valueForKey:@"ProductCategory"];
    newEntry.prodid = [dictionary valueForKey:@"ProductID"];
    newEntry.prodimagename = [dictionary valueForKey:@"Image"];
    newEntry.prodname = [dictionary valueForKey:@"Name"];
    newEntry.prodprice = [NSNumber numberWithInt:[[dictionary valueForKey:@"Price"] integerValue]];
    quanity = quanity + [[newEntry valueForKey:@"prodquantity"] integerValue];
    
    NSNumber * qty = [NSNumber numberWithInt:quanity];
    newEntry.prodquantity = qty;
    
    NSError * error1 = nil;
    if (![[self managedObjectContext] save:&error1]) {
        NSLog(@"Whoops, couldn't save: %@", [error1 localizedDescription]);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error while saving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }

    
    int val = [[self getAllCartData] count];
    
    
    [[Utility sharedInstance] setCurrentbadgeValue:[NSString stringWithFormat:@"%d",val]];
    [[Utility sharedInstance] updateBadgeValue];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Item Added to Cart Sucessfully" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - Delete Entry Method Database


- (BOOL)deleteEntryFromLocalDb:(NSDictionary *)itemDict
{
    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    Cart * currentObj ;
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cart"
                                        inManagedObjectContext:[self managedObjectContext]]];
    [fetchRequest setFetchLimit:1];
    
    // check whether the entity exists or not
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"prodid == %@", [itemDict valueForKey:@"prodid"]]];
    currentObj = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];

    [[self managedObjectContext] deleteObject:currentObj];

    
    NSError * error1 = nil;
    if (![[self managedObjectContext] save:&error1]) {
        NSLog(@"Whoops, couldn't save: %@", [error1 localizedDescription]);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Opps! Something went wrong" message:@"Cannot delete selected item" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }

    int val = [[self getAllCartData] count];
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Item deleted successfully" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    // Set Cart badge value in utility & update badge value for tab bar
    [[Utility sharedInstance] setCurrentbadgeValue:[NSString stringWithFormat:@"%d",val]];
    [[Utility sharedInstance] updateBadgeValue];
    
    
    return  YES;
    
}

#pragma mark - Get Data  Method  from Database

- (NSArray*)getAllCartData
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

#pragma mark - Delete All Data From Database

- (void)flushDatabase
{
    [_managedObjectContext lock];
    NSArray *stores = [_persistentStoreCoordinator persistentStores];
    for(NSPersistentStore *store in stores) {
        [_persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    [_managedObjectContext unlock];
    _managedObjectModel    = nil;
    _managedObjectContext  = nil;
    _persistentStoreCoordinator = nil;
}


@end
