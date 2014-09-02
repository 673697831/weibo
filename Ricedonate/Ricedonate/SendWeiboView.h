//
//  SendWeiboView.h
//  Ricedonate
//
//  Created by megil on 9/1/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendWeiboView : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITextView *__input;
    UIButton *sendButton;
    UIButton *photoButton;
    UIImagePickerController* __picker;
    UIImage *__image;
}

-(void)reset;
@property(nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic, strong) UITextView *input;
@property(nonatomic, strong) UIImage *image;
@end
