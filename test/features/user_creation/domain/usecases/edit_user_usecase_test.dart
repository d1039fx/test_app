import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/features/user_creation/data/models/user_model.dart';
import 'package:test_app/features/user_creation/domain/usescases/edit_user.dart';

// Import the generated mocks file
import 'get_users_usecase_test.mocks.dart'; // We reuse the mock from the other file

void main() {
  late EditUser editUserUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    editUserUseCase = EditUser(mockUserRepository);
  });

  group('EditUserUseCase', () {
    final tUserModel = UserModel(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1990, 1, 15),
      addresses: const <String>['123 Main St'],
    );

    test('should call updateUser on the repository with the correct user model', () async {
      // Arrange
      // Stub the updateUser method of the mock repository to complete successfully.
      // For a Future<void> method, thenAnswer((_) async => null) or thenAnswer((_) async {}) works.
      when(mockUserRepository.updateUser(userModelUpdate: anyNamed('userModelUpdate')))
          .thenAnswer((_) async {}); // Or Future.value(null)

      // Act
      await editUserUseCase.call(userModel: tUserModel);

      // Assert
      verify(mockUserRepository.updateUser(userModelUpdate: tUserModel));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should throw an exception when the repository throws an exception during user update', () async {
      // Arrange
      final tException = Exception('Failed to update user');
      when(mockUserRepository.updateUser(userModelUpdate: anyNamed('userModelUpdate')))
          .thenThrow(tException);

      // Act
      final call = editUserUseCase.call;

      // Assert
      // Expect the call to throw the same exception thrown by the repository.
      expect(
        () => call(userModel: tUserModel),
        throwsA(isA<Exception>()),
      );
      verify(mockUserRepository.updateUser(userModelUpdate: tUserModel));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
