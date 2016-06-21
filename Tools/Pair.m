#import "Pair.h"

@interface Pair ()

@property (copy, nonatomic) id<NSCopying, NSCoding> object1;
@property (copy, nonatomic) id<NSCopying, NSCoding> object2;

@end

@implementation Pair

+ (instancetype)withObject1:(id<NSCopying, NSCoding>)object1
					object2:(id<NSCopying, NSCoding>)object2 {
	Pair* pair = [[self class] new];
	pair.object1 = object1;
	pair.object2 = object2;
	return pair;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[self class]
			withObject1:self.object1
			object2:self.object2];
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
