//
//  Utility.h
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

@property (nonatomic,readwrite) NSString * currentbadgeValue;

+ (Utility *)sharedInstance;
- (NSDictionary *)readproductInfoPlist;
- (void) updateBadgeValue;

@end
