//
//  RSAKeygen.h
//  Gigma
//
//  Created by Jake Chong on 09/06/2023.
//


#include <stdio.h>
#import <Foundation/Foundation.h>
#define RSA_MAGIC @"69420"
#define PUB_KEY_SIZE 2048
#define KEY_SEPARATOR @"::"

@interface RSAManager : NSObject

@property (readonly, atomic, strong) NSString * publicKey;
@property (readonly, atomic, strong) NSString * publicKeyModulus;
@property (readonly, atomic, strong) NSString * publicKeyExponent;
@property (readonly, atomic, strong) NSString * privateKey;
@property (readonly, copy, nonatomic) NSString * name;

- (NSString *) encryptString:(NSString *) plain withPublicKey:(NSString *) pk;
- (NSString *) decryptString:(NSString *) plain withPublicKey:(NSString *) pk;
- (NSString *) decryptString:(NSString *) plain;
- (NSString *) publicKeyWithModulus:(NSString *) modulus andExponent:(NSString *) exponent;

@end
