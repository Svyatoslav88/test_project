//
//  OCTwitterHelper.h
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterHelper : NSObject

@property (nonatomic, strong) NSArray* twitterAccounts;

+ (instancetype) shared;

- (void) loginTwitterSuccess:(void (^)(void))successBlock failure:(void (^)(NSError *error))failure;

- (void) getNextTweetsWithSearchString: (NSString*) searchString page: (NSString*) page SuccessBlock: (void (^)(NSArray *tweets, NSString *nextPage)) success failure: (void (^)(NSError *error)) failure;

@end
