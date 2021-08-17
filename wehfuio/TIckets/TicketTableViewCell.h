//
//  TicketTableViewCell.h
//  wehfuio
//
//  Created by Rodion Molchanov on 20.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "wehfuio-Swift.h"
#import "MapPrice.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) MapPriceCD* mapPrice;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
-(void)startAnnimation: (NSInteger) indexPathRow ;
@end

NS_ASSUME_NONNULL_END
