import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_5_future_provider/api_service.dart';
import 'package:riverpod_5_future_provider/user_model.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());

final userDataProvider = FutureProvider<List<UserModel>>((ref) {
  return ref.read(apiProvider).getUser();
});
      
void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: userData.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length, // Add itemCount
              itemBuilder: (context, index) {
                final user = data[index];
                return ListTile(
                  key: Key(user.id), // Add a key
                  title: Text("${user.firstname} ${user.lastname}"),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(child: Image.network(user.avatar)),
                );
              },
            );
          },
          error: ((error, StackTrace) => Text(error.toString())),
          loading: (() {
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }
}
