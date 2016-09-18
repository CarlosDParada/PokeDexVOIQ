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

@property (strong, nonatomic) NSString *id_pokemon; //id
@property (strong, nonatomic) NSString *name_pokemon; // name
@property (strong, nonatomic) NSString *img_url; //
@property (strong, nonatomic) NSMutableArray *Array_Image_Sprite; // sprite
@property (strong, nonatomic) NSString *height; //height
@property (strong, nonatomic) NSString *weight; //weight
@property (strong, nonatomic) NSString *base_experience;
@property (strong, nonatomic) NSMutableArray *Array_Type;
@property (strong, nonatomic) NSMutableArray *Array_Abilities;
@property (strong, nonatomic) NSMutableArray *Array_Statis;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)pokemonModel;

@end
