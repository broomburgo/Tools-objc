#import <Foundation/Foundation.h>

@interface NSArray (MapReduce)

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id object))reduceBlock;
- (NSArray*)map:(id(^)(id object))mapBlock;
- (NSArray*)filter:(BOOL(^)(id object))filterBlock;
- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock;

@end

@interface NSIndexSet (MapToArray)

- (NSArray*)mapToArray;

@end

@interface NSSet (Filter)

- (NSSet*)filter:(BOOL(^)(id object))filterBlock;

@end
