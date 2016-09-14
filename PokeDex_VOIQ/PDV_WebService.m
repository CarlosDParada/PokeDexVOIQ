//
//  PDV_WebService.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/13/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//
// URL : https://dl.dropboxusercontent.com/s/xuegpnywzq9hlvu/pokedex.json?dl=0
#import "PDV_WebService.h"
@interface PDV_WebService()

@end
@implementation PDV_WebService


+ (instancetype)webservice
{
    static PDV_WebService *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        
    });
    
    return  sharedInstance;
}


-(void)trustHost

{
    
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/xuegpnywzq9hlvu/pokedex.json"]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) NSLog(@"ok");
    
    
    
}

-(void)getAllPokemonOnSucess:(ELSuccessBlockWithAllPokemon)sucessBlock
                   onFailure:(FailureBlock)failureBlock{
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/xuegpnywzq9hlvu/pokedex.json"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
  //  manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // a
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    //    NSError *localError = nil; //a
     //   NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&localError]; //a

       /* PDV_AllPokemon *pokemonsJSON = [[PDV_AllPokemon alloc] initWithDictionaryRepresentation:responseObject];
        NSLog(@"AllPokemonsJSON \n %@",pokemonsJSON.allPokemonWB);
         sucessBlock( pokemonsJSON);*/
        NSMutableArray *TempAllPokemon = [[NSMutableArray alloc]init];
        for (NSDictionary *modelOnePokemon in responseObject[kPokemonAll]) {
            PDV_Pokemon_Obj *OnePokemon = [[PDV_Pokemon_Obj alloc] initWithDictionaryRepresentation:modelOnePokemon];
            [TempAllPokemon addObject:OnePokemon];
          //  NSLog(@"allPokemonWB 0 : %@",TempAllPokemon);
        }
        sucessBlock( TempAllPokemon);
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


}
@end
