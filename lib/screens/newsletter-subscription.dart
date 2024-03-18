import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsletterSubscriptionPage(),
    );
  }
}

class NewsletterSubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsletter Subscription'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebViewX(
            initialContent: '''
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Newsletter Subscription</title>
                  <script src="https://static-bundles.visme.co/forms/vismeforms-embed.js"></script>
              </head>
              <body>
                  <div class="visme_d" data-title="Standard Newsletter Subscription" data-url="90x3mx0m-standard-newsletter-subscription?fullPage=true" data-domain="forms" data-full-page="true" data-min-height="100vh" data-form-id="28137"></div>
              </body>
              </html>
            ''',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        },
      ),
    );
  }
}
