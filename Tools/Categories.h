#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VariadicBlock : NSObject

- (VariadicBlock*)with0Arg:(void(^)())argBlock;
- (VariadicBlock*)with1Arg:(void(^)(id))argBlock;
- (VariadicBlock*)with2Arg:(void(^)(id,id))argBlock;
- (VariadicBlock*)with3Arg:(void(^)(id,id,id))argBlock;
- (VariadicBlock*)with4Arg:(void(^)(id,id,id,id))argBlock;
- (VariadicBlock*)with5Arg:(void(^)(id,id,id,id,id))argBlock;
- (VariadicBlock*)with6Arg:(void(^)(id,id,id,id,id,id))argBlock;
- (VariadicBlock*)with7Arg:(void(^)(id,id,id,id,id,id,id))argBlock;
- (VariadicBlock*)with8Arg:(void(^)(id,id,id,id,id,id,id,id))argBlock;
- (VariadicBlock*)with9Arg:(void(^)(id,id,id,id,id,id,id,id,id))argBlock;
- (VariadicBlock*)with10Arg:(void(^)(id,id,id,id,id,id,id,id,id,id))argBlock;

@end

@interface NSArray (Tools)

@property (nonatomic, readonly, nullable) id head;
@property (nonatomic, readonly, nullable) NSArray* tail;

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity
                   buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock;

- (id _Nullable)reduceWithStartingElement:(id _Nullable)startingElement
                              reduceBlock:(id(^ _Nullable)(id accumulator, id object))reduceBlock;
- (NSArray*)map:(id(^)(id object))mapBlock;
- (NSArray*)mapNullable:(id _Nullable(^)(id object))mapBlock;
- (NSArray*)filter:(BOOL(^)(id object))filterBlock;
- (id _Nullable)find:(BOOL(^)(id object))findBlock;
- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock;

- (void)forEach:(void(^)(id object))forEachBlock;
- (void)recursive:(NSArray* _Nullable(^)(id object))recursiveBlock
          forEach:(VariadicBlock*)forEachBlock;

- (instancetype)optional:(id _Nullable)optional;
- (instancetype)optionalArray:(NSArray* _Nullable)optionalArray;

- (NSArray*)select:(NSUInteger)numberOfElements;
- (NSArray*)selectBut:(NSUInteger)numberOfElementsToExclude;

@end

@interface NSDictionary (Tools)

- (NSDictionary*)append:(NSDictionary*)otherDictionary;

- (id _Nullable)reduceWithStartingElement:(id _Nullable)startingElement
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

- (instancetype)setup:(void(^)(id value))setupBlock;

@end

@interface NSNumber (Tools)

- (id _Nullable)ifTrue:(id _Nullable(^)())ifTrueBlock
               ifFalse:(id _Nullable(^)())ifFalseBlock;

@end

NS_ASSUME_NONNULL_END
