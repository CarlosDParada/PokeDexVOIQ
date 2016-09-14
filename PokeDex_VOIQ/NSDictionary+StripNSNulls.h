//
//  NSDictionary+StripNSNulls.h
//
//
//  Created by Carlos Prada on 01/03/13.
//  Copyright (c) 2015 IDS Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (StripNSNulls)

- (NSDictionary *)$dictionaryByRemovingNSNullValues;

@end
