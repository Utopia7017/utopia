import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/states/global_state.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    GlobalState globalState = newValue as GlobalState;
    print("User State: {\n${globalState.userState.toString()}}");
//     print('''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "newValue": "${newValue.runtimeType}",
//   "container": "${container.depth}",
// }''');
  }
}
