#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Tools.h"

@interface CategoriesSomething : NSObject

@property (nonatomic, copy) NSString* name;

@end

@implementation CategoriesSomething

- (NSString*)description {
    return self.name;
}

@end

@interface ToolsTests : XCTestCase

@end

@implementation ToolsTests

- (void)testTools {
    CategoriesSomething* something = [CategoriesSomething new];
    something.name = @"something";
    
    NSArray* array1_valid = @[@1,@2,@3];
    NSArray* validatedArray1 = [Tools JSONValidatedArray:array1_valid];
    XCTAssertNotNil(validatedArray1);
    XCTAssertEqualObjects(array1_valid, validatedArray1);
    
    NSArray* array2_notValid = @[@1,something,@3];
    NSArray* validatedArray2 = [Tools JSONValidatedArray:array2_notValid];
    NSArray* validatedArray2Wannabe = @[@1,@"something",@3];
    XCTAssertNotNil(validatedArray2);
    XCTAssertNotEqualObjects(array2_notValid, validatedArray2);
    XCTAssertEqualObjects(validatedArray2, validatedArray2Wannabe);
    
    NSDictionary* dict1_valid = @{@"1": @1, @"2": @2, @"3": @3};
    NSDictionary* validatedDict1 = [Tools JSONValidatedDictionary:dict1_valid];
    XCTAssertNotNil(validatedDict1);
    XCTAssertEqualObjects(dict1_valid, validatedDict1);
    
    NSDictionary* dict2_notValid = @{@"1": @1, @"2": something, @"3": @3};
    NSDictionary* validatedDict2 = [Tools JSONValidatedDictionary:dict2_notValid];
    NSDictionary* validatedDict2Wannabe = @{@"1": @1, @"2": @"something", @"3": @3};
    XCTAssertNotNil(validatedDict2);
    XCTAssertNotEqualObjects(dict2_notValid, validatedDict2);
    XCTAssertEqualObjects(validatedDict2, validatedDict2Wannabe);
}

- (void)testMaybe {
    NSString* someString = @"12345";
    NSArray* someArray = @[@6, @7, @8, @9, @10];
    NSNull* someNSNull = [NSNull null];
    NSDictionary* dictionaryWithNull = @{@"none": someNSNull};
    
    NSUInteger someStringLength = someString.maybe.length;
    XCTAssertEqual(someStringLength, 5);
    
    NSInteger someStringToInteger = someString.maybe.integerValue;
    XCTAssertEqual(someStringToInteger, 12345);
    
    NSDictionary* dictionaryWithArray = @{@"some":someArray};
    NSUInteger someArrayCount = [[dictionaryWithArray[@"some"] maybe] count];
    XCTAssertEqual(someArrayCount, 5);
    
    NSNumber* someArrayThirdElement = [dictionaryWithArray[@"some"] maybe][2];
    XCTAssertEqual(someArrayThirdElement.integerValue, 8);
    
    NSString* fakeString = (NSString*)dictionaryWithNull[@"none"];
    XCTAssertNil(fakeString.maybe);
    XCTAssertEqual(fakeString.maybe.length, 0);
    XCTAssertEqual(fakeString.maybe.integerValue, 0);
    
    NSArray* fakeArray = (NSArray*)dictionaryWithNull[@"none"];
    XCTAssertEqual(fakeArray.maybe.count, 0);
    XCTAssertNil(fakeArray.maybe[2]);
    
    CategoriesSomething* something = [CategoriesSomething new];
    something.name = @"awesome something";
    XCTAssert([something.maybe.name isEqualToString:@"awesome something"]);
    
    NSDictionary* dictionaryWithMock = @{@"some":something};
    CategoriesSomething* maybeMock = (CategoriesSomething*)dictionaryWithMock[@"some"];
    XCTAssert([maybeMock.maybe.name isEqualToString:@"awesome something"]);
}

- (void)testNSArrayMapReduce {
    NSArray* array1 = @[@1,@2,@3];
    NSArray* array2 = [array1 map:^id(id object) {
        return @([object integerValue]*2);
    }];
    NSArray* array2Wannabe = @[@2,@4,@6];
    XCTAssert([array2 isEqualToArray:array2Wannabe]);
    
    NSArray* array3 = nil;
    NSArray* array4 = [array3 map:^id(id object) {
        return @([object integerValue]*2);
    }];
    XCTAssertNil(array4);
    
    NSArray* array3_1 = @[@1,@2,@3];
    NSArray* array3_2 = [array3_1 map:^id(id object) {
        if ([object isKindOfClass:[NSString class]]) {
            return object;
        }
        else {
            return nil;
        }
    }];
    XCTAssert([array3_2 isEqualToArray:@[]]);
    
    NSArray* array5 = @[@"1",@1];
    NSArray* array6 = [array5 map:^id(id object) {
        if ([object isKindOfClass:[NSString class]]) {
            return @([object integerValue]);
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", object];
        }
        else {
            return nil;
        }
    }];
    NSArray* array6Wannabe = @[@1,@"1"];
    XCTAssert([array6 isEqualToArray:array6Wannabe]);
    
    NSArray* array7 = @[@1, @2, @3];
    NSDictionary* dictionary7 = [array7 mapToDictionary:^NSDictionary *(id object) {
        return @{[NSString stringWithFormat:@"key%@", object] : object};
    }];
    NSDictionary* dictionary7Wannabe = @{@"key1" : @1, @"key2" : @2, @"key3" : @3};
    XCTAssert([dictionary7 isEqualToDictionary:dictionary7Wannabe]);
    
    NSArray* array8 = @[@1, @2, @3, @4];
    NSDictionary* dictionary8 = [array8 mapToDictionary:^NSDictionary *(id object) {
        if ([object integerValue]%2 == 0) {
            return @{[NSString stringWithFormat:@"key%@", object] : object};
        }
        else {
            return nil;
        }
    }];
    NSDictionary* dictionary8Wannabe = @{@"key2" : @2, @"key4" : @4};
    XCTAssert([dictionary8 isEqualToDictionary:dictionary8Wannabe]);
    
    
    NSArray* array9 = @[@1,@2,@3,@"4",@(2+3)];
    NSNumber* array9Sum = [array9 reduceWithStartingElement:@0 reduceBlock:^id(id accumulator, id object) {
        return @([accumulator integerValue] + [object integerValue]);
    }];
    XCTAssert([array9Sum integerValue] == 15);
    
    NSNumber* number1 = [@[] reduceWithStartingElement:@3 reduceBlock:^id(id accumulator, id object) {
        return @([accumulator integerValue] + [object integerValue]);
    }];
    XCTAssert([number1 isKindOfClass:[NSNumber class]]);
    XCTAssert([number1 isEqualToNumber:@3]);
    
    NSNumber* number2 = [@[@2,@3,@4] reduceWithStartingElement:@1 reduceBlock:nil];
    XCTAssert([number2 isKindOfClass:[NSNumber class]]);
    XCTAssert([number2 isEqualToNumber:@1]);
}

- (void)testNSDictionaryMap {
    NSDictionary* dictionary1 = @{@"1":@11,
                                  @"2":@12};
    NSDictionary* dictionary2 = [dictionary1 map:^NSDictionary *(id key, id object) {
        return @{[NSString stringWithFormat:@"1%@", key]:@([object integerValue]+10)};
    }];
    NSDictionary* dictionary2Wannabe = @{@"11":@21,
                                         @"12":@22};
    XCTAssert([dictionary2 isEqualToDictionary:dictionary2Wannabe]);
    
    NSDictionary* dictionary3 = nil;
    NSDictionary* dictionary4 = [dictionary3 map:^NSDictionary *(id key, id object) {
        return nil;
    }];
    XCTAssertNil(dictionary4);
    
    NSDictionary* dictionary5 = @{@1:@1,@2:@2,@3:@3};
    NSDictionary* dictionary6 = [dictionary5 map:^NSDictionary *(id key, id object) {
        if ([object isKindOfClass:[NSString class]]) {
            return @{key:object};
        }
        else {
            return nil;
        }
    }];
    XCTAssert([dictionary6 isEqualToDictionary:@{}]);
    
    NSDictionary* dictionary7 = @{@1:@"1",@"2":@2,@"3":@3,@4:@"4"};
    NSArray* array1 = [dictionary7 mapToArray:^id(id key, id object) {
        if ([key isKindOfClass:[NSNumber class]]) {
            return key;
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            return object;
        }
        else {
            return nil;
        }
    } sortedUsingComparator:^NSComparisonResult(id object1, id object2) {
        return [object1 compare:object2];
    }];
    NSArray* array1Wannabe = @[@1,@2,@3,@4];
    XCTAssert([array1 isEqualToArray:array1Wannabe]);
}

- (void)testNSDictionaryRequestClass {
    NSDictionary* dictionary = @{@1:@"a",
                                 @2:@10,
                                 @3:@[@1,@2,@3],
                                 @4:@{@"1":@1,@"2":@2},
                                 @5:[NSNull null]};
    NSString* a = [dictionary objectForKey:@1 as:[NSString class]];
    XCTAssert([a isKindOfClass:[NSString class]]);
    XCTAssert([a isEqualToString:@"a"]);
    
    XCTAssertNil([dictionary objectForKey:@1 as:[NSNumber class]]);
    XCTAssertNil([dictionary objectForKey:@2 as:[NSString class]]);
    
    NSArray* array = [dictionary objectForKey:@3 as:[NSArray class]];
    XCTAssert(array.count == 3);
    
    XCTAssertNil([dictionary objectForKey:@4 as:[NSArray class]]);
    XCTAssertNil([dictionary objectForKey:@5 as:[NSDictionary class]]);
}

- (void)testNSDictionaryOptionals {
    NSDictionary* dict = [[[[[[@{}
                              key:@"a" optional:@1]
                             key:@"b" optional:nil]
                            key:nil optional:@3]
                           key:@"d" optional:@4]
                          key:nil optional:nil]
                          optionalDict:[[[[[[@{} mutableCopy]
                                            key:@"f" optional:nil]
                                           key:nil optional:@7]
                                          key:@"h" optional:@8]
                                         key:@"i" optional:nil]
                                        key:nil optional:@10]];
    XCTAssert([dict isKindOfClass:[NSDictionary class]]);
    XCTAssert(dict.count == 3);
    XCTAssert([dict[@"a"] isEqual:@1]);
    XCTAssert(dict[@"b"] == nil);
    XCTAssert(dict[@"c"] == nil);
    XCTAssert([dict[@"d"] isEqual:@4]);
    XCTAssert(dict[@"e"] == nil);
    XCTAssert(dict[@"f"] == nil);
    XCTAssert(dict[@"g"] == nil);
    XCTAssert([dict[@"h"] isEqual:@8]);
    XCTAssert(dict[@"i"] == nil);
    XCTAssert(dict[@"j"] == nil);
    
    NSMutableDictionary* m_dict = [[[[[[[@{} mutableCopy]
                                       key:@"a" optional:nil]
                                      key:@"b" optional:@2]
                                     key:@"c" optional:@3]
                                    key:nil optional:@4]
                                   key:nil optional: nil]
                                   optionalDict:[[[[[@{}
                                                     key:@"f" optional:@6]
                                                    key:@"g" optional:nil]
                                                   key:nil optional:@8]
                                                  key:@"i" optional:@9]
                                                 key:nil optional:nil]];
    XCTAssert([m_dict isKindOfClass:[NSMutableDictionary class]]);
    XCTAssert(m_dict.count == 4);
    XCTAssert(m_dict[@"a"] == nil);
    XCTAssert([m_dict[@"b"] isEqual:@2]);
    XCTAssert([m_dict[@"c"] isEqual:@3]);
    XCTAssert(m_dict[@"d"] == nil);
    XCTAssert(m_dict[@"e"] == nil);
    XCTAssert([m_dict[@"f"] isEqual:@6]);
    XCTAssert(m_dict[@"g"] == nil);
    XCTAssert(m_dict[@"h"] == nil);
    XCTAssert([m_dict[@"i"] isEqual:@9]);
    XCTAssert(m_dict[@"j"] == nil);
}

- (void)testNSArrayOptionals {
    NSArray* array = [[[[[[@[]
                           optional:@1]
                          optional:nil]
                         optional:@3]
                        optional:@4]
                       optional:nil]
                      optionalArray:[[[[@[] mutableCopy]
                                       optional:@6]
                                      optional:nil]
                                     optional:@8]];
    XCTAssert([array isKindOfClass:[NSArray class]]);
    XCTAssert(array.count == 5);
    XCTAssert([array[0] isEqual:@1]);
    XCTAssert([array[1] isEqual:@3]);
    XCTAssert([array[2] isEqual:@4]);
    XCTAssert([array[3] isEqual:@6]);
    XCTAssert([array[4] isEqual:@8]);
    
    NSMutableArray* m_array = [[[[[[[@[] mutableCopy]
                                    optional:nil]
                                   optional:@2]
                                  optional:nil]
                                 optional:@4]
                                optional: nil]
                               optionalArray:[[[@[]
                                                optional:nil]
                                               optional:nil]
                                              optional:@8]];
    XCTAssert([m_array isKindOfClass:[NSMutableArray class]]);
    XCTAssert(m_array.count == 3);
    XCTAssert([m_array[0] isEqual:@2]);
    XCTAssert([m_array[1] isEqual:@4]);
    XCTAssert([m_array[2] isEqual:@8]);
}

- (void)testNSArrayBuild {
    NSUInteger numberOfElements = 5;
    
    NSArray* builtArray1 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger currentIndex, BOOL *prematureEnd) {
        return @(currentIndex);
    }];
    XCTAssert(builtArray1.count == numberOfElements);
    
    NSArray* builtArray1Wannabe = @[@(0),@1,@2,@3,@4];
    XCTAssert([builtArray1 isEqualToArray:builtArray1Wannabe]);
    
    NSUInteger maxCapacity = 3;
    NSArray* builtArray2 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger index, BOOL *prematureEnd) {
        if (index >= maxCapacity -1) {
            *prematureEnd = YES;
        }
        return @(index);
    }];
    XCTAssert(builtArray2.count == maxCapacity);
    
    NSArray* builtArray2Wannabe = @[@(0),@1,@2];
    XCTAssert([builtArray2 isEqualToArray:builtArray2Wannabe]);
    
    NSUInteger bannedIndex = 2;
    NSArray* builtArray3 = [NSArray arrayWithCapacity:numberOfElements buildBlock:^id(NSUInteger currentIndex, BOOL *prematureEnd) {
        if (currentIndex != bannedIndex) {
            return @(currentIndex);
        }
        else {
            return nil;
        }
    }];
    XCTAssert(builtArray3.count == numberOfElements -1);
    
    NSArray* builtArray3Wannabe = @[@(0),@1,@3,@4];
    XCTAssert([builtArray3 isEqualToArray:builtArray3Wannabe]);
}

- (void)testNSIndexSetToArray {
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    XCTAssert(indexSet.firstIndex == 0);
    XCTAssert(indexSet.lastIndex == 4);
    XCTAssert(indexSet.count == 5);
    NSArray* indexArray = [indexSet mapToArray];
    XCTAssert([indexArray.firstObject isKindOfClass:[NSNumber class]]);
    XCTAssert([indexArray.firstObject isEqualToNumber:@0]);
    XCTAssert([indexArray.lastObject isKindOfClass:[NSNumber class]]);
    XCTAssert([indexArray.lastObject isEqualToNumber:@4]);
    XCTAssert(indexArray.count == 5);
}

@end
