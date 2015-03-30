//
//  ListViewController.m
//  list
//
//  Created by rubys on 3/29/15.
//  Copyright (c) 2015 rubys. All rights reserved.
//

#import "ListViewController.h"
#import "ItemViewController.h"

@interface ListViewController ()

@property NSMutableArray *items;
@property NSMutableArray *filteredItems;

@end

@implementation ListViewController

- (NSString *) dataPath{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent: @"data.txt"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray arrayWithContentsOfFile: [self dataPath]];
    if(!self.items){
        self.items = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"items = %@", [self.items componentsJoinedByString:@", "]);
    NSLog(@"table view tag = %ld", self.tableView.tag);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        return [self.items count];
    }
    return [self.filteredItems count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"item-cell" forIndexPath:indexPath];
    
    if(tableView.tag == 1){
        cell.textLabel.text = [self.items objectAtIndex:[indexPath row]];
    }else{
        cell.textLabel.text = [self.filteredItems objectAtIndex:[indexPath row]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle != UITableViewCellEditingStyleDelete){
        return;
    }
    
    if(tableView.tag !=1){
        return;
    }
    
    NSLog(@"items = %@, delete row = %ld", [self.items componentsJoinedByString:@", "], [indexPath row]);
    
    [self.items removeObjectAtIndex:[indexPath row]];
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.items writeToFile: [self dataPath] atomically:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"segue identifier = %@", [segue identifier]);
    
    if([[segue identifier] isEqualToString: @"show-detail-segue"]){
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        NSLog(@"select row = %ld", indexPath.row);
        
        NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [[segue destinationViewController] setItemIndex: index];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"search text change = %@", searchText);
    
    if([searchText length] == 0){
        [self.tableView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchText, searchText];
    self.filteredItems = [[self.items filteredArrayUsingPredicate: predicate] mutableCopy];
    
    NSLog(@"filter items = %@", [self.filteredItems componentsJoinedByString:@", "]);
    
    [self.tableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: @"item-cell"];
}

@end























