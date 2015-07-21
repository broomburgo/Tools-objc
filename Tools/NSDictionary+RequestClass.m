#import "NSDictionary+RequestClass.h"

@implementation NSDictionary (RequestClass)

- (id)objectForKey:(id)key requestedClass:(Class)requestedClass {
    if (key == nil) {
        return nil;
    }
    id object = [self objectForKey:key];
    if (requestedClass == nil) {
        return object;
    }
    if ([object isKindOfClass:requestedClass]) {
        return object;
    }
    else {
        return nil;
    }
}

@end
