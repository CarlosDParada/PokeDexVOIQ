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

    [manager GET:URL.absoluteString parameters:nil progress:^(NSProgress *downloadProgress) {
        NSLog(@"Progress \n %@",downloadProgress);
    }success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    
        NSMutableArray *TempAllPokemon = [[NSMutableArray alloc]init];
        for (NSDictionary *modelOnePokemon in responseObject[kPokemonAll]) {
            PDV_Pokemon_Obj *OnePokemon = [[PDV_Pokemon_Obj alloc] initWithDictionaryRepresentation:modelOnePokemon];
            [TempAllPokemon addObject:OnePokemon];

        }
        sucessBlock( TempAllPokemon);
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureBlock(error);
    }];


}
@end
