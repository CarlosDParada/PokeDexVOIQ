//
//  PDV_NextPokemon.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_NextPokemon.h"

@implementation PDV_NextPokemon
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonNextModel{
    self = [super init];
    if(self){
        NSDictionary *model = [pokemonNextModel $dictionaryByRemovingNSNullValues];
        self.name_NextPokemon= model[kPokemonNextName];
        self.num_NextPokemon = model[kPokemonNextNum];
    }
    return self;
}
@end
