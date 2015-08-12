#import <Foundation/Foundation.h>

@interface NSArray (Tools)

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock;

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id object))reduceBlock;
- (NSArray*)map:(id(^)(id object))mapBlock;
- (NSArray*)filter:(BOOL(^)(id object))filterBlock;
- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock;

- (instancetype)optional:(id)optional;
- (instancetype)optionalArray:(NSArray*)optionalArray;

@end

@interface NSDictionary (Tools)

- (NSDictionary*)append:(NSDictionary*)otherDictionary;

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id key, id object))reduceBlock;

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock;
- (NSDictionary*)filter:(BOOL(^)(id key, id object))filterBlock;
- (NSDictionary*)mergeWith:(NSDictionary*)otherDictionary;

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedUsingComparator:(NSComparisonResult(^)(id object1, id object2))comparator;

- (instancetype)key:(id<NSCopying>)key optional:(id)optional;
- (instancetype)optionalDict:(NSDictionary*)optionalDict;

- (id)objectForKey:(id)key as:(Class)requiredClass;

@end

@interface NSSet (Tools)

- (NSSet*)filter:(BOOL(^)(id object))filterBlock;

@end

@interface NSIndexSet (Tools)

- (NSArray*)mapToArray;

@end

@interface NSObject (Maybe)

@property (readonly) id maybe;
- (instancetype)maybe;

@end