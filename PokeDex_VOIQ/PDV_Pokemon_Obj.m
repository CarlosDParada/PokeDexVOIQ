//
//  PDV_Pokemon_Obj.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_Pokemon_Obj.h"
#import "PDV_Type_PokeApi.h"
#import "NSDictionary+StripNSNulls.h"

@implementation PDV_Pokemon_Obj
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonModel{
    self = [super init];
    if(self){
        NSDictionary *model = [pokemonModel $dictionaryByRemovingNSNullValues];
        self.id_pokemon = model[kPokemonID];
        self.name_pokemon = model[kPokemonName];
        self.height = model[kPokemonHeight];
        self.weight = model[kPokemonWeight];
        self.Array_Statis = model[kPokemonStats];
        self.base_experience = model[kPokemonBaseExp];
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
        if (model[kPokemonTypes]) {
            NSMutableArray *tempTypePoke = [[NSMutableArray alloc]init];
            for (NSDictionary *modelTypePokemon in model[kPokemonTypes]) {
               
                if (![modelTypePokemon isKindOfClass:[NSNull class]]) { // validation Null
                    PDV_Type_PokeApi *typePoke =[[PDV_Type_PokeApi alloc] initWithDictionaryRepresentation:modelTypePokemon];
                    [tempTypePoke addObject:typePoke];
                }
            }
            
            self.Array_Type = tempTypePoke;
        }
        

        
    }
    return self;
}
-(id)objectAtIndex:(NSDictionary *)dict index:(int)anIndex {
    
    NSNumber* key = [NSNumber numberWithInt:anIndex];
    id object = [dict objectForKey:key];
    return object;
}
@end
