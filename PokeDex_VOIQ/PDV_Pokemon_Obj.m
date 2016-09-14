//
//  PDV_Pokemon_Obj.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_Pokemon_Obj.h"

#import "NSDictionary+StripNSNulls.h"

@implementation PDV_Pokemon_Obj
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonModel{
    self = [super init];
    if(self){
        NSDictionary *model = [pokemonModel $dictionaryByRemovingNSNullValues];
        self.id_pokemon = model[kPokemonID];
        self.num_pokemon = model[kPokemonNum];
        self.name_pokemon = model[kPokemonName];
        self.img_url = model[kPokemonImg];
        self.Array_type = model[kPokemonType];//Array
//        if (pokemonModel[kPokemonType]) {
//            for (NSDictionary *modelType in pokemonModel[kPokemonType]) {
//                NSString *type1 =[ modelType valueForKey:@"type1"];
//                [self.Array_type addObject:type1];
//            }
//        }
        
        self.height = model[kPokemonHeight];
        self.weight = model[kPokemonWeight];
        self.candy = model[kPokemonCandy];
        self.candy_count = model[kPokemonCandy_Count];
        self.egg = model[kPokemonEgg];
        self.multipliers = model[kPokemonMultipliers];
        self.weaknesses = model[kPokemonWeknesses];//Array
        
//        self.prev_evolution = model[kPokemonPrev_Evolution];//Array
        if (model[kPokemonPrev_Evolution]) {
            for (NSDictionary *modelPrevPokemon in model[kPokemonPrev_Evolution]) {
                PDV_NextPokemon *pokemonPrev = [[PDV_NextPokemon alloc] initWithDictionaryRepresentation:modelPrevPokemon];
                [self.prev_evolution addObject:pokemonPrev];
            }
        }
        
//        self.next_evolution = model[kPokemonNext_Evolution];//Array
        if (model[kPokemonNext_Evolution]) {
            for (NSDictionary *modelNextPokemon in model[kPokemonNext_Evolution]) {
                PDV_NextPokemon *pokemonNext = [[PDV_NextPokemon alloc] initWithDictionaryRepresentation:modelNextPokemon];
                [self.prev_evolution addObject:pokemonNext];
            }
        }
        
    }
    return self;
}

@end
