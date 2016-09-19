//
//  PDV_Gender_PokeApi.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/18/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDV_Gender_PokeApi : NSObject
@property (strong, nonatomic) NSString *id_objPokeAPI;
@property (nonatomic, strong) NSString *gender_objPokeAPI;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)Gender_PokeApi_Model;
@end
