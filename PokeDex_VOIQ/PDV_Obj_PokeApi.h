//
//  PDV_Obj_PokeApi.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/17/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDV_Obj_PokeApi : NSObject
@property (strong, nonatomic) NSString *url_objPokeAPI;
@property (nonatomic, strong) NSString *name_objPokeAPI;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)ObjPokeApiModel;
@end
