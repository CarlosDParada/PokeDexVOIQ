//
//  PDV_ParcialPokemon_PokeAPi.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/17/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_ParcialPokemon_PokeAPi.h"
#import "PDV_Obj_PokeApi.h"
#import "NSDictionary+StripNSNulls.h"
#import "PDV_Constans.h"

@implementation PDV_ParcialPokemon_PokeAPi

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)ParcialPokeApiModel{
    self = [super init];
    if(self){
        NSDictionary *model = [ParcialPokeApiModel $dictionaryByRemovingNSNullValues];
        self.count_parcialPokeAPI = model[kPokeApiURL];
        self.previous_parcialPokeAPI = model[kPokeApiName];
      //  self.results_parcialPokeAPI = model[kPokeApiResults];//Array

        NSMutableArray *TempAllPokemon = [[NSMutableArray alloc]init];
        for (NSDictionary *modelOnePokemon in model[kPokeApiResults]) {
            PDV_Obj_PokeApi *OnePokemon = [[PDV_Obj_PokeApi alloc] initWithDictionaryRepresentation:modelOnePokemon];
            [TempAllPokemon addObject:OnePokemon];
        }
        self.results_parcialPokeAPI = TempAllPokemon;
        self.next_parcialPokeAPI = model[kPokeApiNext];
    }
    
    return self;
}
@end
