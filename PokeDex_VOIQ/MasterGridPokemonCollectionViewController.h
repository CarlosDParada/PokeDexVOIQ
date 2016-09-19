//
//  MasterGridPokemonCollectionViewController.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/19/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDV_WebService.h"
#import "PDV_Pokemon_Obj.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"
#import "PDV_CellMenuTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterGridPokemonCollectionViewController : UICollectionViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *PokemonInWebService;

@property (strong , nonatomic )NSString *nextURL;

@property (weak, nonatomic) PDV_Pokemon_Obj *Obj_PokeHomeWebService;
@property (strong , nonatomic )MBProgressHUD *hudHome;

@property (strong, nonatomic) NSMutableArray *PokemonByGenderInWebService;

@end
