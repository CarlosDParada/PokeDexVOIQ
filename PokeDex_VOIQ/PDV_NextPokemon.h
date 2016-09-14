//
//  PDV_NextPokemon.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+StripNSNulls.h"
#import "PDV_Constans.h"

@interface PDV_NextPokemon : NSObject
@property (strong, nonatomic) NSString *num_NextPokemon;
@property (nonatomic, strong) NSString *name_NextPokemon;


- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonNextModel;


@end
