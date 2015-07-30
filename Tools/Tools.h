#import <Foundation/Foundation.h>

#import "NSArray+Build.h"
#import "NSArray+MapReduce.h"
#import "NSArray+Optionals.h"
#import "NSDictionary+Map.h"
#import "NSDictionary+Optionals.h"
#import "NSDictionary+RequestClass.h"
#import "NSObject+Maybe.h"

#import "Queue.h"

@interface Tools : NSObject

///MARK: JSON validation

+ (NSArray* __nonnull)JSONValidatedArray:(NSArray* __nonnull)array;
+ (NSDictionary* __nonnull)JSONValidatedDictionary:(NSDictionary* __nonnull)dictionary;

@end
