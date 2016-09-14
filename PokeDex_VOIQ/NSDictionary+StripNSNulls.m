//
//  NSDictionary+StripNSNulls.m
//
//
//  Created by Carlos Prada on 01/03/13.
//  Copyright (c) 2015 IDS Tecnologia. All rights reserved.
//

#import "NSDictionary+StripNSNulls.h"

@implementation NSDictionary (StripNSNulls)

- (NSDictionary *)$dictionaryByRemovingNSNullValues
{
	NSNull *nullValue = [NSNull null];
	NSSet *nonNullKeys = [self keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
		return obj != nullValue;
	}];

//	NSMutableDictionary *mutableDictionary = [self mutableCopy];
//	[mutableDictionary removeObjectsForKeys:[nonNullKeys allObjects]];

	NSDictionary *stripped = [self dictionaryWithValuesForKeys:[nonNullKeys allObjects]];
	return stripped;
}

@end
