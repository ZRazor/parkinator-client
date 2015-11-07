#import <Foundation/Foundation.h>

#define API_ERROR_SUCCESS @"Success"
#define API_ERROR_INVALID_TOKEN @"AccessTokenInvalid"
#define API_ERROR_CONTRACT_ALREADY_OWNED @"ContractAlreadyOwned"

#define USER_DATA_KEY @"userData"
#define HARDWARE_SALT @"$2a$10$SjoFv3/QqcIuIxLkG3cLce"

#define MRAppDomain @"com.mayak.parkinator"

enum {
    MRLogginError = 1001,
    MRRegistrationError,
    MRRemindPasswordError,
    MRUpdateUserDataError,
    MRChangeUserPassError,
    MRGetUserDataError,
    MRItemListError,
    MRCreatePlaceError,
    MRBuyPlaceError,
    MRLoadPlaceError
};