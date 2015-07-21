#import "NSArray+Build.h"

@implementation NSArray (Build)

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock {
    if (capacity == 0 ||
        buildBlock == nil) {
        return @[];
    }
    
    NSMutableArray* m_array = [NSMutableArray array];
    for (NSInteger currentIndex = 0; currentIndex < capacity; currentIndex += 1) {
        BOOL prematureEnd = NO;
        id element = buildBlock(currentIndex, &prematureEnd);
        if (element) {
            [m_array addObject:element];
        }
        if (prematureEnd) {
            break;
        }
    }
    
    return [m_array copy];
}

@end
