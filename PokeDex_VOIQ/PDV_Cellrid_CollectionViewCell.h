//
//  PDV_Cellrid_CollectionViewCell.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/19/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDV_Cellrid_CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagemPokemon;
@property (weak, nonatomic) IBOutlet UILabel *id_universalPokemon;
@property (weak, nonatomic) IBOutlet UILabel *namePokemon;
@end
