//
//  DetailViewController.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "DetailViewController.h"
#import "PDV_Obj_PokeApi.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PDV_Constans.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
   // [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -1] animated:YES];
}
- (void)configureView {
    // Update the user interface for the detail item.
    if (self.name_PokeMenu) {
        self.name_Poke_Label.text = self.name_PokeMenu;
    }
    if (self.id_PokeMenu) {
        [self.id_Poke_Label setText:self.id_PokeMenu];
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

@end
