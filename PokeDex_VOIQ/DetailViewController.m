//
//  DetailViewController.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  //  [self LoadPokemonWB];
    [self LoadSpriteImage];
    [self configureView];
    
    
    self.navigationItem.title = self.name_PokeMenu;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.webservice.operationQueue cancelAllOperations];
}
- (void)configureView {
    // Update the user interface for the detail item.

    if (self.Obj_PokeWebService.id_pokemon) {
        [self.id_Poke_Label setText:[NSString stringWithFormat:@"%@",self.Obj_PokeWebService.id_pokemon]];
    }
    if(self.name_PokeMenu)
        [self.name_Poke_Label setText:[NSString stringWithFormat:@"%@",self.name_PokeMenu]];
    if (self.gender_PokeMenu) {
        self.gender_Poke_Label.text =[ [NSString stringWithFormat:@"%@",self.gender_PokeMenu]capitalizedString];
    }
    if (self.Obj_PokeWebService.height) {
        [self.height_Poke_Label setText:[NSString stringWithFormat:@"%@",self.Obj_PokeWebService.height]];
    }
    if (self.Obj_PokeWebService.weight) {
        [self.weight_Poke_Label setText:[NSString stringWithFormat:@"%@",self.Obj_PokeWebService.weight]];
    }
    if (self.Obj_PokeWebService.Array_Type) {
        if(  self.Obj_PokeWebService.Array_Type.count == 1) {
            //One Type
            PDV_Type_PokeApi *temType = self.Obj_PokeWebService.Array_Type[0];
            self.type_Poke_Label.text = [[NSString stringWithFormat:@"%@",temType.type_TypePokeAPI.name_objPokeAPI] capitalizedString];
            
        }else if ( self.Obj_PokeWebService.Array_Type.count == 2) {
            // Two Type
            //One Type
            PDV_Type_PokeApi *temType = self.Obj_PokeWebService.Array_Type[0];
            PDV_Type_PokeApi *temType2 = self.Obj_PokeWebService.Array_Type[1];
            self.type_Poke_Label.text = [[NSString stringWithFormat:@"%@ / %@",temType2.type_TypePokeAPI.name_objPokeAPI,temType.type_TypePokeAPI.name_objPokeAPI] capitalizedString];

        }else{
            self.type_Poke_Label.text = @" ";
        }
        
    }
    __weak UIImageView *weakImageView = self.imageViewPokemon;
    NSString *cadenaURL = [NSString stringWithFormat:@"%@%@.png",kURLMedia_PokeApi,self.id_PokeMenu];
    
    [self.imageViewPokemon setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cadenaURL]] placeholderImage:[UIImage imageNamed:@"cualpokemon.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView *strongImageView = weakImageView;
        if (!strongImageView) return;
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", [NSString stringWithFormat:@"Failed Load Image \n request - %@ \n response - %@ \n error - %@",request,response,error.description]);
    }];
   
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    @autoreleasepool {
        UIImage * result;
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
        result = [UIImage imageWithData:data];
        
        return result;
    }
}
-(void)LoadPokemonWB{
    self.webservice = [PDV_WebService webservice];
    [self.webservice getDataOnePokemon:self.id_PokeMenu sucessBlock:^(PDV_Pokemon_Obj *Pokemon) {
        self.Obj_PokeWebService =  Pokemon;
        
        self.weight_Poke_Label.text = self.Obj_PokeWebService.weight;
        self.height_Poke_Label.text = self.Obj_PokeWebService.height;
        [self LoadSpriteImage];
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
    }];

}

-(void)LoadSpriteImage{

    // Load images
    NSArray *URLs_ImagePokemonWB = [NSArray arrayWithArray:self.Obj_PokeWebService.Array_Image_Sprite];
    NSMutableArray *imagePokemonWB = [[NSMutableArray alloc]init];
    
    for (NSString *URLImageOnePokemon in URLs_ImagePokemonWB) {
        UIImage *imagePokeWS = [self getImageFromURL:URLImageOnePokemon];
        [imagePokemonWB addObject:imagePokeWS ];
    }
    
    // Normal Animation
    UIImageView *animationImageView = self.imageViewPokemon;
    animationImageView.animationImages = imagePokemonWB;
    animationImageView.animationDuration = 6;
    
    //[self.view addSubview:animationImageView];
    [animationImageView startAnimating];}

@end
