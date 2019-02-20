//
//  CardListViewController.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 19/10/12.
//  Copyright (c) 2012 PoliteApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardListViewController : UITableViewController <UIAlertViewDelegate> {
    
}

@property (nonatomic, retain) NSArray *cards;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *jsonResp;
@property (nonatomic, retain) NSURLConnection *conSearch;
@property (nonatomic, retain) NSURLConnection *conConnect;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIRefreshControl *refreshControl;
@property (nonatomic, retain) Card *cardToConnect;

- (void)loadCards;

@end
