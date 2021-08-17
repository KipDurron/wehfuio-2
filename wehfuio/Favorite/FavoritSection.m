//
//  FavoritSection.m
//  wehfuio
//
//  Created by Илья Кадыров on 03.06.2021.
//

#import "FavoritSection.h"

@implementation FavoritSection

- (instancetype)initWithNameAndArray: (NSString*) name : (NSArray*)array
{
    self = [super init];
    if (self) {
        _name = name;
        _array = array;
    }
    return self;
}

@end
