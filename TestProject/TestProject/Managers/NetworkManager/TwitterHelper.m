//
//  OCTwitterHelper.m
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import "TwitterHelper.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "TPDBManager.h"

#define TWT_SEARCH_TWEETS_URL         @"https://api.twitter.com/1.1/search/tweets.json"

static TwitterHelper* twitterHelperInstance = nil;
static NSInteger SNAccessDisabledCode = -1001;
static NSInteger SNNotLinkedErrorCode = -1002;
static NSInteger SNLinkedToAnotherUserErrorCode = -1003;
static NSInteger SNNoLinkedAccountInSettingsErrorCode = -1004;
static NSInteger SNCannotAutolinkErrorCode = -1005;
static NSInteger SNNoAccountErrorCode = 6;

@interface TwitterHelper ()

@property (nonatomic, strong) ACAccount* currentAccount;

@property (nonatomic, strong) NSManagedObjectContext* context;

@end

@implementation TwitterHelper

#pragma mark - General

+ (instancetype) shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        twitterHelperInstance = [TwitterHelper new];
    });
    return twitterHelperInstance;
}

- (id) init
{
    if (self = [super init])
    {
        self.context = [TPDBManager getNewDBContext];
    }
    return self;
}

#pragma mark - Login 

- (void) loginTwitterSuccess:(void (^)(void))successBlock failure:(void (^)(NSError *))failure
{
    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error)
    {
        
        if(error != nil)
        {
            if(failure != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
        
        if(twitterAccounts.count > 0)
        {
            ACAccount *twitterAccount = [twitterAccounts lastObject];
            self.currentAccount = twitterAccount;
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock();
            });
        }
    }];
}

#pragma mark - Public

- (void) getNextTweetsWithSearchString: (NSString*) searchString page: (NSString*) page SuccessBlock: (void (^)(NSArray *tweets, NSString *nextPage)) success failure: (void (^)(NSError *error)) failure
{
    if([searchString isEqualToString: @""] && !searchString)
        failure([NSError errorWithDomain: @"Error" code: 0 userInfo: @{NSLocalizedDescriptionKey:@"No search string"}]);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(page)
    {
        NSString* pageString = [page substringFromIndex: 1];
        NSArray* paramsArray = [pageString componentsSeparatedByString: @"&"];
        for (NSString* paramString in paramsArray) {
            NSArray* arr = [paramString componentsSeparatedByString: @"="];
            [params setObject: arr[1] forKey: arr[0]];
        }
    }
    else
    {
        [params setObject: searchString forKey: @"q"];
    }
    
    NSURL *url = [NSURL URLWithString: TWT_SEARCH_TWEETS_URL];
    
    SLRequest *searchRequest = [self requestWithUrl: url parameters: params requestMethod:SLRequestMethodGET];
    [searchRequest setAccount: self.currentAccount];
    [searchRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* error;
            NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:kNilOptions
                                                                   error:&error];
            NSString* nextSearch = nil;
            NSDictionary* metadata = response[@"search_metadata"];
            if(metadata)
                nextSearch = metadata[@"next_results"];

            if(error)
            {
                failure(error);
            }
            else
            {
                NSArray* tweetsArray = response[@"statuses"];
                NSMutableArray* tweets = [NSMutableArray array];
                for (NSDictionary* tweetDict in tweetsArray) {
                    Tweet* tweet = [TPDBManager createTweetFromDictionary: tweetDict
                                                                inContext: self.context];
                    if(tweet)
                        [tweets addObject: tweet];
                }
                success(tweets, nextSearch);

            }
            
        });
    }];
}

#pragma mark - Private

- (void) getTwitterAccountsWithCompletionBlock: (void(^)(NSArray* twitterAccounts, NSError* error)) completionBlock
{
    static ACAccountStore *accountStore;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        accountStore = [[ACAccountStore alloc] init];
    });
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType: accountType options: nil completion: ^(BOOL granted, NSError *error)
     {
         if(error == nil)
         {
             // Did user allow us access?
             if(granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
                 
                 self.twitterAccounts = arrayOfAccounts;
                 
                 if (self.twitterAccounts == nil || self.twitterAccounts.count == 0)
                 {
                     error = [NSError errorWithDomain:@"Twitter" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Twitter in the device Settings"}];
                 }
                 
                 if(completionBlock != nil)
                 {
                     completionBlock(arrayOfAccounts, error);
                 }
             }
             else
             {
                 NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"Twitter access disabled"}];
                 if(completionBlock != nil)
                 {
                     completionBlock(nil, localError);
                 }
             }
         }
         else
         {
             if (error.code == SNNoAccountErrorCode)
             {
                 error = [NSError errorWithDomain:error.domain code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Twitter in the device Settings"}];
             }
             if(completionBlock != nil)
             {
                 completionBlock(nil, error);
             }
         }
     }];
}

- (SLRequest *)requestWithUrl:(NSURL *)url parameters:(NSDictionary *)dict requestMethod:(SLRequestMethod)requestMethod
{
    return [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:requestMethod URL:url parameters:dict];
}

@end
