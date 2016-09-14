//
//  PDV_AllPokemon.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_AllPokemon.h"


@implementation PDV_AllPokemon


- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)AllPokemonModel{
    NSMutableArray *TempAllPokemon = [[NSMutableArray alloc]init];
    self = [super init];
    if(self){
        NSDictionary *model = [AllPokemonModel $dictionaryByRemovingNSNullValues];
        
        if (model[kPokemonAll]) {
            for (NSDictionary *modelOnePokemon in model[kPokemonAll]) {
                PDV_Pokemon_Obj *OnePokemon = [[PDV_Pokemon_Obj alloc] initWithDictionaryRepresentation:modelOnePokemon];
                [TempAllPokemon addObject:OnePokemon];
                 NSLog(@"allPokemonWB 0 : %@",TempAllPokemon);
            }
        }
//        NSLog(@"allPokemonWB 1\n : %@",TempAllPokemon);
//        self.allPokemonWB = TempAllPokemon;
//        
//        return self;
    }
     self.allPokemonWB = TempAllPokemon;
    return self;
}

@end
