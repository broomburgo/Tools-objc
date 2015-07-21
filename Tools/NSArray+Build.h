#import <Foundation/Foundation.h>

@interface NSArray (Build)

+ (NSArray*)arrayWithCapacity:(NSUInteger)capacity buildBlock:(id(^)(NSUInteger currentIndex, BOOL* prematureEnd))buildBlock;

@end
