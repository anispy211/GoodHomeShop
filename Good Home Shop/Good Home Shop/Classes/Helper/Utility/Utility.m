//
//  Utility.m
//  Good Home Shop
//
//  Created by Aniruddha  on 16/03/14.
//  Copyright (c) 2014 Aniruddha. All rights reserved.
//

#import "Utility.h"
static Utility * sharedInstance;
@implementation Utility
@synthesize currentbadgeValue;

+ (Utility *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[Utility alloc] init];
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

- (void) updateBadgeValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateBadge object:nil];
    
}


- (NSDictionary *)readproductInfoPlist
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Product_Info" ofType:@"plist"];
   NSDictionary * _rootDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    return _rootDict;
}


@end
