//
//  PDV_Constans.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//
//#define kPokemon @""

#ifndef PDV_Constans_h
#define PDV_Constans_h

#pragma mark - Webservice

#define kURLWebService @"https://dl.dropboxusercontent.com/s/gz0gk3r63isq442/pokedex.json?dl=0"

#pragma mark - PokeAPI
#define KRULBasePokeAPI @"http://pokeapi.co/"

#define KRULBasePokeAPIV2 @"api/v2/"
// only 10 Pokemon @"api/v2/pokemon/?limit=400"
#define kURLPokemonesPokeApi @"api/v2/pokemon/?limit=400"
#define kURLPokemonIDPokeApi @"api/v2/pokemon/"
//http://pokeapi.co/api/v2/pokemon/?offset=0

// Max 721 pokemon's
#define kURLMedia_PokeApi @"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"

//http://pokeapi.co/media/img/718.png

#define kURLGenderPokeAPi @"api/v2/gender/"
//http://pokeapi.co/api/v2/gender/2/tickets?fields=id,subject,


#pragma mark - obj Response PokeApi
#define kPokeApiURL @"url"
#define kPokeApiName @ "name"

#pragma mark - Parcial Response PokeApi
#define kPokeApiCount @"count"
#define kPokeApiPrevious @ "previous"
#define kPokeApiResults @ "results"
#define kPokeApiNext @ "next"

#pragma mark - AllPokemon

#define kPokemonAll @"pokemon"

#pragma mark - Pokemon

#define kPokemonID @"id"
#define kPokemonName @"name"
#define kPokemonWeight @"weight"
#define kPokemonSprites @"sprites"
#define kPokemonHeight @"height"
#define kPokemonTypes @"types"
#define kPokemonStats @"stats"

#define kPokemonBaseExp @"base_experience"



#pragma mark - Next Pokemon

#define kPokemonNextNum @"num"
#define kPokemonNextName @"name"


#endif /* PDV_Constans_h */

// Version
//NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
