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
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController ()<MBProgressHUDDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Button Grid
    UIBarButtonItem *addButtonR = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"grid_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeToGridView) ];
    addButtonR.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButtonR;
    
    // Button Left
    UIBarButtonItem *addButtonL = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeToGridView) ];
    addButtonR.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = addButtonL;
    
    //
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self LoadPokemonWebService]; // Load Pokemon
    //Refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1];
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

-(void)changeToGridView{
    UIAlertController *alertControllerWS =[UIAlertController alertControllerWithTitle:@"Ups" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertControllerWS.message = [NSString stringWithFormat:@"\n Este codigo no esta implementado \n\n Proximamente..."];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertControllerWS addAction:okAction];
    [self presentViewController:alertControllerWS animated:YES completion:nil];

}
#pragma mark - Load Pokemon
-(void)LoadPokemonWebService{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.color =[ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1];
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    [webservice getAllPokemonOnSucess:^(NSMutableArray *allPokemon) {
        NSLog(@"Ok Get");
        self.PokemonInWebService = allPokemon;
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
    
    
    
}

- (void)LoadPokemon{
    // Reload table data
    [self LoadPokemonWebService];
    
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
    hud.color =[ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:nameImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.labelText = @" ";
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:[delay doubleValue]];
    
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:
(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.objects.count;
    return [self.PokemonInWebService count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PDV_Pokemon_Obj *Poke = self.PokemonInWebService[indexPath.row];
    
    
    cell.textLabel.text = Poke.name_pokemon;
    NSString *Type =[NSString stringWithFormat:@"%@",Poke.Array_type];
    cell.detailTextLabel.text =Type;
    //    cell.imageView.image =  [self loadImage:Poke.img_url];
    
    NSString *cadenaURL = Poke.img_url;
    __weak UIImageView *weakImageView = cell.imageView;
    
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cadenaURL]] placeholderImage:[UIImage imageNamed:@"cualpokemon.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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
    
    
    
    return cell;
}
- (UIImage *)loadImage:(NSString *)url{
    
    UIImage *image = [[UIImage alloc]init];
    NSString *cadenaURL = url;
    NSURL *objURL = [[NSURL alloc]initWithString:cadenaURL ];
    NSData *dataImage = [NSData dataWithContentsOfURL:objURL];
    image = [UIImage imageWithData: dataImage];
    
    return (image);
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.PokemonInWebService removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark
-(void) chargeJson{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pokedex" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSLog(@"%@",jsonDataArray);
    
}
@end
