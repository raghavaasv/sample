//
//  ViewController.m
//  sample
//
//  Created by NGT Developer on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import "ViewController.h"
#import "AcronymDataModel.h"
#import "AFNetworking+MBProgressHUD.h"

@interface ViewController () <MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end

@implementation ViewController

@synthesize searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks
    HUD.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request Code

- (void)executeAcronymRequest {
    // Do something usefull in here instead of sleeping ...
//   NSDictionary* params = @{@"sf":self.searchText};
  NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.searchText, @"sf", nil];
   NSURLSessionDataTask* task = [AcronymDataModel requestAcronyms:params andCompletionBlock:^(NSArray *responseArray, NSError *error) {
        if (!error) {
            self.acronymArray = responseArray;
            [self.tableView reloadData];
        }
    }];
    
    [HUD startAnimation:YES forTask:task];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %@",searchText);
    self.searchText = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self executeAcronymRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.acronymArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    AcronymDataModel* acronData = [self.acronymArray objectAtIndex:[indexPath row]];
    if(acronData){
        cell.textLabel.text = [NSString stringWithFormat:@"LF: %@", acronData.longForm];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Since: %@ and Frequency: %@", acronData.since,acronData.frequency];
    }

    return cell;
    
}




@end
