#import "Pair.h"

@interface Pair ()

@property (copy, nonatomic) id<NSCopying> object1;
@property (copy, nonatomic) id<NSCopying> object2;

@end

@implementation Pair

+ (instancetype)withObject1:(id<NSCopying>)object1 object2:(id<NSCopying>)object2 {
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

@end
