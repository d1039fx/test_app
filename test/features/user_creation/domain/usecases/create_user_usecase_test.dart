import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/user_creation/domain/entities/user.dart';
import 'package:test_app/features/user_creation/domain/usescases/create_user.dart';

// Import the generated mocks file (assuming UserRepository mock is generated via another test file like get_users_usecase_test.dart)
import 'get_users_usecase_test.mocks.dart'; // We reuse the mock from the other file

void main() {
  late CreateUser createUserUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    createUserUseCase = CreateUser(mockUserRepository);
  });

  group('CreateUserUseCase', () {
    final tFirstName = 'John';
    final tLastName = 'Doe';
    final tDateOfBirth = DateTime(1990, 1, 15);
    final tAddresses = <String>['123 Main St'];
    final tUser = User(
      id: '1', // The repository is expected to assign an ID
      firstName: tFirstName,
      lastName: tLastName,
      dateOfBirth: tDateOfBirth,
      addresses: tAddresses,
    );

    test('should create user and return the user object from the repository', () async {
      // Arrange
      // Stub the createUser method of the mock repository
      // We use `anyNamed` for parameters if we don't want to match them exactly in this specific test, 
      // or we can match them exactly.
      when(mockUserRepository.createUser(
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        dateOfBirth: anyNamed('dateOfBirth'),
        addresses: anyNamed('addresses'),
      )).thenAnswer((_) async => tUser);

      // Act
      final result = await createUserUseCase.call(
        firstName: tFirstName,
        lastName: tLastName,
        dateOfBirth: tDateOfBirth,
        addresses: tAddresses,
      );

      // Assert
      expect(result, tUser);
      verify(mockUserRepository.createUser(
        firstName: tFirstName,
        lastName: tLastName,
        dateOfBirth: tDateOfBirth,
        addresses: tAddresses,
      ));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should throw an exception when the repository throws an exception during user creation', () async {
      // Arrange
      final tException = Exception('Failed to create user');
      when(mockUserRepository.createUser(
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        dateOfBirth: anyNamed('dateOfBirth'),
        addresses: anyNamed('addresses'),
      )).thenThrow(tException);

      // Act
      final call = createUserUseCase.call;

      // Assert
      expect(
        () => call(
          firstName: tFirstName,
          lastName: tLastName,
          dateOfBirth: tDateOfBirth,
          addresses: tAddresses,
        ),
        throwsA(isA<Exception>()),
      );
      verify(mockUserRepository.createUser(
        firstName: tFirstName,
        lastName: tLastName,
        dateOfBirth: tDateOfBirth,
        addresses: tAddresses,
      ));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
