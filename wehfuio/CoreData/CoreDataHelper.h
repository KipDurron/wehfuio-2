//
//  CoreDataHelper.h
//  wehfuio
//
//  Created by Rodion Molchanov on 25.01.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
//#import 
#import "Ticket.h"
#import "MapPrice.h"
#import "FavoritSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (void)addMapPriceToFavorite:(MapPrice *)mapPrice;
- (NSArray*)getAllMapPrices;
- (NSArray*)getAllSection;

@end

NS_ASSUME_NONNULL_END
