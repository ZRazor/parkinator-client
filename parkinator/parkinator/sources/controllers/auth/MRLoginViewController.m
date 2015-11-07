//
//  MRLoginViewController.m
//  parkinator
//
//  Created by Mikhail Zinov on 07.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "MRLoginViewController.h"
#import <PureLayout/PureLayout.h>
#import "MRConsts.h"
#import "MRAuthTextField.h"
#import "MRSubmitButton.h"

@interface MRLoginViewController ()

@property (nonatomic, strong) UITextField* loginField;
@property (nonatomic, strong) UITextField* passField;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) MRSubmitButton *submitButton;
@property (nonatomic, strong) UIButton *resetPassButton;
@property (nonatomic, strong) UIButton *registrationButton;

@property (nonatomic, strong) UIView *buttonsBoxView;


@end


@implementation MRLoginViewController
{
    NSLayoutConstraint *buttonBoxTopOffsetConst, *logoTopOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImaheView = [[UIImageView alloc] init];
    [bgImaheView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImaheView];
    [bgImaheView autoPinEdgesToSuperviewEdges];
    
    _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [bgImaheView addSubview:_logoView];
    [_logoView autoSetDimensionsToSize:CGSizeMake(80, 80)];
    [_logoView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    logoTopOffset = [_logoView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:60];
    
    _buttonsBoxView = [[UIView alloc] init];
//    [_buttonsBoxView setBackgroundColor:[UIColor redColor]];
    [bgImaheView addSubview:_buttonsBoxView];
    buttonBoxTopOffsetConst = [_buttonsBoxView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_logoView withOffset:50];
    [_buttonsBoxView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_buttonsBoxView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_buttonsBoxView autoSetDimension:ALDimensionHeight toSize:200];
    
    _loginField = [[MRAuthTextField alloc] init];
    [_buttonsBoxView addSubview:_loginField];
    [_loginField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_loginField autoSetDimensionsToSize:CGSizeMake(280, 40)];
    [_loginField autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_loginField setBackgroundColor:fieldColor];
    _loginField.userInteractionEnabled = YES;
    bgImaheView.userInteractionEnabled = YES;
    [_loginField setTextColor:textColor];
    _loginField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Логин" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    _passField = [[MRAuthTextField alloc] init];
    [_buttonsBoxView addSubview:_passField];
    [_passField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_passField autoSetDimensionsToSize:CGSizeMake(280, 40)];
    [_passField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginField withOffset:11];
    [_passField setBackgroundColor:fieldColor];
    _passField.userInteractionEnabled = YES;
    [_passField setTextColor:textColor];
    [_passField setSecureTextEntry:YES];
    _passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Пароль" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIImageView *loginIco = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login"]];
    [_loginField addSubview:loginIco];
    [loginIco autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11];
    [loginIco autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [loginIco autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:11];
    [loginIco autoSetDimensionsToSize:CGSizeMake(16, 18)];
    
    UIImageView *passIco = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass"]];
    [_passField addSubview:passIco];
    [passIco autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [passIco autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
    [passIco autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [passIco autoSetDimensionsToSize:CGSizeMake(16, 20)];
    
    _resetPassButton = [[UIButton alloc] init];
    [_buttonsBoxView addSubview:_resetPassButton];
    [_resetPassButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passField withOffset:10];
    [_resetPassButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_resetPassButton setTitle:@"Забыли пароль?" forState:UIControlStateNormal];
    [_resetPassButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resetPassButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passField];
    [_resetPassButton addTarget:self action:@selector(forgotPassAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _submitButton = [[MRSubmitButton  alloc] init];
    [_buttonsBoxView addSubview:_submitButton];
    [_submitButton autoSetDimensionsToSize:CGSizeMake(280, 40)];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_submitButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_submitButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_submitButton setTitle:@"Войти" forState:UIControlStateNormal];
    
    
    _registrationButton = [[UIButton alloc] init];
    [bgImaheView addSubview:_registrationButton];
    [_registrationButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60];
    [_registrationButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_registrationButton setTitle:@"Регистрация" forState:UIControlStateNormal];
    [_registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registrationButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passField];
    [_registrationButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_registrationButton addTarget:self action:@selector(registrationAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction
{

}

- (void)registrationAction
{

}

- (void)forgotPassAction
{

}

@end
