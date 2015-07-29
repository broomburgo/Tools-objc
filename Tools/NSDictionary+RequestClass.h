#import <Foundation/Foundation.h>

@interface NSDictionary (RequestClass)

- (id)objectForKey:(id)key as:(Class)requestedClass;

@end
