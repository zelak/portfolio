//
//  CardListViewController.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import "CardListViewController.h"
#import "CardCell.h"
#import "CardDetailViewController.h"
#import "Connection.h"
#import "PoliteServer.h"
#import "AskConnectionAlerView.h"

@interface CardListViewController ()

@end

@implementation CardListViewController

@synthesize cards;
@synthesize receivedData;
@synthesize jsonResp;
@synthesize conSearch;
@synthesize conConnect;
@synthesize refreshControl;
@synthesize cardToConnect;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

/*** Customize Appearance - Enable pull down to refresh feature ***/
- (void)configureRefreshControl
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    // set "Pull down to refresh!" message
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh!"];
    // configure selector that will be called when user pulls down the list
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    // enable refresh control in this View Controller
    [self setRefreshControl:refresh];
    [self.view addSubview:refresh];
}

/*** Customize Appearance - Set refresh control message ***/
- (void)showRefreshMessage:(UIRefreshControl*)refresh
{
    // set "Refreshing data..." message
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // set with last update date and time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

/*** Customize Appearance - Set overall appearance ***/
/* this method is called first time this view controller loads */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRefreshControl];
    [self loadCards];
}

/*** Refresh Control - Refresh card list ***/
/* this method will be called every time user pulls down the list */
-(void)refreshView:(UIRefreshControl *)refresh
{
    // Call reload method
    [self loadCards];
    // show refresh control message
    [self showRefreshMessage:refresh];
    // End refreshing
    [refresh endRefreshing];
}

#pragma mark - Table view data source

/*** Table View - Get number of sections in list ***/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // only one section
    return 1;
}

/*** Table View - Get number of rows in section ***/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return size of cards list
    return [cards count];
}

/*** Table View - Update table cell with card detail ***/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get cell to update
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    
    // check row number is not greatter than cards list size
    if (indexPath.row < [cards count]) {
        // update cell with cards item
        [cell setDetailWithCard:[cards objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - Table view delegate

/*** Table View - Get row and show an alert box asking for user to confirm connection request ***/
/* this method will be called every time user selects a row */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // save card to connect in view controller - it will be used when user answers the alert box 
    self.cardToConnect = [cards objectAtIndex:indexPath.row];
    
    // show alert box
    AskConnectionAlerView *alert = [[AskConnectionAlerView alloc]initWithName:self.cardToConnect.name:self];
    [alert show];
    
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*** Alert View - Get user answer and send connect user request ***/
/* this method will be called when user selects a button of alert view ***/
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Did user press OK?
    if (buttonIndex == 0) {
        
        PoLog(@"OK");
        [self sendConnectUserRequest:self.cardToConnect];
        self.cardToConnect = nil;
    }
    else {
        
        PoLog(@"Cancel");
        self.cardToConnect = nil;
    }
}

/*** Connection - Send connect_user request ***/
- (void)sendConnectUserRequest:(Card*)userCard
{
    PoLog(@"Creating relationship with user %@ id %d", self.cardToConnect.name, self.cardToConnect.userId);
    
    [PoliteServer requestConnectionToUser:userCard.userId
                                  success:^(NSArray *data) {
                                      PoLog(@"Connection 'connection' DidFinishLoading...");
                                  }
                                  failure:^(NSError *error) {
                                      PoLog(@"Error trying to create relationship with user.");
                                  }];
}

/*** Connection - Send search_user request ***/
- (void)sendSearchUserRequest:(NSString*)searchField
{
    PoLog(@"Getting politers list...");
    
    [PoliteServer searchUserSuccess:^(NSArray *data) {
                                cards = data;
                                // refresh table view
                                [self.tableView reloadData];
                            }
                            failure:^(NSError *error) {
                                PoLog(@"Error trying to get politers list");
                            }];
}

/*** Connection - Load card list ***/
- (void)loadCards
{
    [self sendSearchUserRequest:nil];
}

#if 0
/*** Card Wrapper - Add server URL to file string ***/
- (NSString*)addServerURL:(NSString*)file
{
    NSString *output = nil;
    if (file) {
        NSArray *split = [file componentsSeparatedByString:@"."];
        ConnectionObject *conn = [Connection shared].connection;
        output = [NSString stringWithFormat:@"%@%@_t.%@", conn.serverUrl, split[0], split[1]];
    }
    
    return output;
}


/*** Card Wrapper - Create an array with contents of receiver JSON data ***/
- (NSMutableArray*)jsonToCards:(NSData*)data
{
    NSError *error;
    // convert received JSON data to a dictionary
    NSDictionary *dictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    PoLog(@"%@",dictionary);
    //NSLog(@"%@",dictionary);
    
    // get result array
    NSArray *result = (NSArray*)[dictionary objectForKey:@"result"];
    
    // alloc output array
    NSMutableArray *output = [[NSMutableArray alloc]init];
    
    // convert every element of result array to Card type and add to output array
    for (NSDictionary *element in result) {
        
        // convert element to card
        Card *card = [[Card alloc]init];
        card.userId = [[element objectForKey:@"id"]intValue];
        card.alias = [element objectForKey:@"alias"];
        card.name = [element objectForKey:@"name"];
        card.connectedTo = [element objectForKey:@"connected_to"];
        card.avatarUrl = [self addServerURL:[element objectForKey:@"avatar"]];
        card.cardUrl = [self addServerURL:[element objectForKey:@"card"]];
        
        // add card to output array
        [output addObject:card];
    }
    
    return output;
}
#endif

@end
