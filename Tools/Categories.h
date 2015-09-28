#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Tools)

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity
                   buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock;

- (id)reduceWithStartingElement:(id)startingElement
                    reduceBlock:(id(^ _Nullable)(id accumulator, id object))reduceBlock;
- (NSArray*)map:(id(^)(id object))mapBlock;
- (NSArray*)filter:(BOOL(^)(id object))filterBlock;
- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock;

- (instancetype)optional:(id _Nullable)optional;
- (instancetype)optionalArray:(NSArray* _Nullable)optionalArray;

@end

@interface NSDictionary (Tools)

- (NSDictionary*)append:(NSDictionary*)otherDictionary;

- (id)reduceWithStartingElement:(id)startingElement
                    reduceBlock:(id(^ _Nullable)(id accumulator, id key, id object))reduceBlock;

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock;
- (NSDictionary*)filter:(BOOL(^)(id key, id object))filterBlock;
- (NSDictionary*)mergeWith:(NSDictionary*)otherDictionary;

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock
            sortedWith:(NSComparisonResult(^ _Nullable)(id object1, id object2))comparator;

- (instancetype)key:(id<NSCopying> _Nullable)key optional:(id _Nullable)optional;
- (instancetype)optionalDict:(NSDictionary* _Nullable)optionalDict;

- (id)objectForKey:(id)key
                as:(Class)requiredClass;

@end

@interface NSSet (Tools)

- (NSSet*)filter:(BOOL(^)(id object))filterBlock;

@end

@interface NSIndexSet (Tools)

- (NSArray*)mapToArray;

@end

@interface NSObject (Tools)

@property (readonly) id maybe;
- (instancetype)maybe;

- (instancetype)setup:(id(^)(id value))setupBlock;

@end

NS_ASSUME_NONNULL_END
