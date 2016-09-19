//
//  PDV_Type_PokeApi.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/18/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDV_Obj_PokeApi.h"

@interface PDV_Type_PokeApi : NSObject

@property (strong, nonatomic) NSString *slot_TypePokeAPI;
@property (nonatomic, strong) PDV_Obj_PokeApi *type_TypePokeAPI;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)Type_PokeApi_Model;


@end
