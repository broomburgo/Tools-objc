#import <Foundation/Foundation.h>

@interface NSDictionary (Map)

- (NSDictionary*)map:(NSDictionary*(^)(id key, id object))mapBlock;

- (NSArray*)mapToArray:(id(^)(id key, id object))mapBlock sortedUsingComparator:(NSComparisonResult(^)(id object1, id object2))comparator;

@end
