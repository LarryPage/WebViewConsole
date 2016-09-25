//
//  WBWebViewController.m
//  WBWebViewConsole
//
//  Created by LiXiangCheng on 16/9/25.
//  Copyright © 2016年 LiXiangCheng. All rights reserved.
//

#import "WBWebViewController.h"
#import "WBUIWebView.h"
#import "WBWebViewConsole.h"
#import "WBWebDebugConsoleViewController.h"

@interface WBWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) WBUIWebView * webView;

@end

@implementation WBWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Browser";
    
    self.webView = [[WBUIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.JSBridge.interfaceName = @"UIWebViewBridge";
    self.webView.JSBridge.readyEventName = @"UIWebViewBridgeReady";
    self.webView.JSBridge.invokeScheme = @"uiwebview-bridge://invoke";
    self.webView.wb_delegate = self;
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ffan.com"]]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Console" style:UIBarButtonItemStylePlain target:self action:@selector(showConsole:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self webDebugAddContextMenuItems];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self webDebugRemoveContextMenuItems];
}

- (void)showConsole:(id)sender
{
    WBWebDebugConsoleViewController * controller = [[WBWebDebugConsoleViewController alloc] initWithConsole:_webView.console];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)webDebugAddContextMenuItems
{
    UIMenuItem * item = [[UIMenuItem alloc] initWithTitle:@"Inspect Element" action:@selector(webDebugInspectCurrentSelectedElement:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[item]];
}

- (void)webDebugRemoveContextMenuItems
{
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)webDebugInspectCurrentSelectedElement:(id)sender
{
    NSString * variable = @"WeiboConsoleLastSelection";
    
    [self.webView.console storeCurrentSelectedElementToJavaScriptVariable:variable completion:^(BOOL success) {
        if (success)
        {
            WBWebDebugConsoleViewController * consoleViewController = [[WBWebDebugConsoleViewController alloc] initWithConsole:self.webView.console];
            consoleViewController.initialCommand = variable;
            
            [self.navigationController pushViewController:consoleViewController animated:YES];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Can not get current selected element" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
