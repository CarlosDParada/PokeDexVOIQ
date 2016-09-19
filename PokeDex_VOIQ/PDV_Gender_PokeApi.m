//
//  PDV_Gender_PokeApi.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/18/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_Gender_PokeApi.h"
#import "NSDictionary+StripNSNulls.h"
#import "PDV_Constans.h"

@implementation PDV_Gender_PokeApi

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)Gender_PokeApi_Model{
    self = [super init];
    if(self){
        NSDictionary *model = [Gender_PokeApi_Model $dictionaryByRemovingNSNullValues];
        self.id_objPokeAPI = model[kPokemonID];
        self.gender_objPokeAPI = model[kPokeApiName];
    }
    return self;
}

@end
