//
//  PDV_WebService.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PDV_AllPokemon.h"
#import "PDV_Constans.h"
#import <AFNetworking.h>

typedef void(^ELSuccessBlockWithAllPokemon)(NSMutableArray  *allPokemon);
typedef void(^FailureBlock)(NSError *error);


@interface PDV_WebService : AFHTTPSessionManager

+(instancetype)webservice;

//-(AFHTTPSessionManager *)httpClientManager;

-(void)getAllPokemonOnSucess:(ELSuccessBlockWithAllPokemon)sucessBlock
                     onFailure:(FailureBlock)failureBlock;


@end
