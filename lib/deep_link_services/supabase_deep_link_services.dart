import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDeepLinkServices extends SupabaseAuthState {
  @override
  void onAuthenticated(Session session) {
    print('aut');
  }

  @override
  void onErrorAuthenticating(String message) {
    print('aut');
  }

  @override
  void onPasswordRecovery(Session session) {
    print('aut');
  }

  @override
  void onUnauthenticated() {
    print('aut');
  }
}
