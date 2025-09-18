import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/user_creation/domain/entities/user.dart';
import 'package:test_app/features/user_creation/domain/repositories/user_repository.dart';
import 'package:test_app/features/user_creation/domain/usescases/get_users.dart';

// Import the generated mocks file
import 'get_users_usecase_test.mocks.dart';

// Annotation to generate a mock for UserRepository
@GenerateMocks([UserRepository])
void main() {
  late GetUsersUseCase getUsersUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    // Initialize the mock repository and the use case before each test
    mockUserRepository = MockUserRepository();
    getUsersUseCase = GetUsersUseCase(mockUserRepository);
  });

  // Test group for GetUsersUseCase
  group('GetUsersUseCase', () {
    // Dummy user data for testing
    final tUser1 = User(id: '1', firstName: 'John', lastName: 'Doe', dateOfBirth: DateTime(1990, 1, 1), addresses: []);
    final tUser2 = User(id: '2', firstName: 'Jane', lastName: 'Doe', dateOfBirth: DateTime(1992, 5, 5), addresses: []);
    final tUserList = [tUser1, tUser2];

    test('should get list of users from the repository', () async {
      // Arrange
      // Stub the getUsers method of the mock repository to return a successful result
      when(mockUserRepository.getUsers()).thenAnswer((_) async => tUserList);

      // Act
      // Call the use case
      final result = await getUsersUseCase.call();

      // Assert
      // Check that the result matches the expected list of users
      expect(result, tUserList);
      // Verify that the getUsers method of the repository was called exactly once
      verify(mockUserRepository.getUsers());
      // Verify that no other methods were called on the repository
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return an empty list when the repository returns an empty list', () async {
      // Arrange
      when(mockUserRepository.getUsers()).thenAnswer((_) async => <User>[]);

      // Act
      final result = await getUsersUseCase.call();

      // Assert
      expect(result, <User>[]);
      verify(mockUserRepository.getUsers());
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should throw an exception when the repository throws an exception', () async {
      // Arrange
      final tException = Exception('Failed to fetch users');
      when(mockUserRepository.getUsers()).thenThrow(tException);

      // Act
      // We call the use case and expect it to throw an exception.
      // Note: We don't await the call directly here, as we are testing the throw.
      final call = getUsersUseCase.call;

      // Assert
      // Check that calling the use case throws the same exception thrown by the repository
      expect(() => call(), throwsA(isA<Exception>()));
      verify(mockUserRepository.getUsers());
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
