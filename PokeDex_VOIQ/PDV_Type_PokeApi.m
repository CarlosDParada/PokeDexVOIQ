//
//  PDV_Type_PokeApi.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/18/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "PDV_Type_PokeApi.h"
#import "NSDictionary+StripNSNulls.h"
#import "PDV_Constans.h"

@implementation PDV_Type_PokeApi
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)Type_PokeApi_Model{
    self = [super init];
    if(self){
        NSDictionary *model = [Type_PokeApi_Model $dictionaryByRemovingNSNullValues];
        self.slot_TypePokeAPI = model[kPokeApiSlot];
        self.type_TypePokeAPI = [[PDV_Obj_PokeApi alloc] initWithDictionaryRepresentation: model[kPokeApiType]];
        //NSLog(@"type %@",self.type_TypePokeAPI.name_objPokeAPI);
    }
    return self;
}
@end
