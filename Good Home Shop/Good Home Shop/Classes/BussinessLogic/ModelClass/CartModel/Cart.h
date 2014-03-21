//
//  Cart.h
//  Good Home Shop
//
//  Created by Aniruddha on 19/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cart : NSManagedObject

@property (nonatomic, retain) NSString * prodcategory;
@property (nonatomic, retain) NSString * prodid;
@property (nonatomic, retain) NSString * prodimagename;
@property (nonatomic, retain) NSString * prodname;
@property (nonatomic, retain) NSNumber * prodprice;
@property (nonatomic, retain) NSNumber * prodquantity;

@end
