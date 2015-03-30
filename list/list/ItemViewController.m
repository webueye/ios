//
//  ItemViewController.m
//  list
//
//  Created by rubys on 3/29/15.
//  Copyright (c) 2015 rubys. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

- (void)showValue;

@end

@implementation ItemViewController

- (NSString *) dataPath{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent: @"data.txt"];
}

- (IBAction)save:(id)sender {
    NSString *itemValue = self.itemTextView.text;
    
    NSMutableArray *items= [NSMutableArray arrayWithContentsOfFile:[self dataPath]];
    if(!items){
        items = [[NSMutableArray alloc] init];
    }
    
    [items addObject: itemValue];
    [items writeToFile: [self dataPath] atomically:YES];
     
    [self performSegueWithIdentifier: @"list-segue" sender:self];
}

- (IBAction)update:(id)sender {
    NSString *itemValue = self.itemTextView.text;
    
    NSMutableArray *items= [NSMutableArray arrayWithContentsOfFile:[self dataPath]];
    
    int index = _itemIndex.intValue;
    NSLog(@"update value = %@, index =  %d", itemValue, index);
    
    items[index] = itemValue;
    
    [items writeToFile: [self dataPath] atomically:YES];
    
    [self performSegueWithIdentifier: @"list-segue" sender:self];
}

- (void)showValue{
    if(self.itemIndex){
        NSMutableArray *items= [NSMutableArray arrayWithContentsOfFile:[self dataPath]];
        int index = _itemIndex.intValue;
        self.itemTextView.text = [items objectAtIndex:index];
        NSLog(@"show value = %@", self.itemTextView.text);
    }
}

- (void)setItemIndex:(NSString *) itemIndex{
    if(_itemIndex != itemIndex){
        NSLog(@"select item row = %@", itemIndex);
        _itemIndex = itemIndex;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showValue];
}

@end

































