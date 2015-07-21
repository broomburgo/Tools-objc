#import <Foundation/Foundation.h>

@interface NSDictionary (RequestClass)

- (id)objectForKey:(id)key requestedClass:(Class)requestedClass;

@end
