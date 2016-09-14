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

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.color =[ UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1];
    // Set the label text.
    hud.labelText = NSLocalizedString(@"Loading...", @"Download DataBase");
    
    
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    [webservice getAllPokemonOnSucess:^(NSMutableArray *allPokemon) {
        NSLog(@"Ok Get");
        self.PokemonInWebService = allPokemon;
        [self.tableView reloadData];
        
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        hud.square = YES;
        // Optional label text.
        hud.labelText = NSLocalizedString(@"Complete", @"CompleteWB");
        // Configure the button.
     

        
        [hud hide:YES afterDelay:2];
        
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get");
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"Errormark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        hud.square = YES;
        // Optional label text.
        hud.labelText = @" ";
        hud.detailsLabelText = NSLocalizedString(@"Error WebService", @"ErroWB");
    }] ;
    
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
    
    /*
    PDV_WebService *webservice = [PDV_WebService webservice];
    
    [webservice getAllPokemonOnSucess:^(PDV_AllPokemon *allPokemon) {
        NSLog(@"Ok Get");
    } onFailure:^(NSError *error) {
        NSLog(@"Error Get");
    }] ;*/
    
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
        // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
        UIImageView *strongImageView = weakImageView; // make local strong reference to protect against race conditions
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Failed Load Image");
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
