#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Tools.h"
#import "Result_Internal.h"
#import "Future_Internal.h"

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

- (void)testNSDictionaryMapReduce {
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
    
    NSDictionary* dict8 = @{
                                  @"1":@1,
                                  @"2":@{
                                          @"1":@1,
                                          @"2":@2
                                          },
                                  @"3":@3,
                                  @"4":@{
                                          @"1":@1,
                                          @"2":@{
                                                  @"1":@1,
                                                  @"2":@2,
                                                  @"3":@3
                                                  }
                                          },
                                  @"6":@[@1,@2]
                                  };
    NSDictionary* otherDict8 = @{
                                       @"1":@10,
                                       @"2":@{
                                               @"2":@20,
                                               @"3":@30
                                               },
                                       @"4":@{
                                               @"2":@{
                                                       @"1":@10,
                                                       @"3":@3,
                                                       @"4":@{
                                                               @"1":@10
                                                               }
                                                       }
                                               },
                                       @"5":@5,
                                       @"6":@[@3,@"4"]
                                       };
    NSDictionary* expectedDict8 = @{
                                          @"1":@10,
                                          @"2":@{
                                                  @"1":@1,
                                                  @"2":@20,
                                                  @"3":@30
                                                  },
                                          @"3":@3,
                                          @"4":@{
                                                  @"1":@1,
                                                  @"2":@{
                                                          @"1":@10,
                                                          @"2":@2,
                                                          @"3":@3,
                                                          @"4":@{
                                                                  @"1":@10
                                                                  }
                                                          }
                                                  },
                                          @"5":@5,
                                          @"6":@[@1,@2,@3,@"4"]
                                          };
    NSDictionary* mergedDict8 = [dict8 mergeWith:otherDict8];
    XCTAssertNotNil(mergedDict8);
    XCTAssertNotEqual(mergedDict8.count, 0);
    XCTAssertEqualObjects(mergedDict8, expectedDict8);
    
    NSDictionary* dict9 = @{@"1":@"a",@"2":@"b",@"3":@3};
    NSString* reducedString9 = [[dict9 reduceWithStartingElement:[@"" mutableCopy] reduceBlock:^NSMutableString*(NSMutableString* m_accumulator, id key, id object) {
        [m_accumulator appendFormat:@"|key: %@, object: %@|", key, object];
        return m_accumulator;
    }] copy];
    XCTAssertNotNil(reducedString9);
    XCTAssertNotEqual(reducedString9.length, 0);
    NSString* expectedString9 = @"|key: 1, object: a||key: 2, object: b||key: 3, object: 3|";
    XCTAssertEqualObjects(reducedString9, expectedString9);
    
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
                           key:@"d" optional:@"4"]
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
    XCTAssert([dict[@"d"] isEqual:@"4"]);
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
                                                  key:@"i" optional:@"9"]
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
    XCTAssert([m_dict[@"i"] isEqual:@"9"]);
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

- (void)testRandomization {
    NSString* randomString1 = [Tools randomString];
    XCTAssertNotNil(randomString1);
    XCTAssertNotEqual(randomString1.length, 0);
    
    NSUInteger randomStringLength = 10;
    
    NSString* randomString2 = [Tools randomStringWithLength:randomStringLength];
    XCTAssertNotNil(randomString2);
    XCTAssertEqual(randomString2.length, randomStringLength);
    
    NSString* randomString3 = [Tools randomStringWithLength:randomStringLength];
    XCTAssertNotNil(randomString3);
    XCTAssertEqual(randomString3.length, randomStringLength);

    XCTAssertNotEqualObjects(randomString2, randomString3);
    
    NSString* noDigitsString = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableArray* m_noDigitsArray = [@[] mutableCopy];
    [noDigitsString enumerateSubstringsInRange:NSMakeRange(0, noDigitsString.length)
                                      options:NSStringEnumerationByComposedCharacterSequences
                                   usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                       [m_noDigitsArray addObject:substring];
                                   }];
    NSSet* noDigitsSet = [NSSet setWithArray:m_noDigitsArray];
    XCTAssertNotNil(noDigitsSet);
    XCTAssertEqual(noDigitsSet.count, noDigitsString.length);
    
    NSString* randomDigitsOnlyString = [Tools randomStringDigitsOnlyWithLength:randomStringLength];
    XCTAssertNotNil(randomDigitsOnlyString);
    XCTAssertEqual(randomDigitsOnlyString.length, randomStringLength);
    
    NSMutableArray* m_randomDigitsOnlyArray = [@[] mutableCopy];
    [randomDigitsOnlyString enumerateSubstringsInRange:NSMakeRange(0, randomDigitsOnlyString.length)
                                                options:NSStringEnumerationByComposedCharacterSequences
                                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                 [m_randomDigitsOnlyArray addObject:substring];
                                             }];
    NSSet* randomDigitsOnlySet = [NSSet setWithArray:m_randomDigitsOnlyArray];
    XCTAssertNotNil(randomDigitsOnlySet);
    XCTAssert(randomDigitsOnlySet.count > 0);
    
    XCTAssert([noDigitsSet intersectsSet:randomDigitsOnlySet] == NO);
}

- (void)testFuture {
    Future* future1 = [Future new];
    XCTAssertNil(future1.value);
    XCTAssertNil(future1.error);
    XCTAssertEqual(future1.state, FutureStateIncomplete);
    XCTestExpectation* success1 = [self expectationWithDescription:@"success1"];
    NSString* expectedValue1 = @"expectedValue1";
    [future1 onSuccess:^(NSString* __nonnull value) {
        [success1 fulfill];
        XCTAssertEqualObjects(value, expectedValue1);
    }];
    [future1 onFailure:^(NSError * __nonnull error) {
        XCTAssert(NO);
    }];
    [future1 succeedWith:expectedValue1];
    XCTAssertEqual(future1.state, FutureStateSucceeded);
    XCTAssertNotNil(future1.value);
    XCTAssertNil(future1.error);
    XCTAssertEqualObjects(future1.value, expectedValue1);
    
    Future* future2 = [Future new];
    XCTAssertEqual(future2.state, FutureStateIncomplete);
    XCTAssertNil(future2.value);
    XCTAssertNil(future2.error);
    XCTestExpectation* failure1 = [self expectationWithDescription:@"failure1"];
    NSString* expectedValue2 = @"expectedValue2";
    NSError* expectedError2 = [NSError errorWithDomain:expectedValue2 code:0 userInfo:nil];
    [future2 onSuccess:^(NSString* __nonnull value) {
        XCTAssert(NO);
    }];
    [future2 onFailure:^(NSError * __nonnull error) {
        [failure1 fulfill];
        XCTAssertEqualObjects(error.domain, expectedValue2);
    }];
    [future2 failWith:expectedError2];
    XCTAssertEqual(future2.state, FutureStateFailed);
    XCTAssertNil(future2.value);
    XCTAssertNotNil(future2.error);
    XCTAssertEqualObjects(((NSError*)future2.error).domain, expectedError2.domain);

    Future* future3 = [Future new];
    XCTAssertNil(future3.value);
    XCTAssertNil(future3.error);
    XCTAssertEqual(future3.state, FutureStateIncomplete);
    XCTestExpectation* success3_1 = [self expectationWithDescription:@"success3_1"];
    XCTestExpectation* success3_2 = [self expectationWithDescription:@"success3_2"];
    XCTestExpectation* success3_3 = [self expectationWithDescription:@"success3_3"];
    NSString* expectedValue3 = @"expectedValue3";
    [future3 onSuccess:^(NSString* __nonnull value) {
        [success3_1 fulfill];
        XCTAssertEqualObjects(value, expectedValue3);
    }];
    [future3 onSuccess:^(NSString* __nonnull value) {
        [success3_2 fulfill];
        XCTAssertEqualObjects(value, expectedValue3);
    }];
    [future3 onFailure:^(NSError * __nonnull error) {
        XCTAssert(NO);
    }];
    [future3 succeedWith:expectedValue3];
    XCTAssertEqual(future3.state, FutureStateSucceeded);
    XCTAssertNotNil(future3.value);
    XCTAssertNil(future3.error);
    XCTAssertEqualObjects(future3.value, expectedValue3);
    [future3 onSuccess:^(NSString* __nonnull value) {
        [success3_3 fulfill];
        XCTAssertEqualObjects(value, expectedValue3);
    }];

    Future* future4 = [Future new];
    XCTAssertNil(future4.value);
    XCTAssertNil(future4.error);
    XCTAssertEqual(future4.state, FutureStateIncomplete);
    XCTestExpectation* success4_1 = [self expectationWithDescription:@"success4_1"];
    XCTestExpectation* success4_2 = [self expectationWithDescription:@"success4_2"];
    XCTestExpectation* failure4_3 = [self expectationWithDescription:@"success4_2"];
    NSString* expectedValue4 = @"expectedValue4";
    NSError* expectedError4 = [NSError errorWithDomain:expectedValue4 code:0 userInfo:nil];
    [future4 onSuccess:^(NSString* __nonnull value) {
        [success4_1 fulfill];
        XCTAssertEqualObjects(value, expectedValue4);
    }];
    [future4 onFailure:^(NSError * __nonnull error) {
        XCTAssert(NO);
    }];
    
    Future* future5 = [[[future4
                         flatMap:^Future * __nonnull(id __nonnull value) {
                             [success4_2 fulfill];
                             XCTAssertEqualObjects(value, expectedValue4);
                             Future* newFuture = [Future new];
                             [newFuture succeedWith:value];
                             return newFuture;
                         }]
                        flatMap:^Future * __nonnull(id __nonnull value) {
                            [failure4_3 fulfill];
                            XCTAssertEqualObjects(value, expectedValue4);
                            Future* newFuture = [Future new];
                            [newFuture failWith:expectedError4];
                            return newFuture;
                        }]
                       flatMap:^Future * __nonnull(id __nonnull value) {
                           XCTAssert(NO);
                           return [Future new];
                       }];
    [future4 succeedWith:expectedValue4];
    XCTAssertEqual(future4.state, FutureStateSucceeded);
    XCTAssertNotNil(future4.value);
    XCTAssertNil(future4.error);
    XCTAssertEqualObjects(future4.value, expectedValue4);
    
    XCTestExpectation* wait = [self expectationWithDescription:@"wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wait fulfill];
        XCTAssertEqual(future5.state, FutureStateFailed);
        XCTAssertNil(future5.value);
        XCTAssertNotNil(future5.error);
        XCTAssertEqualObjects(((NSError*)future5.error).domain, expectedError4.domain);
    });
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOptionalNoneSome {
    Optional* some = [Optional with:@[]];
    Optional* none = [Optional with:nil];
    XCTAssertEqual(some.type, OptionalTypeSome);
    XCTAssertNotNil(some.value);
    XCTAssert([some.value isKindOfClass:[NSArray class]]);
    XCTAssertEqual(none.type, OptionalTypeNone);
    XCTAssertNil(none.value);
    
    Optional* someAs = [Optional with:@2 as:[NSNumber class]];
    Optional* noneAs = [Optional with:@"2" as:[NSArray class]];
    XCTAssertEqual(someAs.type, OptionalTypeSome);
    XCTAssertNotNil(someAs.value);
    XCTAssert([someAs.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([someAs.value integerValue], 2);
    XCTAssertEqual(noneAs.type, OptionalTypeNone);
    XCTAssertNil(noneAs.value);
    
    Optional* someWhen = [Optional with:@3 when:^BOOL(NSNumber* __nonnull number) {
        return number.integerValue == 3;
    }];
    Optional* noneWhen = [Optional with:@"4" when:^BOOL(NSString* __nonnull string) {
        return [string isEqualToString:@"3"];
    }];
    XCTAssertEqual(someWhen.type, OptionalTypeSome);
    XCTAssertNotNil(someWhen.value);
    XCTAssert([someWhen.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([someWhen.value integerValue], 3);
    XCTAssertEqual(noneWhen.type, OptionalTypeNone);
    XCTAssertNil(noneWhen.value);
}

- (void)testOptionalMap {
    Optional* someNumber = [Optional with:@10];
    Optional* noneNumber = [Optional with:nil];
    XCTAssertEqual(someNumber.type, OptionalTypeSome);
    XCTAssertNotNil(someNumber.value);
    XCTAssert([someNumber.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([someNumber.value integerValue], 10);
    XCTAssertEqual(noneNumber.type, OptionalTypeNone);
    XCTAssertNil(noneNumber.value);
    
    NSNumber*(^mapBlock)(NSNumber*) = ^NSNumber*(NSNumber* number) {
        return @([number integerValue]*0.5);
    };
    
    Optional* someHalfNumber = [someNumber mapOptional:mapBlock];
    XCTAssertEqual(someHalfNumber.type, OptionalTypeSome);
    XCTAssertNotNil(someHalfNumber.value);
    XCTAssert([someHalfNumber.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([someHalfNumber.value integerValue], 5);
    
    Optional* noneHalfNumber = [noneNumber mapOptional:mapBlock];
    XCTAssertEqual(noneHalfNumber.type, OptionalTypeNone);
    XCTAssertNil(noneHalfNumber.value);
}

- (void)testOptionalFlatMap {
    NSArray* array = @[@1,@2,@3];
    NSArray* doubledArray = @[@2,@4,@6];
    Optional* someArray = [Optional with:array];
    Optional* noneArray = [Optional with:nil];
    XCTAssertEqual(someArray.type, OptionalTypeSome);
    XCTAssertNotNil(someArray.value);
    XCTAssert([someArray.value isKindOfClass:[NSArray class]]);
    XCTAssertEqual([someArray.value count], 3);
    XCTAssertEqualObjects(someArray.value[1], @2);
    XCTAssertEqual(noneArray.type, OptionalTypeNone);
    XCTAssertNil(noneArray.value);
    
    Optional*(^flatMapBlockToSome)(NSArray*) = ^Optional*(NSArray* array) {
        return [Optional with:doubledArray];
    };
    
    Optional*(^flatMapBlockToNone)(NSArray*) = ^Optional*(NSArray* array) {
        return [Optional with:nil];
    };
    
    Optional* someToSomeDoubledArray = [someArray flatMapOptional:flatMapBlockToSome];
    Optional* someToNoneDoubledArray = [someArray flatMapOptional:flatMapBlockToNone];
    Optional* noneToSomeDoubledArray = [noneArray flatMapOptional:flatMapBlockToSome];
    Optional* noneToNoneDoubledArray = [noneArray flatMapOptional:flatMapBlockToNone];
    
    XCTAssertEqual(someToSomeDoubledArray.type, OptionalTypeSome);
    XCTAssertEqual(someToNoneDoubledArray.type, OptionalTypeNone);
    XCTAssertEqual(noneToSomeDoubledArray.type, OptionalTypeNone);
    XCTAssertEqual(noneToNoneDoubledArray.type, OptionalTypeNone);
    
    XCTAssertNotNil(someToSomeDoubledArray.value);
    XCTAssert([someToSomeDoubledArray.value isKindOfClass:[NSArray class]]);
    XCTAssertNil(someToNoneDoubledArray.value);
    XCTAssertNil(noneToSomeDoubledArray.value);
    XCTAssertNil(noneToNoneDoubledArray.value);
    
    XCTAssertEqualObjects(someToSomeDoubledArray.value, doubledArray);
}

- (void)testResultFailureSuccess {
    NSInteger errorCode = 12345;
    Result* success = [Result successWith:@[]];
    Result* failure = [Result failureWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
    XCTAssertEqual(success.type, ResultTypeSuccess);
    XCTAssertNotNil(success.value);
    XCTAssertNil(success.error);
    XCTAssert([success.value isKindOfClass:[NSArray class]]);
    XCTAssertEqual(failure.type, ResultTypeFailure);
    XCTAssertNotNil(failure.error);
    XCTAssertNil(failure.value);
    XCTAssert([failure.error isKindOfClass:[NSError class]]);
    XCTAssert(((NSError*)failure.error).code == errorCode);
}

- (void)testResultMap {
    NSInteger errorCode = 12345;
    Result* successNumber = [Result successWith:@10];
    Result* failureNumber = [Result failureWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
    XCTAssertEqual(successNumber.type, ResultTypeSuccess);
    XCTAssertNotNil(successNumber.value);
    XCTAssertNil(successNumber.error);
    XCTAssert([successNumber.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([successNumber.value integerValue], 10);
    XCTAssertEqual(failureNumber.type, ResultTypeFailure);
    XCTAssertNotNil(failureNumber.error);
    XCTAssertNil(failureNumber.value);
    XCTAssert([failureNumber.error isKindOfClass:[NSError class]]);
    
    NSNumber*(^mapBlock)(NSNumber*) = ^NSNumber*(NSNumber* number) {
        return @([number integerValue]*0.5);
    };
    
    Result* resultHalfNumber = [successNumber mapResult:mapBlock];
    XCTAssertEqual(resultHalfNumber.type, ResultTypeSuccess);
    XCTAssertNil(resultHalfNumber.error);
    XCTAssertNotNil(resultHalfNumber.value);
    XCTAssert([resultHalfNumber.value isKindOfClass:[NSNumber class]]);
    XCTAssertEqual([resultHalfNumber.value integerValue], 5);
    
    Result* failureHalfNumber = [failureNumber mapResult:mapBlock];
    XCTAssertEqual(failureHalfNumber.type, ResultTypeFailure);
    XCTAssertNil(failureHalfNumber.value);
    XCTAssertNotNil(failureHalfNumber.error);
    XCTAssert([failureHalfNumber.error isKindOfClass:[NSError class]]);
    XCTAssert(((NSError*)failureHalfNumber.error).code == errorCode);
}

- (void)testResultFlatMap {
    NSInteger errorCode = 12345;
    NSArray* array = @[@1,@2,@3];
    NSArray* doubledArray = @[@2,@4,@6];
    Result* successArray = [Result successWith:array];
    Result* failureArray = [Result failureWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
    XCTAssertEqual(successArray.type, ResultTypeSuccess);
    XCTAssertNotNil(successArray.value);
    XCTAssertNil(successArray.error);
    XCTAssert([successArray.value isKindOfClass:[NSArray class]]);
    XCTAssertEqual([successArray.value count], 3);
    XCTAssertEqualObjects(successArray.value[1], @2);
    XCTAssertEqual(failureArray.type, ResultTypeFailure);
    XCTAssertNil(failureArray.value);
    XCTAssertNotNil(failureArray.error);
    XCTAssertNil(failureArray.value);
    XCTAssert(((NSError*)failureArray.error).code == errorCode);
    
    Result*(^flatMapBlockToSuccess)(NSArray*) = ^Result*(NSArray* array) {
        return [Result successWith:doubledArray];
    };
    
    Result*(^flatMapBlockToFailure)(NSArray*) = ^Result*(NSArray* array) {
        return [Result failureWith:[NSError errorWithDomain:@"" code:errorCode userInfo:nil]];
    };
    
    Result* successToSuccessDoubledArray = [successArray flatMapResult:flatMapBlockToSuccess];
    Result* successToFailureDoubledArray = [successArray flatMapResult:flatMapBlockToFailure];
    Result* failureToSuccessDoubledArray = [failureArray flatMapResult:flatMapBlockToSuccess];
    Result* failureToFailureDoubledArray = [failureArray flatMapResult:flatMapBlockToFailure];
    
    XCTAssertEqual(successToSuccessDoubledArray.type, ResultTypeSuccess);
    XCTAssertEqual(successToFailureDoubledArray.type, ResultTypeFailure);
    XCTAssertEqual(failureToSuccessDoubledArray.type, ResultTypeFailure);
    XCTAssertEqual(failureToFailureDoubledArray.type, ResultTypeFailure);
    
    XCTAssertNotNil(successToSuccessDoubledArray.value);
    XCTAssertNil(successToSuccessDoubledArray.error);
    XCTAssert([successToSuccessDoubledArray.value isKindOfClass:[NSArray class]]);
    XCTAssertNil(successToFailureDoubledArray.value);
    XCTAssertNotNil(successToFailureDoubledArray.error);
    XCTAssert(((NSError*)successToFailureDoubledArray.error).code == errorCode);
    XCTAssertNil(failureToSuccessDoubledArray.value);
    XCTAssertNotNil(failureToSuccessDoubledArray.error);
    XCTAssert(((NSError*)failureToSuccessDoubledArray.error).code == errorCode);
    XCTAssertNil(failureToFailureDoubledArray.value);
    XCTAssertNotNil(failureToFailureDoubledArray.error);
    XCTAssert(((NSError*)failureToFailureDoubledArray.error).code == errorCode);
    
    XCTAssertEqualObjects(successToSuccessDoubledArray.value, doubledArray);
}

@end
