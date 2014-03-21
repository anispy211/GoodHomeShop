//
//  CartModelManger.h
//  Good Home Shop
//
//  Created by Aniruddha  on 18/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CartModelManger : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CartModelManger *)sharedInstance;

- (void)flushDatabase;
- (NSArray*)getAllCartData;
- (BOOL)deleteEntryFromLocalDb:(NSDictionary *)itemDict;
- (void)addEntrytocartForitem:(NSDictionary *)dictionary withQuanity:(int)quanity;


@end
