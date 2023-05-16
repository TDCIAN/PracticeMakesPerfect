//
//  main.m
//  objectivec-smile-han
//
//  Created by JeongminKim on 2023/05/16.
//

#import "MyClass.h"
#import "Dog.h"

int main(int argc, const char * argv[]) {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Dog *happy = [[Dog alloc] init];
    [happy setAge:5];
    NSLog(@"해피의 나이는 %d", [happy getAge]);
    [happy setAge:2];
    NSLog(@"해피의 나이는 %d", [happy getAge]);
    [happy show];
    [pool drain];
    return 0;
}
