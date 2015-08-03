//
//  TPDBManager.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/30/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TPDBManager.h"

@implementation TPDBManager

+ (Tweet*) tweetWithStrId: (NSString*) strId
                inContext: (NSManagedObjectContext*) context
{
    NSPredicate* searchPredicate = [NSPredicate predicateWithFormat: @"id_str == %@", strId];
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Tweet"];
    request.predicate = searchPredicate;
    
    NSError* error;
    
    NSArray* results = [context executeFetchRequest: request error: &error];
    
    if(error)
        NSLog(@"Failed to found tweet with id_str = %@  in context %@", strId, context);
    
    Tweet* tweet = [results lastObject];
    
    return tweet;
}

+ (Tweet*) createTweetFromDictionary: (NSDictionary*) params
                           inContext: (NSManagedObjectContext*) context
{
    NSString* strId = params[@"id_str"];
    Tweet* tweet = [self tweetWithStrId: strId inContext: context];
    if(!tweet)
    {
        tweet = [self newTweetFromContext: context];
    }
    [tweet fillFromDictionary: params];
    
    return tweet;
}

+ (Tweet*) newTweetFromContext: (NSManagedObjectContext*) context
{
    Tweet* newTweet = [self newObjectForEntityName:@"Tweet" context:context];
    return newTweet;
}

@end
