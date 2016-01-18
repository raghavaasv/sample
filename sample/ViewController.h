//
//  ViewController.h
//  sample
//
//  Created by NGT Developer on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *acronymArray;
@property (strong, nonatomic) NSString *searchText;

@end

