//
//  PDV_ParcialPokemon_PokeAPi.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/17/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDV_ParcialPokemon_PokeAPi : NSObject
@property (strong, nonatomic) NSString *count_parcialPokeAPI;
@property (strong, nonatomic) NSString *previous_parcialPokeAPI;
@property (strong, nonatomic) NSMutableArray *results_parcialPokeAPI;
@property (strong, nonatomic) NSString *next_parcialPokeAPI;


- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)ParcialPokeApiModel;

@end
