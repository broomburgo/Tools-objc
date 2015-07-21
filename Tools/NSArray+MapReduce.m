#import "NSArray+MapReduce.h"

@implementation NSArray (MapReduce)

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id (^)(id, id))reduceBlock {
    if (self.count < 1) {
        return startingElement;
    }
    if (reduceBlock == nil) {
        return startingElement;
    }
    __block id reduced = startingElement;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        reduced = reduceBlock(reduced, obj);
    }];
    return reduced;
}

- (NSArray*)map:(id(^)(id object))mapBlock {
    return [[self reduceWithStartingElement:[@[] mutableCopy] reduceBlock:^id(id accumulator, id object) {
        NSMutableArray* currentAccumulator = (NSMutableArray*)accumulator;
        id currentObject = mapBlock(object);
        if (currentObject) {
            [currentAccumulator addObject:currentObject];
        }
        return currentAccumulator;
    }] copy];
}

- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock {
    if (mapBlock == nil) {
        return nil;
    }
    return [[self reduceWithStartingElement:[@{} mutableCopy] reduceBlock:^id(id accumulator, id object) {
        NSMutableDictionary* currentAccumulator = (NSMutableDictionary*)accumulator;
        NSDictionary* currentDictionary = mapBlock(object);
        if (currentDictionary.count > 0) {
            [currentAccumulator addEntriesFromDictionary:currentDictionary];
        }
        return currentAccumulator;
    }] copy];
}

@end

@implementation NSIndexSet (MapToArray)

- (NSArray*)mapToArray {
    NSMutableArray* m_array = [NSMutableArray array];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [m_array addObject:@(idx)];
    }];
    return [NSArray arrayWithArray:m_array];
}

@end
