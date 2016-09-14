//
//  PDV_Pokemon_Obj.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDV_NextPokemon.h"
#import "PDV_Constans.h"


@interface PDV_Pokemon_Obj : NSObject

@property (strong, nonatomic) NSString *id_pokemon;
@property (nonatomic, strong) NSString *num_pokemon;
@property (strong, nonatomic) NSString *name_pokemon;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSMutableArray *Array_type;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *candy;
@property (strong, nonatomic) NSString *candy_count;
@property (strong, nonatomic) NSString *egg;
@property (strong, nonatomic) NSString *multipliers;
@property (strong, nonatomic) NSMutableArray *weaknesses;
@property (strong, nonatomic) NSMutableArray *prev_evolution;
@property (strong, nonatomic) NSMutableArray *next_evolution;


- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonModel;

@end
