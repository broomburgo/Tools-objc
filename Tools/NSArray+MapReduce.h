#import <Foundation/Foundation.h>

@interface NSArray (MapReduce)

- (id)reduceWithStartingElement:(id)startingElement reduceBlock:(id(^)(id accumulator, id object))reduceBlock;
- (NSArray*)map:(id(^)(id object))mapBlock;
- (NSDictionary*)mapToDictionary:(NSDictionary*(^)(id object))mapBlock;

@end

@interface NSIndexSet (MapToArray)

- (NSArray*)mapToArray;

@end
