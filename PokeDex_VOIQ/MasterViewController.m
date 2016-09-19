//
//  MasterViewController.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "MasterViewController.h"


@interface MasterViewController ()<MBProgressHUDDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Button Grid
    UIBarButtonItem *addButtonR = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"grid_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeToGridView) ];
    addButtonR.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButtonR;
    
    // Button Left
    UIBarButtonItem *addButtonL = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pokedex"] style:UIBarButtonItemStyleDone target:self action:@selector(changeToGridView) ];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = addButtonL;
    
    //
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
   [self LoadParcialPokemonWebService]; // Load Pokemon
   // [self LoadPokemonWebService];
    
    //Refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(LoadPokemon)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    // [self LoadPokemonWebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [self chargeJson];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PDV_Obj_PokeApi *Poke = self.PokemonInWebService[indexPath.row];
        PDV_CellMenuTableViewCell *CellPokeHome = sender;
        
        DetailViewController *controller = segue.destinationViewController;
        controller.Obj_PokeMenu= Poke;
        controller.id_PokeMenu =CellPokeHome.id_universalPokemon.text;
        controller.name_PokeMenu = CellPokeHome.namePokemon.text;
        controller.imagePokeMenu = CellPokeHome.imageView;
        controller.id_PokeMenu = [NSString stringWithFormat:@"%d",(int)indexPath.row+1 ];
        controller.Obj_PokeWebService = self.Obj_PokeHomeWebService;
        
        [self.hudHome hide:YES];
    }
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:
(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.objects.count;
    return [self.PokemonInWebService count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDV_CellMenuTableViewCell *cellHome = [[PDV_CellMenuTableViewCell alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"PDV_CellHome" bundle:nil] forCellReuseIdentifier:@"CellHome"];
    cellHome =[tableView dequeueReusableCellWithIdentifier:@"CellHome"];
    
    
    PDV_Obj_PokeApi *Poke = self.PokemonInWebService[indexPath.row];
    NSString *nameBasePokemon = [ self checkGenderPokemon:Poke.name_objPokeAPI];
    cellHome.namePokemon.text = [nameBasePokemon capitalizedString] ;
    
       cellHome.id_universalPokemon.text = [self returnID_PokeAPI:Poke] ;
    
   
   
    NSString *cadenaURL = [NSString stringWithFormat:@"%@%@.png",kURLMedia_PokeApi,[self returnID_PokeAPI:Poke] ];
    __weak UIImageView *weakImageView = cellHome.imagemPokemon;
    
    
    [cellHome.imagemPokemon setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cadenaURL]] placeholderImage:[UIImage imageNamed:@"cualpokemon.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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
    
    
    
    return cellHome;
}
-(NSString *)returnID_PokeAPI:(PDV_Obj_PokeApi *)PokeAPI{
    
    NSString *onlyNumber = [[PokeAPI.url_objPokeAPI componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    NSString *onlyID = [onlyNumber substringWithRange:NSMakeRange(1, [onlyNumber length]-1)];
    
    return onlyID;

}
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
#pragma mark - TableView - Data Source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    self.hudHome = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hudHome.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.9];
    
    //PDV_Obj_PokeApi *Poke = self.PokemonInWebService[indexPath.row];
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    PDV_CellMenuTableViewCell *CellHome = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *id_Poke_Select =[NSString stringWithFormat:@"%@",CellHome.id_universalPokemon.text];
    
    [webservice getDataOnePokemon: id_Poke_Select sucessBlock:^(PDV_Pokemon_Obj *Pokemon) {
         self.Obj_PokeHomeWebService =  Pokemon;
        [self performSegueWithIdentifier:@"showDetail" sender:CellHome];
       
       
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
    }];
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Section 0
    if (indexPath.section == 0) {
        // Is Last row?
        if ([self.PokemonInWebService count] == (indexPath.row+1)) {
            //Yes
            //  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self LoadMoreParcialPokemonInTableView];
        }
        else{
            // other rows
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

#pragma mark - Load Pokemon
-(void)LoadPokemonWebService{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.8];
    hud.color =[ UIColor lightGrayColor];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    for (int i = 0; i < 811; i++) {
        [self loadData:i];
    }
    
     [self.tableView reloadData];
    

    
    
}


-(void)loadData:(int)pokemonID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.8];
    hud.color =[ UIColor lightGrayColor];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
     PDV_WebService *webservice = [PDV_WebService webservice];
    [webservice getDataOnePokemon: [NSString stringWithFormat:@"%d",pokemonID] sucessBlock:^(PDV_Pokemon_Obj *Pokemon) {
        
        [self.PokemonInWebService addObject:Pokemon];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
    }];
    
//    NSString *url = [NSString stringWithFormat:@"http://pokeapi.co/api/v2/pokemon/%d/", pokemonID];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url parameters:nil progress:^(NSProgress *downloadProgress) {
//        NSLog(@"Progress \n %@",downloadProgress);
//    }success:^(NSURLSessionTask *task, id responseObject) {
//       // [self addPokemon:responseObject];
//        
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error Get %@" ,error.description);
//        
//        [hud hide:YES];
//        [self AlertHUD:@"Error Webservice" nameImage:@"Errormark" delay:@"3"];
//        UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Error WebService" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        alertControllerWS.message = [NSString stringWithFormat:@"Code:\n%ld\n\n Detail:\n\n%@",(long)error.code, error.localizedDescription];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        }];
//        [alertControllerWS addAction:okAction];
//        [self presentViewController:alertControllerWS animated:YES completion:nil];
//
//    }];
//    
    
}

///////////

-(void)LoadParcialPokemonWebService{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.color =[ UIColor redColor];
    hud.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.9];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    NSString *URLCall = [NSString stringWithFormat:@"%@%@",KRULBasePokeAPI,kURLPokemonesPokeApi];
    
    [webservice getParcialPokemon:URLCall sucessBlock:^(NSMutableArray *ParcialPokemon, NSString *URLNext) {
      //  NSLog(@"Parcial Pokemon\n %@ \n \nURL\n%@",ParcialPokemon,URLNext);
        self.PokemonInWebService =ParcialPokemon;
        self.nextURL = URLNext;
        [self.tableView reloadData];
        
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
        //hud.color =[ UIColor redColor];
        hud.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.9];
        
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
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
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


- (void)LoadPokemon{
    
    [self LoadParcialPokemonWebService];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Alert HUD

- (void)AlertHUD:(NSString *)message nameImage:(NSString *)nameImage delay:(NSString *)delay {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.color =[ UIColor lightGrayColor];
    hud.color =[ UIColor colorWithRed:(238/255.0) green:(21/255.0) blue:(21/255.0) alpha:0.9];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:nameImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.labelText = @" ";
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:[delay doubleValue]];
    
}

-(void)changeToGridView{
    UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Ups" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertControllerWS.message = [NSString stringWithFormat:@"\n Este codigo no esta implementado \n\n Proximamente..."];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertControllerWS addAction:okAction];
    [self presentViewController:alertControllerWS animated:YES completion:nil];
    
}

-(void) chargeJson{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pokedex" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSLog(@"%@",jsonDataArray);
    
}
@end
