#import "Pair.h"

@interface Pair ()

@property (copy, nonatomic) id<NSCopying> object1;
@property (copy, nonatomic) id<NSCopying> object2;

@end

@implementation Pair

+ (Pair *)withObject1:(id<NSCopying>)object1 object2:(id<NSCopying>)object2 {
	Pair* pair = [Pair new];
	pair.object1 = object1;
	pair.object2 = object2;
	return pair;
}

- (id)copyWithZone:(NSZone *)zone {
	return [Pair
			withObject1:self.object1
			object2:self.object2];
}

@end
