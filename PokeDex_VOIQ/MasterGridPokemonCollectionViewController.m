//
//  MasterGridPokemonCollectionViewController.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/19/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "MasterGridPokemonCollectionViewController.h"
#import "PDV_Cellrid_CollectionViewCell.h"

@interface MasterGridPokemonCollectionViewController ()

@end

@implementation MasterGridPokemonCollectionViewController

static NSString * const reuseIdentifier = @"CellGridPoke";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
     [self LoadParcialPokemonWebService]; // Load Pokemon
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PDV_CellGrid" bundle:nil] forCellWithReuseIdentifier:@"CellGridPoke"];
    // Do any additional setup after loading the view.
    // Button Grid
    UIBarButtonItem *addButtonR = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(showListHomeView) ];
    addButtonR.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButtonR;
    
    // Button Left
    UIBarButtonItem *addButtonL = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pokedex"] style:UIBarButtonItemStyleDone target:self action:@selector(showInfoDeveloper) ];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = addButtonL;
    
    self.PokemonByGenderInWebService = [[NSMutableArray alloc]init];
    [self LoadPokemonByGender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail2"]) {
        
        PDV_CellMenuTableViewCell *CellPokeHome = sender;
        NSString *indexPokeApi = CellPokeHome.id_universalPokemon.text;
        PDV_Obj_PokeApi *Poke = self.PokemonInWebService[[indexPokeApi intValue ]];
        
        DetailViewController *controller = segue.destinationViewController;
        controller.Obj_PokeMenu= Poke;
        controller.gender_PokeMenu = [self checkTypeGenderPokemon:[[NSString stringWithFormat:@"%@", CellPokeHome.namePokemon.text]lowercaseString]];
        controller.id_PokeMenu =CellPokeHome.id_universalPokemon.text;
        controller.name_PokeMenu = CellPokeHome.namePokemon.text;
        //controller.imagePokeMenu = CellPokeHome.imageView;
        controller.id_PokeMenu = [NSString stringWithFormat:@"%d",[indexPokeApi intValue ]];
        controller.Obj_PokeWebService = self.Obj_PokeHomeWebService;
        
        [self.hudHome hide:YES];
    }
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.PokemonInWebService count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDV_Cellrid_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    

    // Configure the cell
    PDV_Obj_PokeApi *Poke = self.PokemonInWebService[indexPath.row];
    NSString *nameBasePokemon = [ self checkGenderPokemon:Poke.name_objPokeAPI];
    cell.namePokemon.text = [nameBasePokemon capitalizedString] ;
    
    cell.id_universalPokemon.text = [self returnID_PokeAPI:Poke] ;
    
    
    
    NSString *cadenaURL = [NSString stringWithFormat:@"%@%@.png",kURLMedia_PokeApi,[self returnID_PokeAPI:Poke] ];
    __weak UIImageView *weakImageView = cell.imagemPokemon;
    
    
    [cell.imagemPokemon setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cadenaURL]] placeholderImage:[UIImage imageNamed:@"cualpokemon.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //PDV_Cellrid_CollectionViewCell *cell = (PDV_Cellrid_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath: indexPath animated:NO];
    
    
    self.hudHome = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hudHome.color =[ UIColor colorWithRed:(240/255.0) green:(46/255.0) blue:(12/255.0) alpha:0.9];
    self.hudHome.labelText = NSLocalizedString(@"Wait...", @"Wait View");
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    PDV_Cellrid_CollectionViewCell *CellHome = (PDV_Cellrid_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *id_Poke_Select =[NSString stringWithFormat:@"%@",CellHome.id_universalPokemon.text];
    
    [webservice getDataOnePokemon: id_Poke_Select sucessBlock:^(PDV_Pokemon_Obj *Pokemon) {
        self.Obj_PokeHomeWebService =  Pokemon;
        [self performSegueWithIdentifier:@"showDetail2" sender:CellHome];
        
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    //Section 0
    if (indexPath.section == 0) {
        // Is Last row?
        if ([self.PokemonInWebService count] == (indexPath.row+1)) {
            //Yes
            //  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self LoadMoreParcialPokemonInTableView];
        }
        else{
          
        }
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
#pragma mark - CheckGener
-(NSString *)checkGenderPokemon:(NSString * )NamePokemon{
    
    
    if ([NamePokemon containsString:@"-f"]) {
        //NSLog(@"Female");
        NamePokemon = [NamePokemon substringToIndex:[NamePokemon length] - 2];
        NSMutableString *mutableName = [NSMutableString stringWithString:NamePokemon];
        
        for (int p = 0; p < [NamePokemon length]+1; p++) {
            if (p == [NamePokemon length]) {
                [mutableName insertString:@" ♀" atIndex:p];
            }
        }
        return mutableName;
        
    } else if ([NamePokemon containsString:@"-m"]) {
        //NSLog(@"Male");
        NamePokemon = [NamePokemon substringToIndex:[NamePokemon length] - 2];
        NSMutableString *mutableName = [NSMutableString stringWithString:NamePokemon];
        
        for (int p = 0; p < [NamePokemon length]+1; p++) {
            if (p == [NamePokemon length]) {
                [mutableName insertString:@" ♂" atIndex:p];
            }
        }
        return mutableName;
        
    }else {
        // NSLog(@"No gender");
        return NamePokemon;
    }
}

-(void)LoadParcialPokemonWebService{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.color =[ UIColor redColor];
    hud.color= [ UIColor colorWithRed:(240/255.0) green:(46/255.0) blue:(12/255.0) alpha:0.9];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    NSString *URLCall = [NSString stringWithFormat:@"%@%@",KRULBasePokeAPI,kURLPokemonesPokeApi];
    
    [webservice getParcialPokemon:URLCall sucessBlock:^(NSMutableArray *ParcialPokemon, NSString *URLNext) {
        //  NSLog(@"Parcial Pokemon\n %@ \n \nURL\n%@",ParcialPokemon,URLNext);
        self.PokemonInWebService =ParcialPokemon;
        self.nextURL = URLNext;
        [self.collectionView reloadData];
        
        [hud hide:YES];
        //  [self AlertHUD:@"Complete" nameImage:@"Checkmark" delay:@"1"];
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
        [hud hide:YES];
        //  [self AlertHUD:@"Error Webservice" nameImage:@"Errormark" delay:@"3"];
        UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Error WebService" message:nil preferredStyle:UIAlertControllerStyleAlert];
        alertControllerWS.message = [NSString stringWithFormat:@"Code:\n%ld\n\n Detail:\n\n%@",(long)error.code, error.localizedDescription];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertControllerWS addAction:okAction];
        [self presentViewController:alertControllerWS animated:YES completion:nil];
        
    }];
}
#pragma mark - More Pokemon
-(void) LoadMoreParcialPokemonInTableView{
    NSLog(@"URL Next ,%@",self.nextURL);
    
    if (![self.nextURL isKindOfClass:[NSNull class]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        //hud.color =[ UIor];
        hud.color =[ UIColor colorWithRed:(240/255.0) green:(46/255.0) blue:(12/255.0) alpha:0.9];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            PDV_WebService *webservice = [PDV_WebService webservice];
            [webservice getParcialPokemon:self.nextURL sucessBlock:^(NSMutableArray *ParcialPokemon, NSString *URLNext) {
                
                // build the index paths for insertion
                // since you're adding to the end of datasource, the new rows will start at count
                NSMutableArray *indexPaths = [NSMutableArray array];
                NSInteger currentCount = self.PokemonInWebService.count;
                for (int i = 0; i < ParcialPokemon.count; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                }
                
                // do the insertion
                NSMutableArray *TempArray = [[self.PokemonInWebService arrayByAddingObjectsFromArray:ParcialPokemon] mutableCopy];
                self.PokemonInWebService =TempArray;
                self.nextURL = URLNext;
                
                // tell the table view to update (at all of the inserted index paths)
                //[self.collectionView beginUpdates];
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
                //[self.collectionView endUpdates];
                [hud hide:YES];
                
            } onFailure:^(NSError *error) {
                NSLog(@"Error Get %@" ,error.description);
                
                UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Error WebService" message:nil preferredStyle:UIAlertControllerStyleAlert];
                alertControllerWS.message = [NSString stringWithFormat:@"Code:\n%ld\n\n Detail:\n\n%@",(long)error.code, error.localizedDescription];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [hud hide:YES];
                }];
                [alertControllerWS addAction:okAction];
                [self presentViewController:alertControllerWS animated:YES completion:nil];
            }] ;
            
        });
        
    }
}
#pragma mark - Action
-(NSString *)returnID_PokeAPI:(PDV_Obj_PokeApi *)PokeAPI{
    
    NSString *onlyNumber = [[PokeAPI.url_objPokeAPI componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                            componentsJoinedByString:@""];
    NSString *onlyID = [onlyNumber substringWithRange:NSMakeRange(1, [onlyNumber length]-1)];
    
    return onlyID;
    
}
-(void)showInfoDeveloper{
    UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Pokedex VOIQ" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertControllerWS.message = [NSString stringWithFormat:@"\n Developer \n Carlos Parada \n\n Language \n Objective-C \n\n API \n pokeapi.co \n version 2\n\n Library \n AFNetworking \nMBProgressHUD \n\n"];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertControllerWS addAction:okAction];
    [self presentViewController:alertControllerWS animated:YES completion:nil];
    
}
-(void)LoadPokemonByGender{
    for (int i = 1; i <= 3; i++) {
        // [self loadData:i];
        PDV_WebService *webservice = [PDV_WebService webservice];
        //PDV_Gender_PokeApi *listPokemonByGente= [[PDV_Gender_PokeApi alloc]init];
        [webservice getGenderOnePokemon:[NSString stringWithFormat:@"%d",i] sucessBlock:^(PDV_Gender_PokeApi *Gender_Pokemon) {
            [self.PokemonByGenderInWebService addObject:Gender_Pokemon];
        } onFailure:^(NSError *error) {
            NSLog(@"Error = %@",error.userInfo);
        }];
    }
}
-(void)showListHomeView{
    [self.navigationController popViewControllerAnimated:YES];
   // [self performSegueWithIdentifier:@"showList" sender:nil];
}
-(NSString *)checkTypeGenderPokemon:(NSString * )namePokemon{
    //name_objPokeAPI
    PDV_Gender_PokeApi *temp0 = self.PokemonByGenderInWebService[0];
    NSMutableArray *ArrayTemp = temp0.pokemon_species_details;
    BOOL isGenderless = [ArrayTemp containsObject: namePokemon];
    
    if (isGenderless == NO) {
        PDV_Gender_PokeApi *temp1 = self.PokemonByGenderInWebService[1];
        NSMutableArray *ArrayTemp = temp1.pokemon_species_details;
        BOOL isMale = [ArrayTemp containsObject: namePokemon];
        if (isMale==NO) {
            PDV_Gender_PokeApi *temp3 = self.PokemonByGenderInWebService[2];
            NSMutableArray *ArrayTemp = temp3.pokemon_species_details;
            BOOL isFemale = [ArrayTemp containsObject: namePokemon];
            if (isFemale==NO) {
                return @" ";
            }else{
                return temp3.gender_objPokeAPI;
            }
        }else{
            return temp1.gender_objPokeAPI;
        }
    }else {
        return temp0.gender_objPokeAPI;
    }
    return nil;
}
@end
