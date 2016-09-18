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
        self.name_pokemon = model[kPokemonName];
        //self.Array_Image_Sprite = model[kPokemonSprites];//Array
        self.height = model[kPokemonHeight];
        self.weight = model[kPokemonWeight];
        self.Array_Type = model[kPokemonTypes];
        self.Array_Statis = model[kPokemonStats];
        self.base_experience = model[kPokemonBaseExp];
        
//        self.prev_evolution = model[kPokemonPrev_Evolution];//Array
        if (model[kPokemonSprites]) {
            NSMutableArray *tempURLIamge = [[NSMutableArray alloc]init];
            for (NSDictionary *modelSpritePokemon in model[kPokemonSprites]) {
                NSString *pokemonURLImage =[model[kPokemonSprites] objectForKey:modelSpritePokemon];
                if (![pokemonURLImage isKindOfClass:[NSNull class]]) { // validation Null
                    [tempURLIamge addObject:pokemonURLImage];
                }
            }
            self.Array_Image_Sprite = tempURLIamge;
        }
        
//        if (model[kPokemonNext_Evolution]) {
//            for (NSDictionary *modelNextPokemon in model[kPokemonNext_Evolution]) {
//                PDV_NextPokemon *pokemonNext = [[PDV_NextPokemon alloc] initWithDictionaryRepresentation:modelNextPokemon];
//                [self.prev_evolution addObject:pokemonNext];
//            }
//        }
        
    }
    return self;
}
-(id)objectAtIndex:(NSDictionary *)dict index:(int)anIndex {
    
    NSNumber* key = [NSNumber numberWithInt:anIndex];
    id object = [dict objectForKey:key];
    return object;
}
@end
