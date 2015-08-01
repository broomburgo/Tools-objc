#import <Foundation/Foundation.h>

@interface NSDictionary (Map)

- (NSDictionary*)append:(NSDictionary*)otherDictionary;

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id key, id object))reduceBlock;

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock;
- (NSDictionary*)filter:(BOOL(^)(id key, id object))filterBlock;
- (NSDictionary*)mergeWith:(NSDictionary*)otherDictionary;

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedUsingComparator:(NSComparisonResult(^)(id object1, id object2))comparator;

@end
