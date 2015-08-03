//
//  Tweet+Extensions.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "Tweet.h"

@interface Tweet (Extensions)

- (void) fillFromDictionary: (NSDictionary*) params;

- (NSDictionary*) dictionaryFromModel;

@end
