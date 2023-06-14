//
//  RSAKeygen.c
//  Gigma
//
//  Created by Jake Chong on 09/06/2023.
//

#import "RSAManager.h"
#import "chilkatIOS/include/CkoRsa.h"
#import "MainViewController.h"
#import "chilkatIOS/include/CkoXml.h"

@interface RSAManager () {
    NSUserDefaults * userDefs;
}

@property (retain, nonatomic) CkoRsa * rsa;
@property (retain, nonatomic) CkoXml * xml;

@end

@implementation RSAManager

@synthesize rsa;
@synthesize publicKey;
@synthesize publicKeyModulus;
@synthesize privateKey;
@synthesize publicKeyExponent;
@synthesize xml;
@dynamic name;

- (instancetype) init {
    self = [super init];
    
    self.rsa = [[CkoRsa alloc] init];
    self.xml = [[CkoXml alloc] init];
    rsa.EncodingMode = @"base64";
    BOOL success;
    
    userDefs = [NSUserDefaults standardUserDefaults];
    NSString * pubKey = [userDefs stringForKey: @"RSAPublicKey"];
    if (pubKey != nil) {
        publicKey = pubKey;
        NSLog(@"herererere: %@", pubKey);
        privateKey = [userDefs stringForKey: @"RSAPrivateKey"];
    }
    else {
        success = [rsa GenerateKey: @(PUB_KEY_SIZE)];
        if (success) {
            publicKey = [rsa ExportPublicKey];
            privateKey = [rsa ExportPrivateKey];
        }
        else {
            [rsa dispose];
            return nil;
        }
    }
    
    [xml LoadXml: publicKey];
    
    publicKeyModulus = [xml GetChildContent: @"Modulus"];
    publicKeyExponent = [xml GetChildContent: @"Exponent"];
    
    return self;
}

- (NSString *) name {
    return @"name";
    //return [userDefs stringForKey: @"RSAName"];
}

- (NSString *) encryptString:(NSString *) plain withPublicKey:(NSString *) pk {
    [self.rsa ImportPublicKey: pk];
    return [rsa EncryptStringENC: plain bUsePrivateKey: NO];
}

- (NSString *) encryptString:(NSString *) plain {
    [self.rsa ImportPrivateKey: self.privateKey];
    return [rsa EncryptStringENC: plain bUsePrivateKey: YES];
}

- (NSString *) decryptString:(NSString *) plain {
    [self.rsa ImportPrivateKey: self.privateKey];
    return [rsa DecryptStringENC: plain bUsePrivateKey: YES];
}

- (NSString *) decryptString:(NSString *) plain withPublicKey:(NSString *) pk {
    [self.rsa ImportPublicKey: pk];
    return [rsa DecryptStringENC: plain bUsePrivateKey: NO];
}

- (NSString *) publicKeyWithModulus:(NSString *) modulus andExponent:(NSString *) exponent {
    return [NSString stringWithFormat: @"<RSAPublicKey><Modulus>%@</Modulus><Exponent>%@</Exponent></RSAPublicKey>", modulus, exponent];
}

- (void) dealloc {
    if ([userDefs stringForKey: @"RSAPublicKey"] == nil) {
        [userDefs setObject: publicKey forKey: @"RSAPublicKey"];
        [userDefs setObject: privateKey forKey: @"RSAPrivateKey"];
    }
}

@end
