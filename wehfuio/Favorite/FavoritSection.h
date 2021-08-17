//
//  FavoritSection.h
//  wehfuio
//
//  Created by Илья Кадыров on 03.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoritSection : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* array;

- (instancetype)initWithNameAndArray: (NSString*) name : (NSArray*)array;

@end

NS_ASSUME_NONNULL_END
