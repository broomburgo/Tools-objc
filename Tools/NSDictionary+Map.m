#import "NSDictionary+Map.h"

@implementation NSDictionary (Map)

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock {
    if (self.count < 1) {
        return self;
    }
    if (mapBlock) {
        NSMutableDictionary* m_mappedDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
        [self enumerateKeysAndObjectsUsingBlock:^(id currentKey, id currentObject, BOOL *stop) {
            NSDictionary* outputDictionary = mapBlock(currentKey, currentObject);
            if (outputDictionary) {
                [m_mappedDictionary addEntriesFromDictionary:outputDictionary];
            }
        }];
        return [NSDictionary dictionaryWithDictionary:m_mappedDictionary];
    }
    else {
        return self;
    }
}

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedUsingComparator:(NSComparisonResult(^)(id object1, id object2))comparator {
    if (self.count < 1) {
        return nil;
    }
    if (mapBlock) {
        NSMutableArray* m_mappedArray = [NSMutableArray arrayWithCapacity:self.count];
        [self enumerateKeysAndObjectsUsingBlock:^(id currentKey, id currentObject, BOOL *stop) {
            id object = mapBlock(currentKey, currentObject);
            if (object) {
                [m_mappedArray addObject:object];
            }
        }];
        NSArray* mappedArray = [NSArray arrayWithArray:m_mappedArray];
        if (comparator) {
            mappedArray = [mappedArray sortedArrayUsingComparator:comparator];
        }
        return mappedArray;
    }
    else {
        return nil;
    }
}

@end
