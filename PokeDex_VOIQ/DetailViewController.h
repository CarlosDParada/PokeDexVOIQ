//
//  DetailViewController.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDV_Obj_PokeApi.h"
#import "PDV_Pokemon_Obj.h"
#import "PDV_Obj_PokeApi.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PDV_Constans.h"
#import "PDV_WebService.h"

#import "AFImageDownloader.h"

@interface DetailViewController : UIViewController
@property (strong,nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPokemon;
@property (weak, nonatomic) IBOutlet UILabel *id_Poke_Label;
@property (weak, nonatomic) IBOutlet UILabel *name_Poke_Label;
@property (weak, nonatomic) IBOutlet UILabel *gender_Poke_Label;
@property (weak, nonatomic) IBOutlet UILabel *weight_Poke_Label;
@property (weak, nonatomic) IBOutlet UILabel *height_Poke_Label;


@property (weak, nonatomic) NSString *id_PokeMenu;
@property (weak, nonatomic) NSString *name_PokeMenu;
@property (weak , nonatomic) UIImageView *imagePokeMenu;
@property (weak, nonatomic) PDV_Obj_PokeApi *Obj_PokeMenu;
@property (strong, nonatomic) PDV_Pokemon_Obj *Obj_PokeWebService;

@property (weak, nonatomic) PDV_WebService *webservice;
@end

