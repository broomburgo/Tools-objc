#import "NSDictionary+Map.h"

@implementation NSDictionary (Map)

- (NSDictionary*)append:(NSDictionary *)otherDictionary {
    if (otherDictionary.count == 0) {
        return self;
    }
    NSMutableDictionary* m_self = [NSMutableDictionary dictionaryWithDictionary:self];
    [m_self addEntriesFromDictionary:otherDictionary];
    return [NSDictionary dictionaryWithDictionary:m_self];
}

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id key, id object))reduceBlock {
    if (self.count < 1) {
        return startingElement;
    }
    if (reduceBlock == nil) {
        return startingElement;
    }
    __block id reduced = startingElement;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        reduced = reduceBlock(reduced, key, obj);
    }];
    return reduced;
}

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock {
    if (self.count < 1) {
        return self;
    }
    if (mapBlock == nil) {
        return self;
    }
    NSMutableDictionary* m_reduced = [self reduceWithStartingElement:[@{} mutableCopy] reduceBlock:^NSMutableDictionary*(NSMutableDictionary* m_accumulator, id key, id object) {
        NSDictionary* currentDictionary = mapBlock(key, object);
        if (currentDictionary != nil) {
            [m_accumulator addEntriesFromDictionary:currentDictionary];
        }
        return m_accumulator;
    }];
    return [NSDictionary dictionaryWithDictionary:m_reduced];
}

- (NSDictionary*)filter:(BOOL(^)(id key, id object))filterBlock {
    if (self.count < 1) {
        return self;
    }
    if (filterBlock == nil) {
        return self;
    }
    NSMutableDictionary* m_reduced = [self reduceWithStartingElement:[@{} mutableCopy] reduceBlock:^NSMutableDictionary*(NSMutableDictionary* m_accumulator, id key, id object) {
        if (filterBlock(key,object) == YES) {
            [m_accumulator setObject:object forKey:key];
        }
        return m_accumulator;
    }];
    return [NSDictionary dictionaryWithDictionary:m_reduced];
}

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedUsingComparator:(NSComparisonResult(^)(id object1, id object2))comparator {
    if (self.count < 1) {
        return nil;
    }
    if (mapBlock == nil) {
        return nil;
    }
    NSMutableArray* m_reduced = [self reduceWithStartingElement:[@[] mutableCopy] reduceBlock:^NSMutableArray*(NSMutableArray* m_accumulator, id key, id object) {
        id currentObject = mapBlock(key, object);
        if (currentObject != nil) {
            [m_accumulator addObject:currentObject];
        }
        return m_accumulator;
    }];
    if (comparator) {
        [m_reduced sortUsingComparator:comparator];
    }
    return [NSArray arrayWithArray:m_reduced];
}

- (NSDictionary*)mergeWith:(NSDictionary *)otherDictionary {
    if (otherDictionary.count == 0) {
        return self;
    }
    return [[self map:^NSDictionary *(id key, id object) {
        id otherObject = [otherDictionary objectForKey:key];
        if (otherObject == nil) {
            return @{key: object};
        }
        else if ([otherObject isKindOfClass:[object class]] == NO) {
            return @{key: otherObject};
        }
        else {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dict = (NSDictionary*)object;
                NSDictionary* otherDict = (NSDictionary*)otherObject;
                return @{key: [dict mergeWith:otherDict]};
            }
            else if ([object isKindOfClass:[NSArray class]]) {
                NSArray* array = (NSArray*)object;
                NSArray* otherArray = (NSArray*)otherObject;
                return @{key: [array arrayByAddingObjectsFromArray:otherArray]};
            }
            else {
                return @{key: otherObject};
            }
        }
    }] append:[otherDictionary filter:^BOOL(id key, id object) {
        return [self objectForKey:key] == nil;
    }]];
}

@end
