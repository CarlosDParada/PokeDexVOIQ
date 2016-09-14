//
//  PDV_AllPokemon.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDV_Pokemon_Obj.h"
#import "PDV_Constans.h"
#import "NSDictionary+StripNSNulls.h"

@interface PDV_AllPokemon : NSObject

@property (weak, nonatomic) NSMutableArray *allPokemonWB;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)AllPokemonModel;


@end
