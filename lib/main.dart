import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/user_creation/data/datasources/user_local_data_source_impl.dart';
import 'features/user_creation/data/models/user_model.dart';
import 'features/user_creation/data/repositories/user_repository_impl.dart';
import 'features/user_creation/domain/usescases/create_user.dart';
import 'features/user_creation/domain/usescases/edit_user.dart';
import 'features/user_creation/domain/usescases/get_users.dart';
import 'features/user_creation/presentation/bloc/user_address_list/user_address_list_bloc.dart';
import 'features/user_creation/presentation/bloc/user_data/list/user_list_bloc.dart';
import 'features/user_creation/presentation/bloc/user_form_bloc.dart';
import 'features/user_creation/presentation/screen/user_list_screen.dart';

/// The main entry point for the application.
///
/// Initializes necessary services like Hive, date formatting, and environment variables
/// before running the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await initializeDateFormatting('es', null);
  await Hive.openBox<UserModel>('user_box');
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

/// The root widget of the application.
class App extends StatelessWidget {
  /// Creates an [App] widget.
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// The home page of the application.
///
/// This widget sets up the necessary BLoC providers for the user feature
/// and displays the [UserListScreen].
class HomePage extends StatelessWidget {
  /// Creates a [HomePage] widget.
  ///
  /// Requires a [title] for the page.
  const HomePage({super.key, required this.title});

  /// The title of the home page.
  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserListBloc>(
          create: (context) => UserListBloc(
            getUsersUseCase: GetUsersUseCase(
              UserRepositoryImpl(localDataSource: UserLocalDataSourceImpl()),
            ),
          )..add(FetchUsersEvent()),
        ),
        BlocProvider<UserFormBloc>(
          create: (context) => UserFormBloc(
            createUser: CreateUser(
              UserRepositoryImpl(localDataSource: UserLocalDataSourceImpl()),
            ),
            editUser: EditUser(
              UserRepositoryImpl(localDataSource: UserLocalDataSourceImpl()),
            ),
          ),
        ),
        BlocProvider<UserAddressListBloc>(
          create: (context) => UserAddressListBloc(
            editUser: EditUser(
              UserRepositoryImpl(localDataSource: UserLocalDataSourceImpl()),
            ),
          ),
        ),
      ],
      child: MaterialApp(home: UserListScreen()),
    );
  }
}
