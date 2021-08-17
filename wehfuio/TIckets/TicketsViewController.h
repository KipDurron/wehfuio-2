//
//  TicketsViewController.h
//  wehfuio
//
//  Created by Rodion Molchanov on 20.01.2021.
//

#import <UIKit/UIKit.h>
#import "NotificationCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController
- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;
@end

NS_ASSUME_NONNULL_END
