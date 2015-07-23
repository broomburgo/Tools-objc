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
    NSMutableArray* m_reduced = [self reduceWithStartingElement:[@[] mutableCopy] reduceBlock:^id(id accumulator, id object) {
        NSMutableArray* currentAccumulator = (NSMutableArray*)accumulator;
        id currentObject = mapBlock(object);
        if (currentObject) {
            [currentAccumulator addObject:currentObject];
        }
        return currentAccumulator;
    }];
    return [NSArray arrayWithArray:m_reduced];
}

- (NSArray*)filter:(BOOL(^)(id object))filterBlock {
    NSMutableArray* m_reduced = [self reduceWithStartingElement:[@[] mutableCopy] reduceBlock:^id(id accumulator, id object) {
        NSMutableArray* currentAccumulator = (NSMutableArray*)accumulator;
        if (filterBlock(object)) {
            [currentAccumulator addObject:object];
        }
        return currentAccumulator;
    }];
    return [NSArray arrayWithArray:m_reduced];
}

- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock {
    if (mapBlock == nil) {
        return nil;
    }
    NSMutableDictionary* m_reduced = [self reduceWithStartingElement:[@{} mutableCopy] reduceBlock:^id(id accumulator, id object) {
        NSMutableDictionary* currentAccumulator = (NSMutableDictionary*)accumulator;
        NSDictionary* currentDictionary = mapBlock(object);
        if (currentDictionary.count > 0) {
            [currentAccumulator addEntriesFromDictionary:currentDictionary];
        }
        return currentAccumulator;
    }];
    return [NSDictionary dictionaryWithDictionary:m_reduced];
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

@implementation NSSet (Filter)

- (NSSet*)filter:(BOOL(^)(id object))filterBlock {
    NSMutableSet* m_set = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (filterBlock(obj)) {
            [m_set addObject:obj];
        }
    }];
    return [NSSet setWithSet:m_set];
}

@end
