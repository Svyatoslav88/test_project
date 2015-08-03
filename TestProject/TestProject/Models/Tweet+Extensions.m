//
//  Tweet+Extensions.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "Tweet+Extensions.h"

@implementation Tweet (Extensions)

#pragma mark - Lifecycle

- (void) fillFromDictionary: (NSDictionary*) params
{
    self.id_str = params[@"id_str"];
    self.text = params[@"text"];
}

- (NSDictionary*) dictionaryFromModel
{
    return @{@"id_str": (self.id_str? self.id_str: [NSNull null]),
             @"text": (self.text? self.text: [NSNull null])};
}

@end
