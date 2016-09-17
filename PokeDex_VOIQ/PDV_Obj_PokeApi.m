//
//  PDV_Obj_PokeApi.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/17/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_Obj_PokeApi.h"
#import "NSDictionary+StripNSNulls.h"
#import "PDV_Constans.h"

@implementation PDV_Obj_PokeApi


- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)ObjPokeApiModel{
    self = [super init];
    if(self){
        NSDictionary *model = [ObjPokeApiModel $dictionaryByRemovingNSNullValues];
        self.url_objPokeAPI = model[kPokeApiURL];
        self.name_objPokeAPI = model[kPokeApiName];
    }
    return self;
}
@end
