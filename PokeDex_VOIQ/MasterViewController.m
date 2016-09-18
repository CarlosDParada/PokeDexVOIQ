//
//  MasterViewController.m
//  PokeDex_VOIQ
//
//  Created by Carlos Parada on 9/12/16.
//  Copyright © 2016 carlosparada. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"
#import "PDV_CellMenuTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController ()<MBProgressHUDDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
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
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PDV_CellMenuTableViewCell *cellHome = [[PDV_CellMenuTableViewCell alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"PDV_CellHome" bundle:nil] forCellReuseIdentifier:@"CellHome"];
    cellHome =[tableView dequeueReusableCellWithIdentifier:@"CellHome"];
    

    
    PDV_Obj_PokeApi *Poke = self.PokemonInWebService[indexPath.row];
    NSString *nameBasePokemon = [ self checkGenderPokemon:Poke.name_objPokeAPI];
    
    //cell.textLabel.text = [nameBasePokemon capitalizedString] ;
     cellHome.namePokemon.text = [nameBasePokemon capitalizedString] ;
    
    cellHome.id_universalPokemon.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1] ;
   
    
    NSString *cadenaURL = [NSString stringWithFormat:@"%@%d.png",kURLMedia_PokeApi,(int)indexPath.row+1];
    //__weak UIImageView *weakImageView = cell.imageView;
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
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.PokemonInWebService removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

*/


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{


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
    //hud.color =[ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:0.8];
    hud.color =[ UIColor lightGrayColor];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    [webservice getAllPokemonOnSucess:^(NSMutableArray *allPokemon) {
        // NSLog(@"Ok Get");
        NSMutableArray *TempArray = [[allPokemon arrayByAddingObjectsFromArray:self.PokemonInWebService] mutableCopy];
        self.PokemonInWebService =TempArray;
        [self.tableView reloadData];
        
        [hud hide:YES];
        [self AlertHUD:@"Complete" nameImage:@"Checkmark" delay:@"2"];
        
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
        
        [hud hide:YES];
        [self AlertHUD:@"Error Webservice" nameImage:@"Errormark" delay:@"3"];
        UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Error WebService" message:nil preferredStyle:UIAlertControllerStyleAlert];
        alertControllerWS.message = [NSString stringWithFormat:@"Code:\n%ld\n\n Detail:\n\n%@",(long)error.code, error.localizedDescription];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertControllerWS addAction:okAction];
        [self presentViewController:alertControllerWS animated:YES completion:nil];
    }] ;
    [webservice getParcialPokemon:kURLPokemonIDPokeApi sucessBlock:^(NSMutableArray *ParcialPokemon, NSString *URLNext) {
        //NSLog(@"Parcial Pokemon\n %@ \n \nURL\n%@",ParcialPokemon,URLNext);
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get %@" ,error.description);
    }];
    
    
}
-(void)LoadParcialPokemonWebService{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.color =[ UIColor redColor];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    NSString *URLCall = [NSString stringWithFormat:@"%@%@",KRULBasePokeAPI,kURLPokemonIDPokeApi];
    
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.color =[ UIColor redColor];
    
    
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
    //hud.color =[ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:0.9];
    hud.color =[ UIColor lightGrayColor];
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
