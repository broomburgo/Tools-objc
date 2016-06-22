#import "Pair.h"

@interface Pair ()

@property (copy, nonatomic) id<NSObject,NSCopying,NSCoding> object1;
@property (copy, nonatomic) id<NSObject,NSCopying,NSCoding> object2;

@end

@implementation Pair

+ (instancetype):(id<NSObject,NSCopying,NSCoding>)object1 :(id<NSObject,NSCopying,NSCoding>)object2 {
	Pair* pair = [[self class] new];
	pair.object1 = object1;
	pair.object2 = object2;
	return pair;
}

- (BOOL)isEqual:(Pair*)other {
	return [self.object1 isEqual:other.object1] && [self.object2 isEqual:other.object2];
}

- (id)copyWithZone:(NSZone *)zone {
	return [[self class] :self.object1 :self.object2];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	_object1 = [aDecoder decodeObjectForKey:@"object1"];
	_object2 = [aDecoder decodeObjectForKey:@"object2"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.object1 forKey:@"object1"];
	[aCoder encodeObject:self.object2 forKey:@"object2"];
}

@end
