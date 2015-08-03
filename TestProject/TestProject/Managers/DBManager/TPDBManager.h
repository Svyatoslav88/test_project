//
//  TPDBManager.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/30/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "BaseDBManager.h"
#import "Tweet+Extensions.h"

@interface TPDBManager : BaseDBManager

+ (Tweet*) tweetWithStrId: (NSString*) strId
                inContext: (NSManagedObjectContext*) context;

+ (Tweet*) createTweetFromDictionary: (NSDictionary*) params
                           inContext: (NSManagedObjectContext*) context;

+ (Tweet*) newTweetFromContext: (NSManagedObjectContext*) context;

@end
