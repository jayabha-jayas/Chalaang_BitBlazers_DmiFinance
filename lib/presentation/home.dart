import "package:dls/widgets/change_language_widget.dart";
import "package:dls/widgets/change_theme_button_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_json_view/flutter_json_view.dart";
import "package:localization/language_translate.dart";
import "package:provider/provider.dart";

import "../utilities/system_provider.dart";

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ChangeLanguageWidget(systemProvider.changeLanguage),
          ChangeThemeButtonWidget(systemProvider.toggleTheme),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          getTranslated(context, "home") as String,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to our sample application!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Collapsible', style: TextStyle()),
                    const SizedBox(height: 2),
                    JsonView.string(
                      '{"author":{"name": "Stas", "lastName": "Ilin", "githubLogin": "Frezyx", "age": 19, "man": true, "height": 186.5}}',
                      theme: const JsonViewTheme(
                          viewType: JsonViewType.collapsible),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Base',
                    ),
                    const SizedBox(height: 2),
                    JsonView.string(
                      '{"author":{"name": "Stas", "lastName": "Ilin", "githubLogin": "Frezyx", "age": 19, "man": true, "height": 186.5}}',
                      theme: const JsonViewTheme(viewType: JsonViewType.base),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Big data',
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 400,
                      child: JsonView.asset(
                        'assets/github_user.json',
                        theme: const JsonViewTheme(
                            viewType: JsonViewType.collapsible),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   child: SecondaryElevatedButton.stretched(
            //     key: ValueKey("logout_button"),
            //     onPress: () {
            //       var navigator = AutoRouter.of(context);
            //       navigator.push(LoginRoute());
            //     },
            //     child: Text(getTranslated(context, "logout") as String),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
