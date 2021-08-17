//
//  CoreDataHelper.m
//  wehfuio
//
//  Created by Rodion Molchanov on 25.01.2021.
//

#import "CoreDataHelper.h"
#import <CoreData/CoreData.h>
#import "wehfuio-Swift.h"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper
+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
       [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
       [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:nil];
    if (!store) {
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
      
    [self save];
}

- (BOOL)isExistMapPrice:(MapPrice *)mapPrice {
    return [self mapPriceFromCD: mapPrice] != nil;
}

- (MapPriceCD *)mapPriceFromCD:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MapPriceCD"];
    request.predicate = [NSPredicate predicateWithFormat:@"destination.name == %@ AND origin.name == %@", mapPrice.destination.name, mapPrice.origin.name];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (void)addMapPriceToFavorite:(MapPrice *)mapPrice {
    
//    if (![self isExistMapPrice: mapPrice]) {
        MapPriceCD *mapPriceCD = [NSEntityDescription insertNewObjectForEntityForName:@"MapPriceCD" inManagedObjectContext:_managedObjectContext];
        mapPriceCD.destination = mapPrice.destination;
        mapPriceCD.origin = mapPrice.origin;
        mapPriceCD.departure = mapPrice.departure;
        mapPriceCD.returnDate = mapPrice.returnDate;
        mapPriceCD.numberOfChanges = mapPrice.numberOfChanges;
        mapPriceCD.value = mapPrice.value;
        mapPriceCD.distance = mapPrice.distance;
        mapPriceCD.actual = mapPrice.actual;
        
        [self save];
    
   
//    }
    
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray*)getAllMapPrices {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MapPriceCD"];
    
    return  [_managedObjectContext executeFetchRequest:request error:nil];
    
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (NSArray*)getAllSection {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MapPriceCD"];
    FavoritSection* tickets = [[FavoritSection alloc] initWithNameAndArray:@"Tickets" :[self favorites]];
    FavoritSection* mapPrices = [[FavoritSection alloc] initWithNameAndArray:@"Map prices" :[self getAllMapPrices]];
    return  [[NSArray alloc] initWithObjects:tickets, mapPrices, nil];
    
}

@end
