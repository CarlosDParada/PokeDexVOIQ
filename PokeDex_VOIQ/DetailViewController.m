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

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.viewTop.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [self.viewTop.layer insertSublayer:gradient atIndex:0];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
 CAGradientLayer *gradient = [CAGradientLayer layer];
 gradient.frame = view.bounds;
 gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
 [view.layer insertSublayer:gradient atIndex:0];
 */
@end
