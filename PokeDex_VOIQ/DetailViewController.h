//
//  DetailViewController.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDV_Obj_PokeApi.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *name_Poke_Label;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBotton;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPokemon;
@property (weak, nonatomic) IBOutlet UILabel *id_Poke_Label;

@property (weak, nonatomic) NSString *id_PokeMenu;
@property (weak, nonatomic) NSString *name_PokeMenu;
@property (weak , nonatomic) UIImageView *imagePokeMenu;
@property (weak, nonatomic) PDV_Obj_PokeApi *Obj_PokeMenu;
@end

