//
//  DetailViewController.h
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBotton;
@property (weak, nonatomic) IBOutlet UIImageView *imagePokemon;

@end

