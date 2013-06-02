//
//  SettingsViewController.m
//  BartenderBook
//
//  Created by Maximilian Tagher on 6/1/13.
//
//

#import "SettingsViewController.h"

#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@interface SettingsViewController () <MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate>

@end

@implementation SettingsViewController

#pragma mark - Table view delegate

NSString * const reviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=545883085";

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 1: {
            
            switch (indexPath.row) {
                case 0: {
                    [self sendBugReport];
                    break;
                }
                case 1: {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [[UIApplication sharedApplication] openURL:reviewURL.URL]; // Review App
                    break;
                }
            }
            
            break;
        }
        default: {
            
            break;
        }
    }
    
    
}

#pragma mark - Sending Bug Reports (MFMailCompose)


- (void)sendBugReport
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"82 Proof feedback"];
        [mail setToRecipients:@[@"feedback.tagher@gmail.com"]];
        
        
        
        [mail addAttachmentData:[self.class debugData]
                       mimeType:@"text/plain"
                       fileName:@"debugInformation.txt"];
        [self presentViewController:mail animated:YES completion:nil];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Can't send mail"
                                    message:@"This device is not setup to deliver email. You can send me an email at feedback.tagher@gmail.com"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
    }
}

+ (NSData *)debugData
{
    NSString *deviceModel     = [[UIDevice currentDevice] model];
    NSString *iOSVersion  = [NSString stringWithFormat: @"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *marketingVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *info = @{
                           @"Device Model": deviceModel,
                           @"iOS Version": iOSVersion,
                           @"Bundle Version": bundleVersion,
                           @"Marketing Version": marketingVersionNumber,
                           };
    
    return [[info description] dataUsingEncoding:NSUTF8StringEncoding];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}





@end
