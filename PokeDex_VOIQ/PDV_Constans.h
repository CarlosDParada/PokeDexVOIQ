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

#define KURLPokeAPiV2 @"api/v2/"
// only 10 Pokemon
#define kURLPokemonIDPokeApi @"api/v2/pokemon/"
//http://pokeapi.co/api/v2/pokemon/?offset=0

// Max 721 pokemon's
#define kURLMediaPokemonPokeApi @"media/img/"
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
#define kPokemonNum @"num"
#define kPokemonName @"name"
#define kPokemonImg @"img"
#define kPokemonType @"type"
#define kPokemonHeight @"height"
#define kPokemonWeight @"weight"
#define kPokemonCandy @"candy"
#define kPokemonCandy_Count @"candy_count"
#define kPokemonEgg @"egg"
#define kPokemonMultipliers @"multipliers"
#define kPokemonWeknesses @"weknesses"
#define kPokemonPrev_Evolution @"prev_evolution"
#define kPokemonNext_Evolution @"next_evolution"

#pragma mark - Next Pokemon

#define kPokemonNextNum @"num"
#define kPokemonNextName @"name"


#endif /* PDV_Constans_h */

// Version
//NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
