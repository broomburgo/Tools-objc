#import "NSArray+Build.h"
#import "NSArray+MapReduce.h"
#import "NSArray+Optionals.h"
#import "NSDictionary+Map.h"
#import "NSDictionary+Optionals.h"
#import "NSDictionary+RequestClass.h"
#import "NSObject+Maybe.h"

@interface Tools : NSObject

///MARK: JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array;
+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary;

@end
