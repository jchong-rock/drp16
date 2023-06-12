//
//  RSAKeygen.h
//  Gigma
//
//  Created by Jake Chong on 09/06/2023.
//


#include <stdio.h>
#import <Foundation/Foundation.h>
#define RSA_MAGIC "69420"

@interface RSAManager : NSObject

@property (readonly, atomic, strong) NSString * publicKey;
@property (readonly, atomic, strong) NSString * privateKey;
@property (readonly, copy, nonatomic) NSString * name;

- (NSString *) encryptString:(NSString *) plain withPublicKey:(NSString *) pk;
- (NSString *) decryptString:(NSString *) plain;

@end
