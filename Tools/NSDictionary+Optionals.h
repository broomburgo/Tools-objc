#import <Foundation/Foundation.h>

@interface NSDictionary (Optionals)

- (instancetype)key:(id<NSCopying>)key optional:(id)optional;
- (instancetype)optionalDict:(NSDictionary*)optionalDict;

@end
