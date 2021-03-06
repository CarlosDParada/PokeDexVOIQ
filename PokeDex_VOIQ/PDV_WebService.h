//
//  PDV_WebService.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PDV_Pokemon_Obj.h"
#import "PDV_Obj_PokeApi.h"
#import "PDV_Constans.h"
#import <AFNetworking.h>
#import "PDV_Gender_PokeApi.h"

typedef void(^ELSuccessBlockWithOnePokemon)(PDV_Pokemon_Obj  *Pokemon);
typedef void(^ELSuccessBlockWithGenderOnePokemon)(PDV_Gender_PokeApi  *Gender_Pokemon);


typedef void(^ELSuccessBlockWithAllPokemon)(NSMutableArray  *allPokemon);
typedef void(^ELSuccessBlockWithParcialPokemon)(NSMutableArray  *ParcialPokemon , NSString *URLNext);
typedef void(^FailureBlock)(NSError *error);


@interface PDV_WebService : AFHTTPSessionManager

+(instancetype)webservice;


-(void)getAllPokemonOnSucess:(ELSuccessBlockWithAllPokemon)sucessBlock
                     onFailure:(FailureBlock)failureBlock;

-(void)getParcialPokemon:(NSString * )URL_PokeAPi sucessBlock:(ELSuccessBlockWithParcialPokemon)sucessBlock
               onFailure:(FailureBlock)failureBlock;
-(void)getDataOnePokemon:(NSString *)id_pokemon sucessBlock:(ELSuccessBlockWithOnePokemon)sucessBlock
               onFailure:(FailureBlock)failureBlock;
-(void)getGenderOnePokemon:(NSString *)id_pokemon sucessBlock:(ELSuccessBlockWithGenderOnePokemon)sucessBlock
                 onFailure:(FailureBlock)failureBlock;
@end
