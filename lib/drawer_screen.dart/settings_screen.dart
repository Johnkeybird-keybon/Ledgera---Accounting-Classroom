import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms and Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Choose Theme'),
            subtitle: const Text('Coming soon'),
            onTap: () {
              // Display a dialog or message indicating this feature is coming soon
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Choose Theme'),
                    content: const Text('This feature is coming soon.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// PrivacyPolicyScreen with updated link launcher
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            const url =
                "https://www.termsfeed.com/live/33883213-8a22-4ab3-b647-00bc31777c0f";
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const Text('Read Privacy Policy'),
        ),
      ),
    );
  }
}

// TermsAndConditionsScreen with link
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            const url =
                'https://app.websitepolicies.com/policies/view/61fsq721?fbclid=IwZXh0bgNhZW0CMTAAAR3TaI4R-4DXcz59l65byHrB_v3RoqIGenlqN70ix-R0Jp1G_CXPz6xcEXo_aem_JTdVtiXyf3rQansL9ffCuA';
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const Text('Read Terms and Conditions'),
        ),
      ),
    );
  }
}
